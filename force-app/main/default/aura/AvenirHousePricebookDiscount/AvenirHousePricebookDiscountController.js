({
    init: function(cmp) {

        cmp.set('v.mycolumns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Price', fieldName: 'UnitPrice', type: 'currency' },
            { label: 'New Price', fieldName: 'UnitPriceDiscount', type: 'currency' }
        ]);
    },

    closeModal: function(cmp, evt) {
        var closeModalAttribute = false;
        var parentCmp = cmp.get('v.parent');
        parentCmp.closeModalEvent(closeModalAttribute);
    },

    selectedObject: function(cmp, evt) {
        const discountListOfProduct = cmp.get('v.listClickedProduct');
        var selectedRows = evt.getParam('selectedRows');
        cmp.set('v.selectedObjectToDiscount', selectedRows);
        const primaryMap = new Map();

        for (const element of selectedRows) {
            primaryMap.set(element.Id, element)
        }

        for (const item of discountListOfProduct) {
            if (primaryMap.has(item.Id)) {
                item.editPrice = true;
            } else {
                item.editPrice = false;
            }
        }
        cmp.set('v.listClickedProduct', discountListOfProduct);
    },

    acceptDiscount: function(cmp, evt) {
        const discountListOfProduct = cmp.get('v.listClickedProduct');
        let discountValue = parseFloat(cmp.find('discountValue').get('v.value'));
        const selectOption = cmp.find('selectDiscount').get('v.value');
        cmp.set('v.discountValue', discountValue);

        for (const element of discountListOfProduct) {
            if (selectOption == 'percent' && element.editPrice) {
                if (discountValue > 100) {
                    cmp.find('discountValue').set('v.value', 100);
                    discountValue = 100;
                }
                let valuePercent = 1 - (discountValue / 100);
                element.UnitPriceDiscount = element.UnitPrice * valuePercent;
            } else if (selectOption == 'value' && element.editPrice) {
                if (discountValue > element.UnitPrice) {
                    discountValue = element.UnitPrice;
                }
                element.UnitPriceDiscount = element.UnitPrice - discountValue
            }

            cmp.set('v.listClickedProduct', discountListOfProduct)
        }
    },

    savePricebook: function(cmp, evt, helper) {
        const obj = {
            Name: cmp.find('discountInputName').get('v.value'),
            Description: cmp.find('pricebookDescription').get('v.value'),
            IsActive: cmp.find('pricebookActive').get('v.value'),
            StartDate: (cmp.find('startDate').get('v.value')),
            EndDate: (cmp.find('endDate').get('v.value')),
            product: cmp.get('v.listClickedProduct')
        };

        console.log(obj);
        console.log(typeof obj);
        var action = cmp.get('c.saveNewPrice');
        action.setParams({ getFromFront: obj });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var closeModalAttribute = false;
            var parentCmp = cmp.get('v.parent');
            if (state === "SUCCESS") {
                helper.showSuccessToast(cmp, 'success', 'record updated successfully');
                parentCmp.closeModalEvent(closeModalAttribute);
            } else if (state === "ERROR") {
                var errors = response.getError();
                helper.showSuccessToast(cmp, 'error', 'please try again');
                parentCmp.closeModalEvent(closeModalAttribute);
            }
        }));
        $A.enqueueAction(action);
    }
})