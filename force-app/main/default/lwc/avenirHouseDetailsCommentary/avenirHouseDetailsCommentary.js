import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import saveNewCommentary from '@salesforce/apex/ComunityAvenirHouseSearcher.saveNewCommentary';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCommentList from '@salesforce/apex/ComunityAvenirHouseSearcher.getCommentList';
import { refreshApex } from '@salesforce/apex';
import Id from '@salesforce/user/Id';
import { deleteRecord } from 'lightning/uiRecordApi';

export default class AvenirHouseDetailsCommentary extends LightningElement {

    userId = Id;
    @wire(CurrentPageReference) pageRef;
    commentValue;
    starRating;
    @api recordId;
    commentaryList
    @api clickedObject;
    wiredActivities;
    userComment;
    userRating;
    userCommentId;


    @wire(getCommentList, { productId: '$clickedObject.product.Id' })
    wiredAccount(result) {
        this.wiredActivities = result;
        const { data, error } = result;
        if (data) {
            this.commentaryList = data;
            let obj = data;
            let userCommentary = obj.find(element => element.OwnerId == this.userId);
            if (userCommentary) {
                this.userCommentId = userCommentary.Id;
                this.userComment = userCommentary.Commentary__c;
                this.userRating = userCommentary.rating__c;
            }
        } else if (error) {
            console.log(error);
        }
    }

    saveComment() {
        const textarea = this.template.querySelector('lightning-textarea');
        this.commentValue = textarea.value;

        saveNewCommentary({
            commentId: this.userCommentId,
            comment: this.commentValue,
            rating: this.starRating,
            productId: this.pageRef.attributes.recordId
        }).then(
            (result) => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Adding comment success',
                    variant: 'success',
                    mode: 'dismissable'
                }));
            }).finally(() => {
            // this.refreshApexFunction();
            refreshApex(this.wiredActivities)
        }).catch((error) => {
            console.log(error);
        });
    }

    onStarRatingClick(event) {
        this.starRating = event.detail.rating;
    }

    getDeleteEvent(event) {
        deleteRecord(this.userCommentId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
            }).finally(() => {
                this.userCommentId = '';
                this.userComment = '';
                this.userRating = 0;
                refreshApex(this.wiredActivities)
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            })
    }

    refreshApexFunction() {
        refreshApex(this.wiredActivities)
    }
}