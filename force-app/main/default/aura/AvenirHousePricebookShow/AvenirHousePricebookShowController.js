({

    init: function(cmp, evt, helper) {
        var actions = [
            { label: 'Edit Pricebook', name: 'edit_pricebook' },
            { label: 'Edit Discount', name: 'edit_discount' },
            { label: 'Delete', name: 'delete' }
        ]

        cmp.set('v.mycolumns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Description', fieldName: 'Description', type: 'text' },
            { label: 'Active', fieldName: 'IsActive', type: 'boolean' },
            { label: 'Discount Start', fieldName: 'Discount_Start__c', type: 'date' },
            { label: 'Discount Finish', fieldName: 'Discount_Finish__c', type: 'date' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        var action = cmp.get('c.getAllPricebook');
        helper.getData(cmp, action);
    },

    handleRowAction: function(cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit_pricebook':
                cmp.set('v.pricebookId', row.Id);
                cmp.set('v.editPricebook', true);
                cmp.set('v.table', false);
                break;
            case 'edit_discount':
                cmp.set('v.pricebookId', row.Id);
                cmp.set('v.editDiscount', true);
                cmp.set('v.table', false);
                cmp.set('v.selectedRows', []);
                helper.editDiscount(cmp, row);
                break;
            case 'delete':
                cmp.set('v.selectedRows', []);
                helper.deleteRow(cmp, row);
                break;
        }
    },

    closeModal: function(cmp, evt) {
        cmp.set('v.editPricebook', false);
        cmp.set('v.editDiscount', false);
        cmp.set('v.table', true);
        var closeModalAttribute = false;
        var parentCmp = cmp.get('v.parent');
        parentCmp.closeModalEvent(closeModalAttribute);

    },

    returnToTable: function(cmp) {
        cmp.set('v.editPricebook', false);
        cmp.set('v.editDiscount', false);
        cmp.set('v.table', true);
        cmp.set('v.addProductToPricebook', false);
        cmp.set('v.pricebookView', true);
        $A.enqueueAction(cmp.get('c.init'));
    },

    handleSuccess: function(cmp, evt, helper) {
        $A.enqueueAction(cmp.get('c.returnToTable'));
        $A.enqueueAction(cmp.get('c.init'));
        helper.showSuccessToast(cmp, 'success', 'record updated successfully');
    },

    handleSaveEdition: function(cmp, evt, helper) {
        var draftValues = evt.getParam('draftValues');
        var firstList = cmp.get('v.mydata');

        const listToUpdate = [];
        draftValues.forEach(element => {
            const obj = firstList.find(firstList => element.Name == firstList.Name);
            const editingObj = {
                Id: obj.Id,
                Name: obj.Name,
                Pricebook2Id: obj.Pricebook2Id,
                Product2Id: obj.Product2Id,
                UnitPrice: element.UnitPrice
            };
            listToUpdate.push(editingObj);
        });
        var action = cmp.get('c.updatePricebookEntry');
        action.setParams({ priceUpdate: listToUpdate });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showSuccessToast(cmp, 'success', 'record updated successfully');
            } else if (state === "ERROR") {
                console.log(state);
                helper.showSuccessToast(cmp, 'error', 'please try again');
            }
        });
        $A.enqueueAction(action);
    },

    addProduct: function(cmp, evt, helper) {
        cmp.set('v.addProductToPricebook', true);
        cmp.set('v.pricebookView', false);
        helper.addProduct(cmp, evt, helper);
    },

    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedObjectToDiscount', selectedRows);
    },

    saveSelectedProduct: function(cmp, evt, helper, action) {
        console.log(cmp.get('v.pricebookId'));
        var action = cmp.get('c.saveNewProductInPricebook');
        action.setParams({
            newProductToPricebook: cmp.get('v.selectedObjectToDiscount'),
            pricebookId: cmp.get('v.pricebookId')
        });
        helper.selectedProductOperation(cmp, evt, helper, action);
        cmp.set('v.addProductToPricebook', false);
        cmp.set('v.pricebookView', true);
        const row = cmp.get('v.pricebookId');
        helper.editDiscount(cmp, row);
    },

    deleteSelectedProduct: function(cmp, evt, helper, action) {
        var action = cmp.get('c.deletePricebookProduct');
        action.setParams({
            pricebookItem: cmp.get('v.selectedObjectToDiscount')
        });
        helper.selectedProductOperation(cmp, evt, helper, action);
        const row = cmp.get('v.pricebookId');
        helper.editDiscount(cmp, row);
    }
})