import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getExtraOpion from '@salesforce/apex/ComunityAvenirHouseSearcher.getExtraOpion';
import orderItemListProduct from '@salesforce/apex/ComunityAvenirHouseOrder.orderItemListProduct';

export default class AvenirHouseShoppingCartSingleItem extends LightningElement {

    @api singleCacheProduct;
    price;
    quantityValue = 1;
    day = 1;
    costRent;
    startDate;
    endDate;
    extraOptions;
    extraOpionsPrice = 0;
    totalPrice;
    checkAvil;
    checkClass = 'default';
    defaultCheckboxList = [];

    connectedCallback() {
        if (this.singleCacheProduct.prod.productDiscountPrice[0]) {
            const arrayOfPrice = []
            this.singleCacheProduct.prod.productDiscountPrice.forEach(element => arrayOfPrice.push(element.UnitPrice));
            this.price = Math.min(...arrayOfPrice);
        } else {
            this.price = this.singleCacheProduct.prod.productStandardPrice.UnitPrice;
        }
        getExtraOpion().then(
            result => {
                this.extraOptions = JSON.parse(JSON.stringify(result));
                this.setDefaultCheckbox();
            }).catch((error) => { console.log(error); });
        this.startDate = this.singleCacheProduct.startDate;
        this.endDate = this.singleCacheProduct.endDate;
        this.costRent = this.price;
        this.rentCost();
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
        this.checkClass = 'default';
        this.rentCost();
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
        this.checkClass = 'default';
        this.rentCost();
    }

    deleteFromCache(event) {
        const custEvent = new CustomEvent('callpasstoparent', {
            detail: this.singleCacheProduct.prod.product.Id
        });
        this.dispatchEvent(custEvent);
    }

    rentCost() {
        if (this.startDate && this.endDate) {
            this.day = Math.round(1 + (new Date(this.endDate) - new Date(this.startDate)) / (1000 * 3600 * 24));
            this.costRent = this.day * this.price;
            this.handleMenuSelect();
            this.changePriceEvent();
        }
    }

    @api
    getPrice() {
        return parseInt(this.totalPrice);
    }

    @api
    getObject() {
        const orderListObj = {
            startDate: new Date(this.startDate).toDateString(),
            endDate: new Date(this.endDate).toDateString(),
            cost: this.totalPrice,
            prod: this.singleCacheProduct.prod
        }
        let newBBB = JSON.parse(JSON.stringify(orderListObj));

        delete newBBB.prod.product.attributes;
        delete newBBB.prod.productStandardPrice.attributes;
        delete newBBB.prod.productStandardPrice.Pricebook2.attributes;
        if (newBBB.prod.productDiscountPrice.length > 0) {
            newBBB.prod.productDiscountPrice.forEach(element => {
                delete element.attributes;
                delete element.Pricebook2.attributes;
            })

        }
        return newBBB;
    }

    changePriceEvent() {
        const custEvent = new CustomEvent('changeprice', {
            detail: 'changePrice'
        });
        this.dispatchEvent(custEvent);
    }

    setDefaultCheckbox() {
        let price = 0;
        const receiveList = [JSON.parse(this.singleCacheProduct.extraOption)][0];
        receiveList.forEach(element => {
            this.extraOptions.map(ele => {
                if (ele.Name == element.label) {
                    ele.check = true;
                    let addingPrice = this.day * ele.UnitPrice;
                    price += addingPrice;
                }
                return ele
            });
        })
        this.extraOpionsPrice = price;
        this.totalPrice = price + this.costRent;
        this.changePriceEvent();
    }

    handleMenuSelect() {
        let price = 0;
        this.template.querySelectorAll('.extOption').forEach(element => {
            if (element.checked) {
                let addingPrice = this.day * element.value;
                price += addingPrice;
            }
        })
        this.extraOpionsPrice = price;
        this.totalPrice = price + this.costRent;
        this.changePriceEvent();
    }

    get singleProduct() {
        if (this.singleCacheProduct) {
            const price = [this.price, this.singleCacheProduct.prod.productStandardPrice.UnitPrice]
            this.price = Math.min(...price);
            return this.singleCacheProduct.prod.product;
        }
        return null;
    }

    @api getItemData() {
        return this.checkClass;
    }

    checkAvailable() {
        let tabels = [this.singleCacheProduct.prod.product.Id];
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
            this.checkClass = 'error';
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Date from: ' + startDate.toDateString() + ' to ' + endDate.toDateString() + ' is not available!',
                variant: 'error',
                mode: 'dismissable'
            }));
        } else {
            this.available = true;
            this.checkClass = 'succ';
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Your data is available!',
                variant: 'success',
                mode: 'dismissable'
            }));
        }
    }

}