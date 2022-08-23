import { LightningElement, api, wire, track } from "lwc";
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import OwnerId from '@salesforce/user/Id';
import getMovieRating from '@salesforce/apex/LWC_Filmweb_Database_Controller.getMovieRating';
import { refreshApex } from '@salesforce/apex';

import pubsub from "c/pubsub";
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';

export default class ChildRating extends LightningElement {
    packagerating;
    @api filmId;
    favourite;
    unfavourite;
    @api filmTitle;


    showFavourite;
    showUnfavourite;
    ratingCounterShow;
    ratingCounter;
    openChange = false;
    addingMethod;
    refreshing;
    allRating;


    @wire(getMovieRating, { OwnerId: OwnerId, filmId: '$filmId' })
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
            'movieIds__c': this.filmId,
            'MovieName__c': this.filmTitle,
            'Rating__c': this.packagerating
        }

        const createRecordFields = { apiName: 'Movie_Film_Rating__c', fields };

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
                'movieIds__c': this.filmId,
                'MovieName__c': this.filmTitle,
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

        this.publishEvent();
    }

    changeFunction() {
        this.openChange = true;
    }

    closeRating() {
        this.openChange = false;
    }

    @wire(CurrentPageReference) objpageReference;
    strText = 'refresh';

    publishEvent() {
        fireEvent(this.objpageReference, 'sendNameEvent', this.strText);
        this.handleIsLoading(isLoading);
    }

    handleIsLoading(isLoading) {
        this.isLoading = isLoading;
    }
}