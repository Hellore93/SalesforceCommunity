({
    getData : function(cmp, action) {
        action.setCallback(this, $A.getCallback(function (response) {
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
          var action = cmp.get("c.deleteAccount");
            action.setParams({
                "account":row
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var rows = cmp.get('v.mydata');
                    var rowIndex = rows.indexOf(row);
                    rows.splice(rowIndex, 1);
                    cmp.set('v.mydata', rows);
                }
                else if (state === "ERROR") {
                    // handle error
                }
            });
            $A.enqueueAction(action);
        }
})