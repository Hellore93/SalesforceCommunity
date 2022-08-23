import { LightningElement, api, wire, track } from 'lwc';
import sendToFront from '@salesforce/apex/LWC_Filmweb_Controller.sendToFront';
import getBlacklist from '@salesforce/apex/LWC_Filmweb_Controller.getBlacklist';

import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { refreshApex } from '@salesforce/apex';

export default class SearchFilmRecord extends LightningElement {

    @api searchFilmName;
    getFilm;
    @api pageCounter;
    disabledNaviIncrese = false;
    disabledNaviDecrese = true;
    @track modalShow = false;
    filmId;
    modalShow;

    refreshData;
    newFilm;
    newArray;
    newArrayObject;
    @track visibleBL = true;
    refreshing;

    @wire(sendToFront, { filmName: '$searchFilmName', counter: '$pageCounter' })
    allFilms(result) {
        this.refreshing = result;
        if (result.data) {
            this.getFilm = JSON.parse(result.data);
        } else if (result.error) {
            console.log('Something went wrong:', result.error);
        }
    };

    handleCounterIncrese() {
        if (this.getFilm.total_pages > this.pageCounter) {
            this.pageCounter = this.pageCounter + 1;
            this.disabledNaviIncrese = false;
            this.disabledNaviDecrese = false;
        };
        if (this.getFilm.total_pages == this.pageCounter) { this.disabledNaviIncrese = true };

    };

    handleCounterDecrese() {
        this.pageCounter = this.pageCounter - 1;
        this.disabledNaviIncrese = false;
        if (this.pageCounter == 1) {
            this.pageCounter = 1;
            this.disabledNaviDecrese = true;
        } else {
            this.disabledNaviDecrese = false;
        }

    };

    handleCounterFirst() {
        this.pageCounter = 1;
        this.disabledNaviDecrese = true;
        this.disabledNaviIncrese = false;
    };

    handleCounterLast() {
        this.pageCounter = this.getFilm.total_pages;
        this.disabledNaviIncrese = true;
        this.disabledNaviDecrese = false;
    };

    disabledNaviIncrese() {
        return this.disabledNaviIncrese;
    };

    disabledNaviDecrese() {
        return this.disabledNaviDecrese;
    };


    getThisItem(event) {
        this.modalShow = true;
        const itemIndex = event.currentTarget.dataset.index;
        this.filmId = itemIndex;
    };

    hanldeProgressValueChange(event) {
        this.visibleBL = event.detail;
    }

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        registerListener('sendNameEvent', this.setCaptureText, this);
    }

    // This method will run once the component is removed from DOM.
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    setCaptureText(objPayload) {
        refreshApex(this.refreshing);
    }

    test() {
        // console.log('test');
        refreshApex(this.refreshing);
        // eval("$A.get('e.force:refreshView').fire();");
    }

}