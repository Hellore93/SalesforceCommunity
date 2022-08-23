import { LightningElement, api } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import currentId from '@salesforce/user/Id';

export default class AvenirHouseDetailsCommentaryPrintcomment extends LightningElement {

    @api singleComment;
    commentVisible;

    connectedCallback() {
        // this.singleComment.Approval__c == true ?
        //     this.commentVisible = true : this.commentVisible = false;
        // this.singleComment.OwnerId == currentId ?
        //     this.commentVisible = true : this.commentVisible = false;

        if (this.singleComment.Approval__c == true) {
            this.commentVisible = true
        } else {
            if (this.singleComment.OwnerId == currentId) {
                this.commentVisible = true;
            } else {
                this.commentVisible = false
            }
        }
    }

    deleteComment(event) {
        deleteRecord(this.singleComment.Id)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
            }).finally(() => {
                const custEvent = new CustomEvent('eventafterdelete', {
                    detail: 'delete'
                });
                this.dispatchEvent(custEvent);
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


    get itemData() {
        let dateToGet = new Date(this.singleComment.LastModifiedDate);
        return dateToGet.toLocaleTimeString() + " " + dateToGet.toLocaleDateString();
    }

}