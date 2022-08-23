import { LightningElement, api } from 'lwc';
import getComplainList from '@salesforce/apex/ComunityAvenirHouseOrder.getComplainList';
import userId from '@salesforce/user/Id';

export default class AvenirHouseOrderHistorySingleItemModal extends LightningElement {

    @api singleOrder;
    // Order Number do Case
    @api orderItems;
    // lista order itemów
    @api itemCase;
    // lista casów dla usera


    // connectedCallback() {
    //     console.log(JSON.parse(JSON.stringify(this.itemCase)));
    // }

    // test() {
    //     console.log(JSON.parse(JSON.stringify(this.itemCase)));
    // }
}