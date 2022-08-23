({
    init: function(cmp, action, helper) {
        var actions = [
            { label: 'Show details', name: 'show_details' },
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' },
            { label: 'Add Photo', name: 'addPhoto' },
            { label: 'Add Price', name: 'addPrice' }
        ]

        cmp.set('v.mycolumns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Type', fieldName: 'Family', type: 'text' },
            { label: 'Description', fieldName: 'Description', type: 'text' },
            { label: 'House code', fieldName: 'ProductCode', type: 'text' },
            { label: 'Country', fieldName: 'Country__c', type: 'text' },
            { label: 'City', fieldName: 'City__c', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        var action = cmp.get('c.getProducts');
        helper.getData(cmp, action);
    },

    startSearch: function(cmp, evt, action, helper) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var houseName = cmp.find('enter-house-name').get('v.value');

            if (houseName != "") {
                var action = cmp.get('c.getHouseByName');
                action.setParams({ houseName: cmp.find('enter-house-name').get('v.value') });
            } else {
                var action = cmp.get('c.getProducts');
            }

            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set('v.mydata', response.getReturnValue());
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);
        }
    },

    handleRowAction: function(cmp, event, helper) {
        var list = cmp.get('v.selectedRows');
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'show_details':
                list.push(row);
                cmp.set('v.selectedRows', []);
                helper.viewRow(cmp, row);
                break;
            case 'edit':
                cmp.set('v.selectedRowsToEdit', []);
                helper.editRow(cmp, row);
                break;
            case 'delete':
                cmp.set('v.selectedRows', []);
                helper.deleteRow(cmp, row);
                break;
            case 'addPhoto':
                cmp.set('v.selectedRows', []);
                helper.relatedList(cmp, row);
                break;
            case 'addPrice':
                list.push(row);
                cmp.set('v.variant1', true);
                cmp.set('v.productPrice', true);
                cmp.set('v.selectedRows', list);
                var rows = cmp.get('v.mydata');
                var rowIndex = rows.indexOf(row);
                cmp.set('v.priceObjectName', rows[rowIndex].Name);
                var action = cmp.get('c.getPriceById');
                action.setParams({ Product2IdFront: rows[rowIndex].Id });
                action.setCallback(this, $A.getCallback(function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        cmp.set('v.priceObject.UnitPrice', response.getReturnValue().UnitPrice);
                        cmp.set('v.priceObject.priceId', response.getReturnValue().Id);
                    } else {}
                }));
                $A.enqueueAction(action);
                break;
        }
    },

    newHouse: function(component, event, helper) {
        component.set('v.createNewProduct', true);
    },

    clear: function(cmp, evt, helper) {
        cmp.set('v.selectedRows', []);
        cmp.find('enter-house-name').set('v.value', '');
        var action = cmp.get('c.getHouseByName');
        action.setParams({ houseName: '' });
        helper.getData(cmp, action);
    },

    closeModal: function(cmp) {
        cmp.set('v.variant1', false);
        cmp.set('v.productPrice', false);
        cmp.set('v.informationModal', false);
        cmp.set('v.priceObject.UnitPrice', '');
        cmp.get('v.selectedRows', []);
    },

    handleLikeButtonClick: function(cmp, event) {
        var photoId = event.currentTarget.dataset.value;
        var photoIndex = event.currentTarget.dataset.index;
        var listAfterDelete = cmp.get('v.photoList');
        listAfterDelete.splice(photoIndex, 1);
        cmp.set('v.photoList', listAfterDelete);
        var action = cmp.get('c.deletePhotoById');
        action.setParams({ photoId: photoId });
        $A.enqueueAction(action);
    },

    setToDisplayUrl: function(cmp, event) {
        var contentDocumentId = event.currentTarget.dataset.param;
        var contentProductId = event.currentTarget.dataset.productid;
        const link = 'https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/' + contentDocumentId;
        var action = cmp.get('c.setDefaultPhotoUrl');
        action.setParams({ productId: contentProductId, link: link });
        action.setCallback(cmp,
            function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    $A.get('e.force:refreshView').fire();
                } else {}
            }
        );
        $A.enqueueAction(action);
    },

    savePriceBook: function(cmp, evt, row, helper) {
        var rows = cmp.get('v.selectedRows');
        var action = cmp.get('c.savePriceBookEntry');
        action.setParams({
            productId: rows[0].Id,
            price: cmp.get('v.priceObject[UnitPrice]'),
            priceId: cmp.get('v.priceObject[priceId]')
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                $A.enqueueAction(cmp.get('c.closeModal'));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": 'success',
                    "message": "The record has been inserted successfully."
                });
                toastEvent.fire();
            } else {}
        }));
        $A.enqueueAction(action);
    },

    refreshAll: function(cmp, evt, helper) {
        $A.enqueueAction(cmp.get('c.init'));
    },

    closeNewProduct: function(cmp, evt, helper) {
        var params = evt.getParam('arguments');
        if (params) {
            var closeModal = cmp.get('v.createNewProduct');
            closeModal = params.closeModalAttribute;
            cmp.set('v.createNewProduct', closeModal);
        }
        $A.enqueueAction(cmp.get('c.init'));
    }

})