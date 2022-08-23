({
    getData: function(cmp, action, helper) {

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
    },

    deleteRow: function(cmp, row) {
        var action = cmp.get("c.deletePricebook");
        action.setParams({
            "pricebook": row
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = cmp.get('v.mydata');
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                cmp.set('v.mydata', rows);
                this.showSuccessToast(cmp, 'success', 'record delete successfully');
            } else if (state === "ERROR") {
                this.showSuccessToast(cmp, 'error', 'please try again');
            }
        });
        $A.enqueueAction(action);
    },

    editDiscount: function(cmp, row) {
        cmp.set('v.editDiscountColumns', [
            { label: 'Name', fieldName: 'Name', type: 'text', editable: false },
            { label: 'Price', fieldName: 'UnitPrice', type: 'currency', editable: true }
        ]);
        var action = cmp.get('c.getPricebookDiscountById');
        action.setParams({ pricebookId: cmp.get('v.pricebookId') })
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
    },

    addProduct: function(cmp, evt, helper) {
        var action = cmp.get('c.addNewProductToPricebook');
        action.setParams({
            pricebookId: cmp.get('v.pricebookId')
        });
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
    },

    showSuccessToast: function(cmp, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },

    selectedProductOperation: function(cmp, evt, helper, action) {
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.showSuccessToast(cmp, 'success', 'Process successfully');
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.showSuccessToast(cmp, 'error', 'Process field');
            }
        }));
        $A.enqueueAction(action);
    }

})