import { LightningElement, api, wire } from 'lwc';
import getActorFilms from '@salesforce/apex/LWC_Filmweb_Controller.getActorFilms';

export default class ActorFilms extends LightningElement {

    @api actorId;
    actorFilms;
    showFilmCast;
    filmId;

    @wire(getActorFilms, { actorId: '$actorId' })
    data({ error, data }) {
        if (data) {
            this.actorFilms = JSON.parse(data);
            this.showFilmCast = true;
            console.log(JSON.parse(data));
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    get castResults() {
        if (this.actorFilms) {
            return this.actorFilms;
        }
        return null;
    };

    get castResultsPhoto() {
        if (this.filmCast) {
            return this.actorFilms.cast;
        }
        return null;
    };

    get returnUrl() {
        return 'https://image.tmdb.org/t/p/w600_and_h900_bestv2' + this.castResultsPhoto.poster_path;
    }

    getThisItem(event) {
        this.modalShow = true;
        const itemIndex = event.currentTarget.dataset.index;
        this.filmId = itemIndex;
    };
}