import { LightningElement, api } from 'lwc';

const IMGURL = '/sfc/servlet.shepherd/document/download/';

export default class AvenirHouseDetailsPhotoGallery extends LightningElement {
    @api photoItem;
    @api photoList;
    showModal = false;

    galleryModal() {
        this.showModal = true;
    }

    test() {
        const obj = this.photoList.find(element => this.photoItem.Id == element.Id)

    }

    get imgUrl() {
        if (this.photoItem) {
            return IMGURL + this.photoItem.ContentDocumentId;
        }
        return null;
    }

    get listOfPhoto() {
        if (this.photoList) {
            return this.photoList;
        }
        return [];
    }
}