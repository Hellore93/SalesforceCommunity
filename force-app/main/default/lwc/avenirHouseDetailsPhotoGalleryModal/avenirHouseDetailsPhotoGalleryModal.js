import { LightningElement, api, wire } from 'lwc';
const IMGURL = '/sfc/servlet.shepherd/document/download/';

export default class AvenirHouseDetailsPhotoGalleryModal extends LightningElement {
    @api currentPhoto;
    @api listPhoto;
    @api showModal;
    currentPhotoKeys;

    renderedCallback() {
        const newList = JSON.parse(this.listPhoto);
        const map1 = new Map();
        for (let i = 0; i < newList.length; i++) {
            map1.set(i, newList[i]);
        }
        const obj = [...map1].find(([key, value]) => value.Id == this.currentPhoto.Id);
        this.currentPhotoKeys = obj[0];
    }

    closeModal() {
        this.showModal = false;
    }

    next() {
        const jsonList = JSON.parse(this.listPhoto);
        const nextPhoto = this.currentPhotoKeys + 1;
        if (nextPhoto >= jsonList.length) {
            nextPhoto = jsonList.length - 1;
        }
        this.currentPhotoKeys = nextPhoto;
        this.currentPhoto = jsonList[nextPhoto];
    }

    prev() {
        const jsonList = JSON.parse(this.listPhoto);
        const nextPhoto = this.currentPhotoKeys - 1;
        if (nextPhoto < 0) {
            nextPhoto = 0;
        }
        this.currentPhotoKeys = nextPhoto;
        this.currentPhoto = jsonList[nextPhoto];
    }

    get imgUrl() {
        if (this.currentPhoto) {
            return IMGURL + this.currentPhoto.ContentDocumentId;
        }
        return null;
    }
}