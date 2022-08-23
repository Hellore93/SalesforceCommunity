import { LightningElement, api, wire } from 'lwc';
import sendToFrontActor from '@salesforce/apex/LWC_Filmweb_Controller.sendToFrontActor';

export default class SearchActorRecord extends LightningElement {

    @api searchFilmName;
    getActor;
    pageCounter = 1;
    disabledNaviIncrese = false;
    disabledNaviDecrese = true;
    actorId;


    @wire(sendToFrontActor, { actorName: '$searchFilmName', counter: '$pageCounter' })
    data({ error, data }) {
        if (data) {
            this.getActor = JSON.parse(data);
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    get results() {
        if (this.getActor) {
            return this.getActor.results;
        }
        return null;
    }

    handleCounterIncrese() {
        console.log(this.getFilm);
        if (this.getActor.total_pages > this.pageCounter) {
            this.pageCounter = this.pageCounter + 1;
            this.disabledNaviIncrese = false;
            this.disabledNaviDecrese = false;
        };
        if (this.getActor.total_pages == this.pageCounter) { this.disabledNaviIncrese = true };
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
        this.pageCounter = this.getActor.total_pages;
        this.disabledNaviIncrese = true;
        this.disabledNaviDecrese = false;
    }

    disabledNaviIncrese() {
        return this.disabledNaviIncrese;
    };

    disabledNaviDecrese() {
        return this.disabledNaviDecrese;
    };

    getThisItem(event) {
        this.modalShow = true;
        const itemIndex = event.currentTarget.dataset.index;
        this.actorId = itemIndex;
    };

}