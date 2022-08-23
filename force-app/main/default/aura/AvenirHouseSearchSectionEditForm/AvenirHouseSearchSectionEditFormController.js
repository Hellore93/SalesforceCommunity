({
    setVisible: function(cmp, event, helper) {
        var itemSize = cmp.get("v.selectedRows").length;
        if (itemSize == 1) {
            cmp.set('v.cardVisible', true);
        } else {
            cmp.set('v.cardVisible', false);
            cmp.set('v.message', 'You choice to many Account');
        };
        if (itemSize < 1) {
            cmp.set('v.message', '');
        }
    }
})