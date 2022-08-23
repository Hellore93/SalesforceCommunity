({
    saveProductDetails: function(cmp, evt, action) {
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                this.showSuccessToast(cmp, 'success', 'Adding successfully');
            } else {
                this.showSuccessToast(cmp, 'error', 'Adding field');
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

    closeModal: function(cmp, evt) {
        var closeModalAttribute = false;
        var parentCmp = cmp.get('v.parent');
        parentCmp.closeModalEvent(closeModalAttribute);
        var action = cmp.get('c.cancelProduct');
        action.setParams({
            productId: cmp.get('v.recordId')
        });
        $A.enqueueAction(action);
    },

    getPhoto: function(cmp, evt) {
        console.log('działam');
        var action = cmp.get("c.getProductPhoto");
        action.setParams({ productId: cmp.get('v.recordId') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.photoList', response.getReturnValue());
                console.log(cmp.get('v.photoList'));

            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });

        $A.enqueueAction(action);
    }
})