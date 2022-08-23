import { LightningElement, wire } from 'lwc';
import startSearch from '@salesforce/apex/ComunityAvenirHouseSearcher.startSearch';
import pubsub from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

export default class AvenirHouseSearcher extends NavigationMixin(LightningElement) {
    @wire(CurrentPageReference) pageRef;
    houseList;
    inputTextValue;


    @wire(startSearch, { houseName: '$inputTextValue' })
    data({ error, data }) {
        if (data) {
            this.houseList = JSON.stringify(data);
            pubsub.fireEvent(this.pageRef, 'eventdetails', this.houseList);
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    sendListToAnotherComponent() {
        pubsub.fireEvent(this.pageRef, 'eventdetails', this.houseList);
    }

    handleEnter(event) {
        if (event.keyCode === 13) {
            this.inputTextValue = this.template.querySelector(".searchInput").value;
        }
    }

    goToCart() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: '/shopping-cart/'
            }
        };
        this[NavigationMixin.Navigate](config);
    }

}