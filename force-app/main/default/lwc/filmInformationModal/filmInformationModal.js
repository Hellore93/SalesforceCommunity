import { LightningElement, api, wire, track } from 'lwc';
import getFilmInformation from '@salesforce/apex/LWC_Filmweb_Controller.getFilmInformation';
import { createRecord, deleteRecord } from 'lightning/uiRecordApi';
import getMovieCommentary from '@salesforce/apex/LWC_Filmweb_Database_Controller.getMovieCommentary';
import { refreshApex } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import defultMoviePoster from '@salesforce/resourceUrl/defaultMovie';

export default class FilmInformationModal extends LightningElement {

    @api filmId;
    @api progressValue;
    filmIformation;
    modalShow = false;
    saveMovieRecord;
    favourite;
    unfavourite;
    date;

    testEdit;
    runEdit = false;
    filmCommentary;

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

    @wire(getFilmInformation, { filmId: '$filmId' })
    data({ error, data }) {
        if (data) {

            this.filmIformation = JSON.parse(data);
            console.log(this.filmIformation);
            this.modalShow = true;
            if (this.filmId.length == 18) {
                this.filmInformation = this.newFilm__c;
            }
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };


    @wire(getMovieCommentary, { filmId: '$filmId' })
    allComment(result) {
        this.refreshData = result;
        if (result.data) {
            this.filmCommentary = result.data;
            this.filmCommentary = [...Array(result.data.length).keys()].map(key => ({ key, readOnly: true, value: result.data[key] }))
        }
    }

    get results() {
        if (this.filmIformation) {
            return this.filmIformation;
        }
        return null;
    }

    closeModal(event) {
        this.modalShow = false;
    }

    get imageUrl() {
        var today = new Date();
        this.date = today.toISOString();
        var last = new Date(new Date().getFullYear(), 11, 32);
        this.date1 = last.toISOString();
        if (this.results.poster_path != null) {
            return 'https://image.tmdb.org/t/p/w600_and_h900_bestv2' + this.results.poster_path;
        } else {
            return defultMoviePoster;
        }
    }

    saveModal() {

        const comment = this.template.querySelector('[data-id="comment-01"]').value;

        var fields = {
            'Commentary__c': comment,
            'Name': this.results.original_title,
            'movieId__c': this.results.id,
            'Creator__c': this.name,
            'CreateData__c': this.date
        }

        if (fields.Commentary__c != null || fields.Commentary__c != '') {

            const createRecordFields = { apiName: 'Movie_Films__c', fields };

            createRecord(createRecordFields)
                .then(contact => {
                    return refreshApex(this.refreshData)
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }

    deleteComment(event) {
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
        for (const item of this.filmCommentary) {
            item.readOnly = true;
        }
        this.testEdit = event.detail.Id;

        this.filmCommentary[event.detail.IndexField].readOnly = false;
        this.filmCommentary = [...this.filmCommentary];

    }

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm' + event.detail.fields);
    }

    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
        refreshApex(this.refreshData)
    }

}