import { LightningElement, api, wire } from 'lwc';
import getBlacklist from '@salesforce/apex/LWC_Filmweb_Controller.getBlacklist';

import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { refreshApex } from '@salesforce/apex';

export default class FilmBlacklist extends LightningElement {

    @api filmId
    visibleBL = true;
    blacklList;

    refreshing;

    @wire(getBlacklist, {})
    data({ error, data }) {
        if (data) {
            // console.log('Wchodze w test');
            this.blacklList = data;
            // console.log(this.blacklList);
            this.handleChnage();
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    // @wire(getBlacklist, {})
    // allFilms(result) {
    //     console.log('wchodze w wire');
    //     this.refreshing = result;
    //     console.log('jestem za refreshem');
    //     if (result.data) {
    //         this.blacklList = result.data;
    //         console.log('refresh test');
    //     } else if (result.error) {
    //         console.log('Something went wrong:', result.error);
    //     }
    // };

    handleChnage(event) {

        for (let i = 0; i < this.blacklList.length; i++) {
            if (this.blacklList[i].movieIds__c === this.filmId.id) {
                this.visibleBL = false;
                break;
            } else {
                this.visibleBL = true;
            }
        }

        const blacklistVisible = new CustomEvent("progressvaluechange", {
            detail: this.visibleBL
        });

        this.dispatchEvent(blacklistVisible);
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
        // console.log('test');
        refreshApex(this.blacklList);
        refreshApex(this.getBlacklist);
    }

}