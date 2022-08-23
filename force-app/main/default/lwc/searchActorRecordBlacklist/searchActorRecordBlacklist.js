import { LightningElement, api, wire } from 'lwc';
import getBlacklistActor from '@salesforce/apex/LWC_Filmweb_Controller.getBlacklistActor';


export default class SearchActorRecordBlacklist extends LightningElement {

    @api actorObject;
    visibleBL = true;
    blacklList;

    @wire(getBlacklistActor, {})
    data({ error, data }) {
        if (data) {
            this.blacklList = data;
            console.log(JSON.stringify(this.actorObject));
            console.log(JSON.stringify(this.blacklList));
            this.handleChnage();
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    handleChnage(event) {

        for (let i = 0; i < this.blacklList.length; i++) {
            // console.log('test');
            if (this.blacklList[i].actorId__c === this.actorObject.id) {
                console.log('test');
                this.visibleBL = false;
                console.log(this.visibleBL);
                break;
            } else {
                console.log('jestem tu');
                this.visibleBL = true;
            }
        }

        // const blacklistVisible = new CustomEvent("progressvaluechange", {
        //     detail: this.visibleBL
        // });

        // this.dispatchEvent(blacklistVisible);
    }
}