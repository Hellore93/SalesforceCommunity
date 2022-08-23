({
     handleKeyUp: function (component, evt, helper) {
            var isEnterKey = evt.keyCode === 13;
            if (isEnterKey) {
                helper.helperMethod(component, true);
                }
     }
})