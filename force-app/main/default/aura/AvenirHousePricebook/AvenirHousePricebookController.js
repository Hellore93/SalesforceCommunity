({
    init: function(cmp, action, helper) {

        cmp.set('v.mycolumns', [{
                label: 'Name',
                fieldName: 'website',
                type: 'url',
                typeAttributes: {
                    label: { fieldName: 'Name' },
                    target: '_blank'
                }
            },
            { label: 'Price', fieldName: 'UnitPrice', type: 'currency' },
            { label: 'Price with discount', fieldName: 'PriceAfterDiscount', type: 'currency' },
            { label: 'Pricebook Name', fieldName: 'PricebookName', type: 'text' },
            { label: 'Pricebook Description', fieldName: 'PricebookDescription', type: 'text' },

        ]);
        var action = cmp.get('c.getProductAndPrice');
        helper.getData(cmp, action);
    },

    startSearch: function(cmp, evt, action, helper) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var houseName = cmp.find('enter-house-name').get('v.value');

            if (houseName != "") {
                var action = cmp.get('c.getProductByName');
                action.setParams({ houseName: houseName });
            } else {
                $A.enqueueAction(cmp.get('c.init'));
            }

            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var nameOfProduct = response.getReturnValue();
                    nameOfProduct.forEach(item => item['website'] = 'https://britenet93-dev-ed.lightning.force.com/lightning/r/Product2/' + item['Id'] + '/view');
                    cmp.set('v.mydata', nameOfProduct);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);
        }
    },

    openNewPricebook: function(cmp, evt) {
        cmp.set('v.newPricebook', true);
    },

    openPricebookTable: function(cmp, evt) {
        cmp.set('v.showPricebook', true);
    },


    closeModal: function(cmp, evt) {
        var params = evt.getParam('arguments');
        if (params) {
            var closeModal = cmp.get('v.newPricebook');
            var closeShowModal = cmp.get('v.showPricebook');
            closeModal = params.closeModalAttribute;
            closeShowModal = params.closeModalAttribute;
            cmp.set('v.newPricebook', closeModal);
            cmp.set('v.showPricebook', closeShowModal);
        }
        $A.enqueueAction(cmp.get('c.init'));
    },

    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedObjectToDiscount', selectedRows);
    }
})