({
    helperMethod : function(component, helper) {
         var filmName = component.find('enter-search-film-name').get('v.value');
        let action = component.get("c.getFilms");

        action.setParams({
                filmName : component.find('enter-search-film-name').get("v.value")
         });

        action.setCallback(this,function(a){
            let responseJson = JSON.parse(a.getReturnValue());
            console.log(responseJson.results);
            component.set("v.filmList", responseJson);
        })
        $A.enqueueAction(action);
    }
})