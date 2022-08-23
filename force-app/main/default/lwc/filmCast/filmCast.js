import { LightningElement, wire, api } from 'lwc';
import getFilmCast from '@salesforce/apex/LWC_Filmweb_Controller.getFilmCast';

export default class FilmCast extends LightningElement {

    @api filmId;
    filmCast;
    showFilmCast;
    actorId;

    @wire(getFilmCast, { filmId: '$filmId' })
    data({ error, data }) {
        if (data) {
            this.filmCast = JSON.parse(data);
            this.showFilmCast = true;
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    get castResults() {
        if (this.filmCast) {
            return this.filmCast;
        }
        return null;
    };

    get castResultsPhoto() {
        if (this.filmCast) {
            return this.filmCast.cast;
        }
        return null;
    };

    get returnUrl() {
        return 'https://image.tmdb.org/t/p/w600_and_h900_bestv2' + this.castResults.cast.profile_path;
    }

    getThisItem(event) {
        this.modalShow = true;
        const itemIndex = event.currentTarget.dataset.index;
        this.actorId = itemIndex;
    };
}