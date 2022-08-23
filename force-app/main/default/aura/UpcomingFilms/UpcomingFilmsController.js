/**
 * Created by 48781 on 02.06.2022.
 */

({
    doInit : function(component, event, helper){

        let action = component.get("c.getUpcomingFilms");
      action.setCallback(this,function(a){
                 let responseJson = JSON.parse(a.getReturnValue());
                 console.log(responseJson.results);
                 component.set("v.upcomingFilms", responseJson.results);
             })
             $A.enqueueAction(action);
    }
});