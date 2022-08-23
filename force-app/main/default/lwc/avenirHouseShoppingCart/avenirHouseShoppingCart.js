import { LightningElement, wire } from 'lwc';
import getCache from '@salesforce/apex/ComunityAvenirHouseCache.getCache';
import { refreshApex } from '@salesforce/apex';
import removeFromCache from '@salesforce/apex/ComunityAvenirHouseCache.removeFromCache';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class AvenirHouseShoppingCart extends NavigationMixin(LightningElement) {

    cacheItem;
    wiredActivities;
    startDate;
    endDate;
    totalPrice = 0;
    checkAvil;

    @wire(getCache)
    wiredResult(result) {
        this.wiredActivities = result;
        const { data, error } = result;
        if (data) {
            this.cacheItem = [];
            if (data.length != 0) {
                this.cacheItem = JSON.parse(data);
            }
        }
        if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    connectedCallback() {
        this.getTotalPrice;
        refreshApex(this.wiredActivities);
    }

    passToParent(event) {
        removeFromCache({ productId: event.detail }).then(
            (result) => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Delete from cart success',
                    variant: 'success',
                    mode: 'dismissable'
                }));
            }).finally(
            () => {
                refreshApex(this.wiredActivities),
                    setTimeout(() => {
                        this.changePrice(event);
                    }, "500")
            }
        ).catch((error) => { console.log(error); });
    }

    changePrice(event) {
        this.getTotalPrice();
    }

    getTotalPrice() {
        let newArray = [];
        const priceArray = this.template.querySelectorAll('c-avenir-house-shopping-cart-single-item').forEach(element => newArray.push(element.getPrice()));
        this.totalPrice = newArray.reduce((a, b) => a + b, 0);
    }

    rentAll() {
        let itemMessageList = [];
        this.template.querySelectorAll('c-avenir-house-shopping-cart-single-item').forEach(element => {
            itemMessageList.push(element.getItemData());
        });
        if (itemMessageList.includes('error') || itemMessageList.includes('default')) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Once of your position have wrong or was not checked!',
                variant: 'error',
                mode: 'dismissable'
            }));
        } else {
            this.rentAllMethod();
        }
    }

    rentAllMethod() {
        let newArray = [];
        const priceArray = this.template.querySelectorAll('c-avenir-house-shopping-cart-single-item').forEach(element => newArray.push(element.getObject()));
        sessionStorage.setItem('orderItem', JSON.stringify(newArray));
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: '/order-and-payment/'
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    test() {
        let newArray = [];
        const priceArray = this.template.querySelectorAll('c-avenir-house-shopping-cart-single-item').forEach(element => newArray.push(element.getObject()));
    }
}