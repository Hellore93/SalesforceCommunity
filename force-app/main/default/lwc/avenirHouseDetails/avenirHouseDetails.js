import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getProductPhotoGallery from '@salesforce/apex/ComunityAvenirHouseSearcher.getProductPhotoGallery';
import getProductDescription from '@salesforce/apex/ComunityAvenirHouseSearcher.getProductDescription';
import getCommentList from '@salesforce/apex/ComunityAvenirHouseSearcher.getCommentList';

const IMGURL = '/sfc/servlet.shepherd/version/download/';

export default class AvenirHouseDetails extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    clickedObjectDeailsResult
    clickedObjectDeails;
    discountPrice;
    photoGallery;
    objectToSend;
    mapMarkers;
    zoomLevel = 15;
    withDiscount;
    rating;

    connectedCallback() {
        let prodId = this.pageRef.attributes.recordId;
        getProductDescription({ houseId: prodId }).then(
            (result) => { this.clickedObjectDeails = result[0]; }
        ).catch((error) => { console.log(error); });
        this.photoGalleryFunction();
        this.getRating();
    }

    photoGalleryFunction() {
        getProductPhotoGallery({ productId: this.pageRef.attributes.recordId }).then(
            (result) => {
                this.photoGallery = result,
                    this.objectToSend = JSON.stringify(result),
                    this.mapMarkers = [{
                        location: {
                            Street: this.clickedObjectDeails.product.Street__c,
                            City: this.clickedObjectDeails.product.City__c,
                            Country: this.clickedObjectDeails.product.Country__c,
                        },
                        title: '',
                        description: '',
                    }, ];
            }
        ).catch((error) => { console.log(error); });
    };

    getRating() {
        let rating = 0;
        let resultSize = 0;
        getCommentList({ productId: this.pageRef.attributes.recordId }).then(
            result => {
                result.forEach(element => {
                    element.Approval__c == true ? {
                        a: rating += element.rating__c,
                        b: resultSize += 1
                    } : rating += 0;
                })
            }
        ).finally(() => {
            rating != 0 ? this.rating = rating / resultSize : this.rating = 0
        })

    }

    get houseObject() {
        if (this.clickedObjectDeails) {
            if (this.clickedObjectDeails.productDiscountPrice.length != 0) {
                const arrayOfPrice = [];
                this.withDiscount = 'withDiscount';
                this.clickedObjectDeails.productDiscountPrice.forEach(element => arrayOfPrice.push(element.UnitPrice));
                this.discountPrice = Math.min(...arrayOfPrice);
            }
            return this.clickedObjectDeails;
        }
        return null;
    };

    get imgUrl() {
        if (this.clickedObjectDeails) {
            const id = this.houseObject.product.DisplayUrl;
            return IMGURL + id.slice(id.length - 18);
        }
        return null;
    }
}