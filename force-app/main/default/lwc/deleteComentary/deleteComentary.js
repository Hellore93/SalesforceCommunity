import { LightningElement, api } from 'lwc';

export default class DeleteComentary extends LightningElement {

    @api parentParam;
    @api indexFields;

    callDelete(event) {
        let param = { Id: this.parentParam.Id };
        let ev = new CustomEvent('deletecomment', { detail: param });
        this.dispatchEvent(ev);
    }

    callEdit(event) {
        let param = { Id: this.parentParam.Id, IndexField: this.indexFields };
        let ev = new CustomEvent('editcomment', { detail: param });
        this.dispatchEvent(ev);
    }
}