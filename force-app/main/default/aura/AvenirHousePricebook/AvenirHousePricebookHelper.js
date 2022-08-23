({
    getData: function(cmp, action) {
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var nameOfProduct = response.getReturnValue();
                nameOfProduct.forEach(item => item['website'] = 'https://britenet93-dev-ed.lightning.force.com/lightning/r/Product2/' + item['Id'] + '/view');
                cmp.set('v.mydata', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})