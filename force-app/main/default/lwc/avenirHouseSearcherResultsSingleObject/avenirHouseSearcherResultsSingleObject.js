import { LightningElement, api, wire, track } from 'lwc';
import pubsub from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

const IMGURL = '/sfc/servlet.shepherd/version/download/';

export default class AvenirHouseSearcherResultsSingleObject extends NavigationMixin(LightningElement) {
    @wire(CurrentPageReference) pageRef;
    @api singleHouseObject;
    discountPrice;
    priceClass = 'priceText';

    @track url;

    get result() {
        if (this.singleHouseObject) {
            this.isDiscountExist();
            return this.singleHouseObject.product;
        }
        return null;
    };

    get price() {
        if (this.singleHouseObject) {
            return this.singleHouseObject;
        }
        return null;
    };

    get imgUrl() {
        if (this.result.Id) {
            const id = this.result.DisplayUrl;
            return IMGURL + id.slice(id.length - 18);
        }
    };

    isDiscountExist() {
        if (this.price.productDiscountPrice[0]) {
            const arrayOfPrice = []
            this.price.productDiscountPrice.forEach(element => arrayOfPrice.push(element.UnitPrice));
            this.discountPrice = Math.min(...arrayOfPrice);
            this.priceClass = 'oldPrice';
        }
    };

    showDetails() {
        pubsub.fireEvent(this.pageRef, 'productDetail', this.singleHouseObject);
        localStorage['clickedElement'] = JSON.stringify(this.singleHouseObject);
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: '/detail/' + this.result.Id
            }
        };
        this[NavigationMixin.Navigate](config);
    }

}