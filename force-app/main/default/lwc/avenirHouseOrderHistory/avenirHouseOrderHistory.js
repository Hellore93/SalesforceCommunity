import { LightningElement, wire, track } from 'lwc';
import userId from '@salesforce/user/Id';
import getOrder from '@salesforce/apex/ComunityAvenirHouseOrder.getOrder';

export default class AvenirHouseOrderHistory extends LightningElement {

    @track orderList;
    @track orderListOriginal;
    emptyList;
    wiredActivities;
    newOrder;

    getDate() {
        getOrder({ userId: userId }).then(
            result => {
                this.orderList = JSON.parse(result);
                this.orderListOriginal = JSON.parse(result);
                this.createNewObject();
            })
    }

    connectedCallback() {
        this.getDate();
    }

    createNewObject() {
        let newOrder = sessionStorage.getItem('orderId');
        sessionStorage.clear();
        this.orderList.forEach(element => {
            element.boolNew = newOrder == element.Id;
        })
    }

    pastBooking() {
        this.orderList = this.orderListOriginal.filter(element => {
            return new Date(element.EndDate) < new Date();
        })
        this.clearButton();
    }

    futureBooking() {
        this.orderList = this.orderListOriginal.filter(element => {
            return new Date(element.EffectiveDate) > new Date();
        })
        this.clearButton();
    }

    allBooking() {
        this.orderList = this.orderListOriginal;
        this.clearButton();
    }

    actualBooking() {
        this.orderList = this.orderListOriginal.filter(element => {
            return (new Date(element.EffectiveDate) < new Date() && new Date(element.EndDate > new Date()))
        })
        this.clearButton();
    }

    clearButton() {
        this.template.querySelectorAll('c-avenir-house-order-history-single-item').forEach(element => {
            element.setShowModal();
            element.getOrderItem();
        });
    }

}