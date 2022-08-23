import { LightningElement, api, wire } from 'lwc';
import getActorRating from '@salesforce/apex/LWC_Filmweb_Database_Controller.getActorRating';
import { refreshApex } from '@salesforce/apex';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import OwnerId from '@salesforce/user/Id';

export default class StarRatingActor extends LightningElement {

    packagerating;
    @api actorId;
    favourite;
    unfavourite;
    @api actorName;


    showFavourite;
    showUnfavourite;
    ratingCounterShow;
    ratingCounter;
    openChange = false;
    addingMethod;
    refreshing;
    allRating;

    @wire(getActorRating, { OwnerId: OwnerId, actorId: '$actorId' })
    allRating(result) {
        this.refreshing = result;
        if (result.data) {
            this.movieRating = result.data;
            this.showFavourite = result.data.favourite__c;
            this.showUnfavourite = result.data.unfavourite__c;
            if (result.data.Rating__c > 0) {
                this.ratingCounterShow = true;
                this.ratingCounter = result.data.Rating__c;
            } else {
                this.ratingCounterShow = false;
                this.ratingCounter = result.data.Rating__c;
            }
        } else if (result.error) {
            console.log('Something went wrong:', result.error);
        }
    };

    rating(event) {
        if (event.target.name === "Package") {
            this.packagerating = event.target.value;
        }
    }

    saveRating() {

        const select = this.template.querySelector('[data-id="select-01"]').value;
        if (select === 'Favourite') {
            this.favourite = true;
            this.unfavourite = false;
        } else if (select === 'Unfavourite') {
            this.favourite = false;
            this.unfavourite = true;
        } else {
            this.favourite = false;
            this.unfavourite = false;
        }

        var fields = {
            'favourite__c': this.favourite,
            'unfavourite__c': this.unfavourite,
            // 'movieId__c': this.actorId,
            'actorId__c': this.actorId,
            'ActorName__c': this.actorName,
            'Rating__c': this.packagerating
        }

        const createRecordFields = { apiName: 'Movie_Actor_Rating__c', fields };

        if (this.movieRating == undefined) {

            createRecord(createRecordFields)
                .then(contact => {
                    this.openChange = false;
                    refreshApex(this.refreshing);
                })
                .catch((error) => {
                    console.log(error);
                });;
        } else {
            var fields = {
                'Id': this.movieRating.Id,
                'favourite__c': this.favourite,
                'unfavourite__c': this.unfavourite,
                // 'movieId__c': this.actorId,
                'actorId__c': this.actorId,
                'ActorName__c': this.actorName,
                'Rating__c': this.packagerating
            }
            const createRecordFields = { fields };

            updateRecord(createRecordFields)
                .then(contact => {
                    this.openChange = false;
                    refreshApex(this.refreshing);
                })
                .catch((error) => {
                    console.log(error);
                });;
        }
    }

    changeFunction() {
        this.openChange = true;
    }

    closeRating() {
        this.openChange = false;
    }
}