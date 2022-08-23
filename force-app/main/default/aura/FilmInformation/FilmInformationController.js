/**
 * Created by 48781 on 02.06.2022.
 */

({
    getUrlParameter : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var urlParam = pageRef.state.c__myParameter;
        component.set("v.urlParam",urlParam);
        helper.helperMethod(component, true);
        }
});