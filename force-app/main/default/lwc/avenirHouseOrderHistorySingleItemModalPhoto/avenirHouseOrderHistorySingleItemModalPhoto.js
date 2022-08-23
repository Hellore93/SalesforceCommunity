import { LightningElement, api } from 'lwc';
const IMGURL = '/sfc/servlet.shepherd/version/download/';

export default class AvenirHouseOrderHistorySingleItemModalPhoto extends LightningElement {

    @api orderItem;

    get imgUrl() {
        if (this.orderItem) {
            const id = this.orderItem.Product2.DisplayUrl;
            return IMGURL + id.slice(id.length - 18);
        }
    };
}