({
    showSuccessToast: function(cmp, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": type,
            "message": message
        });
        toastEvent.fire();
    }
})