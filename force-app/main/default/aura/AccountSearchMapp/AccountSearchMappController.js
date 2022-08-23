/**
 * Created by 48781 on 05.06.2022.
 */

({
    mapsShow: function (cmp, event, helper) {
        var objectList = cmp.get('v.selectedRows');
        var item;
        var listOfItem = [];
        for(let i=0; i< objectList.length; i++){
            var objectStreet = objectList[i].BillingStreet;
            var objectCity = objectList[i].BillingCity;
            var objectName = objectList[i].Name ;
             item = {
              location: {
                  Street: objectStreet,
                  City:  objectCity
              },
              value: 'First try',
              icon: 'custom:custom96',
              title: objectName
              }
              listOfItem.push(item);
        }
            cmp.set('v.mapMarkers', listOfItem );
            cmp.set('v.markersTitle', 'Account Mark');
        },

        handleMarkerSelect: function (cmp, event, helper) {
            var marker = event.getParam("selectedMarkerValue");
        }
});