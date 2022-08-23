import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import orderItemListProduct from '@salesforce/apex/ComunityAvenirHouseOrder.orderItemListProduct';
import getExtraOpion from '@salesforce/apex/ComunityAvenirHouseSearcher.getExtraOpion';
import clearShoppingCart from '@salesforce/apex/ComunityAvenirHouseCache.clearShoppingCart';
import addToCache from '@salesforce/apex/ComunityAvenirHouseCache.addToCache';
import pubsub from 'c/pubsub';

export default class AvenirHouseDetailsRent extends NavigationMixin(LightningElement) {

    @wire(CurrentPageReference) pageRef;
    counter = 1;
    @api clickedObject;
    startDate;
    endDate;
    day = 1;
    costRent;
    price;
    orderList;
    checkAvil;
    extraOptions;
    extraOpionsList = [];
    totalPriceList;
    available;

    connectedCallback() {
        var today = new Date();
        this.startDate = today.toISOString();
        this.endDate = today.toISOString();
        if (this.clickedObject.productDiscountPrice[0]) {
            const arrayOfPrice = []
            this.clickedObject.productDiscountPrice.forEach(element => arrayOfPrice.push(element.UnitPrice));
            this.price = Math.min(...arrayOfPrice);
        } else {
            this.price = this.clickedObject.productStandardPrice.UnitPrice;
        }
        this.costRent = this.day * this.price;

        getExtraOpion().then(
            result => {
                this.extraOptions = result
            }).catch((error) => { console.log(error); });

        this.totalPrice();
    }

    decrement() {
        const count = this.counter;
        this.counter = count - 1;
        if (this.counter < 1) {
            this.counter = 1;
        }
    }

    increse() {
        const count = this.counter;
        this.counter = count + 1;
        if (this.counter > 9) {
            this.counter = 9;
        }
    }

    getStartDate(event) {
        if (new Date(event.target.value).toISOString() < this.startDate ||
            new Date(event.target.value).toISOString() > this.endDate) {
            this.startDate = new Date().toISOString();
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Start date before today or end date',
                    variant: 'error',
                })
            );
        } else {
            this.startDate = new Date(event.target.value).toISOString();
        }
        this.calculate();
    }

    getEndDate(event) {
        if (new Date(event.target.value).toISOString() < this.startDate) {
            this.endDate = new Date().toISOString();
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'End date before start date',
                    variant: 'error',
                })
            );
        } else {
            this.endDate = new Date(event.target.value).toISOString();
        }
        this.calculate();
    }

    calculate() {
        if (this.startDate && this.endDate) {
            this.day = Math.round(1 + (new Date(this.endDate) - new Date(this.startDate)) / (1000 * 3600 * 24));
            this.costRent = this.day * this.price;
            this.handleMenuSelect();
        }
    }

    goToPayment() {
        if (this.startDate && this.endDate && this.costRent && this.available == true) {
            const orderList = [];
            const orderListObj = {
                startDate: new Date(this.startDate).toDateString(),
                endDate: new Date(this.endDate).toDateString(),
                cost: this.totalPriceList,
                prod: this.clickedObject
            }
            orderList.push(orderListObj);
            sessionStorage.setItem('orderItem', JSON.stringify(orderList));
            const config = {
                type: 'standard__webPage',
                attributes: {
                    url: '/order-and-payment/'
                }
            };
            clearShoppingCart({});
            this[NavigationMixin.Navigate](config);
        } else {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'To rent this house you should choince start and end date and check avilable!',
                variant: 'error',
                mode: 'dismissable'
            }));
        }
    }

    checkAvailable() {
        let tabels = [this.pageRef.attributes.recordId];
        orderItemListProduct({ ProductId: tabels }).then(
            (result) => {
                this.checkAvil = result;
            }
        ).finally(
            this.checkAvailableMethod()
        ).catch((error) => { console.log(error); })

    }

    checkAvailableMethod() {
        let startDate = new Date(this.startDate);
        let endDate = new Date(this.endDate);
        let overlapObject = []
        if (this.checkAvil) {
            this.checkAvil.forEach(element => {
                if (
                    (startDate > new Date(element.ServiceDate) && startDate < new Date(element.EndDate)) ||
                    (endDate > new Date(element.ServiceDate) && endDate < new Date(element.EndDate)) ||
                    (startDate < new Date(element.ServiceDate) && endDate > new Date(element.EndDate))
                ) {
                    overlapObject.push(element);
                }

            })
            this.message(startDate, endDate, overlapObject);
        }
    }

    message(startDate, endDate, overlapObject) {
        if (overlapObject.length > 0) {
            this.available = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Date from: ' + startDate.toDateString() + ' to ' + endDate.toDateString() + ' is not available!',
                variant: 'error',
                mode: 'dismissable'
            }));
        } else {
            this.available = true;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Your data is available!',
                variant: 'success',
                mode: 'dismissable'
            }));
        }
    }

    handleMenuSelect() {
        let price = []
        this.template.querySelectorAll('.extOption').forEach(element => {
            if (element.checked) {
                let addingPrice = this.day * element.value;
                price.push(
                    element = {
                        name: element.label,
                        unitPrice: element.value,
                        price: addingPrice
                    });
            }
        })
        this.extraOpionsList = price;
        this.totalPrice();
    }

    totalPrice() {
        setTimeout(() => {
            let sumPriceSelector = 0;
            this.template.querySelectorAll('.extraPrice').forEach(element => {

                const word = element.outerText.split(' ')[0];
                sumPriceSelector += parseInt(word);
            })
            this.totalPriceList = sumPriceSelector + this.costRent;
        }, 0)
    }

    addToCart() {
        let extraArray = [];
        this.template.querySelectorAll('.extOption').forEach(element => {
            if (element.checked) {
                const elem = { label: element.label, id: element.name, value: element.value }
                extraArray.push(elem);
            }
        });

        addToCache({
            product: this.clickedObject.product,
            standardPrice: this.clickedObject.productStandardPrice,
            discountPrice: this.clickedObject.productDiscountPrice,
            startDate: this.startDate,
            endDate: this.endDate,
            extraOption: JSON.stringify(extraArray)
        }).then(
            (result) => {
                pubsub.fireEvent(this.pageRef, 'cacheObject', result)
            }
        ).finally(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Adding to cart success',
                variant: 'success',
                mode: 'dismissable'
            }));
        }).catch((error) => { console.log(error); });
    }
}