import { LightningElement, track, wire, api } from 'lwc';


export default class MovieService extends LightningElement {

    searchFilmName;
    searchFilmCheckbox;
    searchActorCheckbox;
    filmDisable = false;
    actorDisable = false;
    pageCounter;
    createNewRecordModal = false;

    handleFilmSearch(event) {
        this.searchFilmName = event.detail.value;
        this.pageCounter = 1;
    };

    searchFilmHandle(event) {
        this.searchFilmCheckbox = event.detail.checked;
        this.actorDisable = event.detail.checked;
    };

    searchActorHandle(event) {
        this.searchActorCheckbox = event.detail.checked;
        this.filmDisable = event.detail.checked;
    };

}