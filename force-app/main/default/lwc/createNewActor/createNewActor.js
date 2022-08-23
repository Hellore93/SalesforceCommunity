import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import biography__c from '@salesforce/schema/newActor__c.biography__c';
import birthday__c from '@salesforce/schema/newActor__c.birthday__c';
import deathday__c from '@salesforce/schema/newActor__c.deathday__c';
import gender__c from '@salesforce/schema/newActor__c.gender__c';
import name__c from '@salesforce/schema/newActor__c.name__c';
import place_of_birth__c from '@salesforce/schema/newActor__c.place_of_birth__c';
import popularity__c from '@salesforce/schema/newActor__c.popularity__c';
import profile_path__c from '@salesforce/schema/newActor__c.profile_path__c';
import newFilm__c from '@salesforce/schema/newActor__c.newFilm__c';


export default class CreateNewActor extends LightningElement {

    newFilm;
    objectApiName = 'newActor__c';
    fields = [biography__c, birthday__c, deathday__c, gender__c,
        name__c, place_of_birth__c, popularity__c, profile_path__c, newFilm__c
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