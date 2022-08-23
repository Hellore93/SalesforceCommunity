/**
 * Created by 48781 on 02.06.2022.
 */

({
        helperMethod : function(component, helper) {
            var urlParam = component.get('v.urlParam');

        let action = component.get("c.getFilmInformation");
        action.setParams({
                urlParam : component.get("v.urlParam")
         });

        action.setCallback(this,function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
             let serverResponse = a.getReturnValue();
             let responseJson = JSON.parse(serverResponse);
             component.set("v.filmObject", responseJson);
             console.log(serverResponse);

            }else if (state === "INCOMPLETE") {}
             else if (state === "ERROR") {
               var errors = response.getError();
               if (errors) {
                   if (errors[0] && errors[0].message) {
                       console.log("Error message: " +
                                errors[0].message);
                   }
               }}
        })

        $A.enqueueAction(action);
        }
});