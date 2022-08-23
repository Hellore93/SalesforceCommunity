({
    init: function(cmp, action, helper) {
        var actions = [
            { label: 'Show details', name: 'show_details' },
            { label: 'Delete', name: 'delete' }
        ]

        cmp.set('v.mycolumns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'AccountNumber', fieldName: 'AccountNumber', type: 'string' },
            { label: 'BillingStreet', fieldName: 'BillingStreet', type: 'string' },
            { label: 'BillingCity', fieldName: 'BillingCity', type: 'string' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        var action = cmp.get('c.getAccounts');
        helper.getData(cmp, action);
    },

    startSearch: function(cmp, evt, action, helper) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var accountName = cmp.find('enter-account-name').get('v.value');

            if (accountName != "") {
                var action = cmp.get('c.getAccountsByName');
                action.setParams({ accountName: cmp.find('enter-account-name').get('v.value') });
            } else {
                var action = cmp.get('c.getAccounts');
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
                cmp.set('v.selectedRows', list);
                break;
            case 'delete':
                cmp.set('v.selectedRows', []);
                helper.deleteRow(cmp, row);
                break;
        }
    },

    newAccount: function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account"
        });
        createRecordEvent.fire();
    },

    clear: function(cmp, evt, helper) {
        cmp.set('v.selectedRows', []);
        cmp.find('enter-account-name').set('v.value', '');
        var action = cmp.get('c.getAccountsByName');
        action.setParams({ accountName: '' });
        helper.getData(cmp, action);
    }
})