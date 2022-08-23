import { api, LightningElement } from 'lwc';
import defultMoviePoster from '@salesforce/resourceUrl/defaultMovie';

export default class UpcomingFilmRecord extends LightningElement {

    @api upcomingFilmData;

    get imgAdress() {
        if (this.upcomingFilmData.backdrop_path == null) {
            return defultMoviePoster;
        } else {
            return 'https://image.tmdb.org/t/p/w600_and_h900_bestv2' + this.upcomingFilmData.backdrop_path;
        }
    }
}