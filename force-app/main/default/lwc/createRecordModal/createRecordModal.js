import { LightningElement } from 'lwc';

export default class CreateRecordModal extends LightningElement {

    createNewRecordModal;
    searchFilmCheckbox;
    searchActorCheckbox;
    filmDisable = false;
    actorDisable = false;

    searchFilmHandle(event) {
        this.searchFilmCheckbox = event.detail.checked;
        this.actorDisable = event.detail.checked;
    };

    searchActorHandle(event) {
        this.searchActorCheckbox = event.detail.checked;
        this.filmDisable = event.detail.checked;
    };

    createNewRecord() {
        this.createNewRecordModal = true;
    }

    closeModal() {
        this.createNewRecordModal = false;
        this.searchActorCheckbox = false;
        this.searchFilmCheckbox = false;
        this.filmDisable = false;
        this.actorDisable = false;
    }
}