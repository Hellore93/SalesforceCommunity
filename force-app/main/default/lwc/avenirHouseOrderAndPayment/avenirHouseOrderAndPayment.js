import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import Salesforce_Images from '@salesforce/resourceUrl/visaIcon';
import createOrder from '@salesforce/apex/ComunityAvenirHouseOrder.createOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import clearShoppingCart from '@salesforce/apex/ComunityAvenirHouseCache.clearShoppingCart';

export default class AvenirHouseOrderAndPayment extends NavigationMixin(LightningElement) {

    @track currentUserName;
    visaIcon = Salesforce_Images;
    @wire(CurrentPageReference) pageRef;
    @track orderList;
    totalPrice;
    buttonDisable = true;

    connectedCallback() {
        if (sessionStorage.getItem('orderItem')) {
            this.orderList = JSON.parse(sessionStorage.getItem('orderItem'));
            sessionStorage.clear();
            this.getTotalPrice();
        }
    }

    getTotalPrice() {
        let newArray = [];
        const priceArray = this.orderList.forEach(element => newArray.push(element.cost));
        this.totalPrice = newArray.reduce((a, b) => a + b, 0);
    }

    disableButton(event) {
        this.buttonDisable = false;
    }

    rent() {
        let objToSend = [];

        this.orderList.forEach(function(element) {
            let newObj = {};
            newObj.startDate = new Date(element.startDate);
            newObj.endDate = new Date(element.endDate);
            newObj.cost = element.cost;
            newObj.prod = element.prod;
            objToSend.push(newObj);
            newObj = {};
        })
        createOrder({ 'orderObject': objToSend }).then(
            (result) => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Your rent proccess over with success',
                    variant: 'success',
                    mode: 'dismissable'
                }));
                sessionStorage.setItem('orderId', result.Id);
                const config = {
                    type: 'standard__webPage',
                    attributes: {
                        url: '/order-history/'
                    }
                };
                clearShoppingCart({});
                this[NavigationMixin.Navigate](config);
            }).catch((error) => { console.log(error); })
    }
}