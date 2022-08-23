import { LightningElement, api, wire } from 'lwc';
import getBlacklist from '@salesforce/apex/LWC_Filmweb_Controller.getBlacklist';


export default class UpcomingFilmBlacklist extends LightningElement {

    @api filmId
    visibleBL = true;
    blacklList;

    @wire(getBlacklist, {})
    data({ error, data }) {
        if (data) {
            this.blacklList = data;
            this.handleChnage();
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    handleChnage(event) {

        for (let i = 0; i < this.blacklList.length; i++) {
            if (this.blacklList[i].movieIds__c === this.filmId.id.toString()) {
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
}