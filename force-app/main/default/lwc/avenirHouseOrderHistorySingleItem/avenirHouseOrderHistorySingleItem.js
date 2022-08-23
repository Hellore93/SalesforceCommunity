import { LightningElement, api } from 'lwc';
import orderItemList from '@salesforce/apex/ComunityAvenirHouseOrder.orderItemList';
import getComplainList from '@salesforce/apex/ComunityAvenirHouseOrder.getComplainList';
import userId from '@salesforce/user/Id';

export default class AvenirHouseOrderHistorySingleItem extends LightningElement {

    @api singleOrder;
    @api showModal = false;
    label = 'Show more';
    orderItems;
    itemCase;


    connectedCallback() {
        this.actualShow();
        this.showModal = this.singleOrder.boolNew;
    }

    showMore() {
        if (this.showModal == false) {
            this.getItemCase();
            this.label = 'Hide';
            this.showModal = true;
        } else if (this.showModal == true) {
            this.label = 'Show more';
            this.showModal = false;
        }
        this.getOrderItem();
    }

    actualShow() {
        if (this.showModal == false) {
            this.label = 'Show more';
            this.showModal = false;
        } else if (this.showModal == true) {
            this.label = 'Hide';
            this.showModal = true;
        }
    }

    get createTime() {
        if (this.singleOrder) {
            return new Date(this.singleOrder.CreatedDate).toDateString();
        }
    }

    @api getSingleOrder() {
        return this.singleOrder;
    }

    @api setShowModal() {
        this.showModal = false;
        this.label == 'Hide' ? this.label = 'Show more' : null;
    }

    @api getOrderItem() {
        orderItemList({ OrderId: this.singleOrder.Id })
            .then((result) => {
                this.orderItems = result;
            })
            .catch(error => {
                console.log(error);
            });
    }

    getItemCase() {
        getComplainList({
                userId: userId,
                orderId: this.singleOrder.OrderNumber
            })
            .then((result) => {
                console.log('zaciągam casy');
                this.itemCase = result;
            })
    }
}