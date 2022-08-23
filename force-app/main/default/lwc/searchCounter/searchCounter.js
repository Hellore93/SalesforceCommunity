import { LightningElement, api } from 'lwc';

export default class SearchCounter extends LightningElement {

    @api getCounter
    pageCounter = 1;
    disabledNaviIncrese = false;
    disabledNaviDecrese = true;

    handleCounterIncrese() {
        console.log(this.getCounter);
        if (this.getCounter > this.pageCounter) {
            this.pageCounter = this.pageCounter + 1;
            this.disabledNaviIncrese = false;
            this.disabledNaviDecrese = false;
        };
        if (this.getCounter == this.pageCounter) { this.disabledNaviIncrese = true };
    }

    handleCounterDecrese() {
        console.log(this.getCounter);
        this.pageCounter = this.pageCounter - 1;
        this.disabledNaviIncrese = false;
        if (this.pageCounter == 1) {
            this.pageCounter = 1;
            this.disabledNaviDecrese = true;
        } else {
            this.disabledNaviDecrese = false;
        }
    }

    disabledNaviIncrese() {
        return this.disabledNaviIncrese;
    }

    disabledNaviDecrese() {
        return this.disabledNaviDecrese;
    }
}