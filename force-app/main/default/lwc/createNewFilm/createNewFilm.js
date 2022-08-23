import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import original_title__c from '@salesforce/schema/newFilm__c.original_title__c';
import overview__c from '@salesforce/schema/newFilm__c.overview__c';
import popularity__c from '@salesforce/schema/newFilm__c.popularity__c';
import release_date__c from '@salesforce/schema/newFilm__c.release_date__c';
import budget__c from '@salesforce/schema/newFilm__c.budget__c';
import vote_average__c from '@salesforce/schema/newFilm__c.vote_average__c';
import vote_count__c from '@salesforce/schema/newFilm__c.popularity__c'
import genres__c from '@salesforce/schema/newFilm__c.genres__c'


export default class CreateNewFilm extends LightningElement {

    newFilm;
    objectApiName = 'newFilm__c';
    fields = [original_title__c, overview__c, popularity__c,
        release_date__c, budget__c, vote_average__c, vote_count__c, genres__c
    ];


    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Account created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

}