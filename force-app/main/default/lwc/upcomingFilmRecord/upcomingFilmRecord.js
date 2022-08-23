import { LightningElement, wire, track } from 'lwc';
import getUpcomingFilms from '@salesforce/apex/LWC_Filmweb_Controller.getUpcomingFilms';



export default class UpcomingFilmRecord extends LightningElement {

    @track getUpcomingFilm;
    pageCounter = 1;
    disabledNaviIncrese = false;
    disabledNaviDecrese = true;
    filmId;


    @wire(getUpcomingFilms, { counter: '$pageCounter' })
    data({ error, data }) {
        if (data) {
            this.getUpcomingFilm = JSON.parse(data);
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    get results() {
        if (this.getUpcomingFilm) {
            return this.getUpcomingFilm.results;
        }
        return null;
    };

    get counter() {
        if (this.getUpcomingFilm.total_pages) {
            return this.getUpcomingFilm.total_pages;
        }
        return null;
    };

    handleCounterIncrese() {
        if (this.getUpcomingFilm.total_pages > this.pageCounter) {
            this.pageCounter = this.pageCounter + 1;
            this.disabledNaviIncrese = false;
            this.disabledNaviDecrese = false;
        };
        if (this.getUpcomingFilm.total_pages == this.pageCounter) { this.disabledNaviIncrese = true };
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
        this.pageCounter = this.getUpcomingFilm.total_pages;
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

}