import { LightningElement, api, wire, track } from 'lwc';
import getActorById from '@salesforce/apex/LWC_Filmweb_Controller.getActorById';
import { createRecord, deleteRecord } from 'lightning/uiRecordApi';
import getActorCommentary from '@salesforce/apex/LWC_Filmweb_Database_Controller.getActorCommentary';
import { refreshApex } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import defauldMaleActor from '@salesforce/resourceUrl/defaultActor';
import defauldFemaleActor from '@salesforce/resourceUrl/defaultFemaleAvatar';

export default class ActorInformationModal extends LightningElement {

    @api actorId;
    actorInformation;
    modalShow = false;
    actorCommentary;
    date;

    @track name;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.name = data.fields.Name.value;
        }
    }

    @wire(getActorById, { actorId: '$actorId' })
    data({ error, data }) {
        if (data) {
            this.actorInformation = JSON.parse(data);
            this.modalShow = true;
            console.log(JSON.parse(data));
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    get results() {
        if (this.actorInformation) {
            return this.actorInformation;
        }
        return null;
    }

    @wire(getActorCommentary, { actorId: '$actorId' })
    allComment(result) {
        this.refreshData = result;
        if (result.data) {
            console.log(result);
            this.actorCommentary = result.data;
            this.actorCommentary = [...Array(result.data.length).keys()].map(key => ({ key, readOnly: true, value: result.data[key] }))
            console.log(this.actorCommentary);
        }
    }


    closeModal(event) {
        this.modalShow = false;
    }

    get imageUrl() {
        if (this.results.profile_path == null && this.results.gender == 2) {
            return defauldMaleActor;
        } else if (this.results.profile_path == null && this.results.gender != 2) {
            return defauldFemaleActor;
        } else {
            return 'https://image.tmdb.org/t/p/w600_and_h900_bestv2' + this.results.profile_path;
        }
    }

    saveModal() {
        var today = new Date();
        this.date = today.toISOString();
        var last = new Date(new Date().getFullYear(), 11, 32);
        this.date1 = last.toISOString();

        const comment = this.template.querySelector('[data-id="comment-01"]').value;

        var fields = {
            'Commentary__c': comment,
            'Name': this.results.name,
            'actorId__c': this.results.id,
            'Creator__c': this.name,
            'CreateData__c': this.date
        }

        const createRecordFields = { apiName: 'Movie_Actor__c', fields };

        createRecord(createRecordFields)
            .then(contact => {
                console.log(contact);
                return refreshApex(this.refreshData)
            })
            .catch((error) => {
                console.log(error);
                console.log(error.body.message);
            });
    }

    deleteComment(event) {
        console.log(event.detail.Id);
        deleteRecord(event.detail.Id).then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Record deleted',
                variant: 'success'
            }));
            refreshApex(this.refreshData)
        })
    };

    handleEdit(event) {
        for (const item of this.actorCommentary) {
            item.readOnly = true;
        }
        console.log('test1');
        console.log(event.detail);
        this.testEdit = event.detail.Id;
        console.log('test 2');

        this.actorCommentary[event.detail.IndexField].readOnly = false;
        this.actorCommentary = [...this.actorCommentary];

    }

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm' + event.detail.fields);
    }

    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
        refreshApex(this.refreshData)
    }
}