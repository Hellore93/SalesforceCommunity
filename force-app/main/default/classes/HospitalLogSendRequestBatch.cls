/**
 * Created by 48781 on 28.05.2022.
 */

global class HospitalLogSendRequestBatch implements Database.Batchable<Log__c>, Database.AllowsCallouts {

    public List<Hospital__c> listOfHospital { get; set; }

    global List<Log__c> start(Database.BatchableContext param1) {
        List<Log__c> finishListOfHospital = new List<Log__c>();

        listOfHospital = [
                SELECT Id, FailRequestNumber__c, TriggerProcess__c
                FROM Hospital__c
                WHERE (FailRequestNumber__c != 0 AND FailRequestNumber__c < 4)
        ];
        for (Hospital__c item : listOfHospital) {
            for (Log__c logItem : [
                    SELECT ObjectId__c, Request_Body__c, Create_Data__c, Status_Code__c, Http_Method__c
                    From Log__c
                    WHERE (ObjectId__c = :item.Id AND Status_Code__c != 200)
                    ORDER BY Create_Data__c DESC
                    LIMIT 1
            ]) {
                finishListOfHospital.add(logItem);
            }
        }
        return finishListOfHospital;
    }

    global void execute(Database.BatchableContext param1, List<Log__c> finishListOfHospital) {
        String endpoint = 'callout:Doctor_Search/services/apexrest/searchHospital/';
//        String endpoint = 'callout:Doctor_Search/services/apexrest/searchHospitalal/';
        List<Hospital__c> objectToUpdateList = new List<Hospital__c>();

        for (Log__c item : finishListOfHospital) {
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
            req.setBody(item.Request_Body__c);
            req.setEndpoint(endpoint);
            req.setMethod(item.Http_Method__c);

            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('Shedule status: ' + res.getStatusCode());

            if (res.getStatusCode() == 200) {
                Hospital__c objectToUpdate = [SELECT Id, Name, FailRequestNumber__c, TriggerProcess__c FROM Hospital__c WHERE Id = :item.ObjectId__c];
                objectToUpdate.FailRequestNumber__c = 0;
                objectToUpdate.TriggerProcess__c = true;
                objectToUpdateList.add(objectToUpdate);
            } else {
                Hospital__c objectToUpdate = [SELECT Id, Name, FailRequestNumber__c, TriggerProcess__c FROM Hospital__c WHERE Id = :item.ObjectId__c];
                Decimal fieldIncrement = objectToUpdate.FailRequestNumber__c + 1;
                System.debug('increment ' + fieldIncrement);
                objectToUpdate.FailRequestNumber__c = fieldIncrement ;
                objectToUpdate.TriggerProcess__c = true;
                objectToUpdateList.add(objectToUpdate);
            }
        }
        for (Hospital__c item : objectToUpdateList) {
            update item;
        }
    }

    global void finish(Database.BatchableContext param1) {
    }
}