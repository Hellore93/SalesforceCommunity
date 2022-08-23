import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AvenirHouseOrderHistoryComplain extends LightningElement {

    @api singleOrder;
    @api orderItems;
    createComplain = false;
    caseInfo;
    buttonLabel = 'Complain';

    _itemCase;

    @api
    get itemCase() {
        return this._itemCase;
    }
    set itemCase(value) {

        if (value) {
            const val = JSON.parse(JSON.stringify(value));
            console.log(this.orderItems);
            this._itemCase = val[0];
        } else {
            this._itemCase = null;
        }
        this.check();
    }

    check() {
        if (this.itemCase != null && this.itemCase.Product_To_Case__c == this.orderItems.Product2Id) {
            this.caseInfo = true;
            this.buttonLabel = 'Status';
        } else {
            this.caseInfo = false;
            this.buttonLabel = 'Complain';
        }
    }

    complain() {
        this.createComplain = true;
    }

    close() {
        this.createComplain = false;
    }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Product_To_Case__c = this.orderItems.Product2Id;
        fields.Order_Number__c = this.singleOrder.OrderNumber;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'You create a complain form, please wait for contact with our employee',
                variant: 'success',
                mode: 'dismissable'
            }));
        this.close();
    }

    get complainItem() {
        if (this.itemCase) {
            this.caseInfo = true
            return this.itemCase;
        }
        return null;
    }

    get createdData() {
        if (this.itemCase != null) {
            return new Date(this.itemCase.CreatedDate).toDateString();
        }
        return null;
    }
}