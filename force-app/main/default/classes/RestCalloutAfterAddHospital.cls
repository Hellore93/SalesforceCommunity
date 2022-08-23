/**
 * Created by 48781 on 24.05.2022.
 */

global class RestCalloutAfterAddHospital implements Queueable, Database.AllowsCallouts {
    private String hospitalId;
    private String method;
    private Hospital__c hospitalObjectToDelete;
    public static String addNewHospital = 'addNewHospital';
    public static String editNewHospital = 'editNewHospital';
    public static String deleteNewHospital = 'deleteNewHospital';

    public RestCalloutAfterAddHospital(String hospitalId, String method) {
        this.hospitalId = hospitalId;
        this.method = method;
    }

    public RestCalloutAfterAddHospital(Hospital__c hospitalId, String method) {
        this.hospitalObjectToDelete = hospitalId;
        this.method = method;
    }


//    private static final String endpoint = 'callout:Doctor_Search/services/apexrest/searchHospitalala/';
    private static final String endpoint = 'callout:Doctor_Search/services/apexrest/searchHospital/';

    global void execute(QueueableContext param1) {

        if (method == addNewHospital) {
            Hospital__c hospitalToSend = [
                    SELECT Id, Name, Phone_Number__c, Email__c, Country__c, City__c, Street__c, externalId__c, TriggerProcess__c, hospitalIdParametr__c
                    FROM Hospital__c
                    WHERE Id = :hospitalId
                    LIMIT 1
            ];

            String objId = hospitalToSend.Id;

            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
            req.setMethod('POST');
            RestHospitalManager.HospitalWrapper newHosp2 = new RestHospitalManager.HospitalWrapper(hospitalToSend);
            newHosp2.hospitalId = null;
            newHosp2.hospitalExternalId = hospitalToSend.Id;
            newHosp2.hospitalTrigger = true;
            req.setBody(JSON.serialize(newHosp2));
            Http http = new Http();
            HTTPResponse resp = http.send(req);

            LogsPageController.createLog(req, resp, objId);

        } else if (method == editNewHospital) {
            Hospital__c hospitalToSend = [
                    SELECT Id, Name, Phone_Number__c, Email__c, Country__c, City__c, Street__c, externalId__c, TriggerProcess__c, hospitalIdParametr__c
                    FROM Hospital__c
                    WHERE Id = :hospitalId
                    LIMIT 1
            ];
            String objId = hospitalToSend.Id;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
            req.setMethod('PATCH');
            RestHospitalManager.HospitalWrapper newHosp2 = new RestHospitalManager.HospitalWrapper(hospitalToSend);

            if (newHosp2.hospitalExternalId == null) {
                newHosp2.hospitalExternalId = newHosp2.hospitalId;
                newHosp2.hospitalId = null;
                newHosp2.hospitalTrigger = true;
                req.setBody(JSON.serialize(newHosp2));

            } else {
                newHosp2.hospitalId = newHosp2.hospitalExternalId;
                newHosp2.hospitalExternalId = null;
                newHosp2.paramId = null;
                newHosp2.hospitalTrigger = true;
                req.setBody(JSON.serialize(newHosp2));
            }
            newHosp2.hospitalTrigger = true;
            Http http = new Http();
            HTTPResponse resp = http.send(req);

            LogsPageController.createLog(req, resp, objId);

        } else if (method == deleteNewHospital) {

            RestHospitalManager.HospitalWrapper hospitalToDelete =
                    new RestHospitalManager.HospitalWrapper(hospitalObjectToDelete);

            String objId = hospitalToDelete.hospitalId;

            if(String.isNotBlank(hospitalToDelete.hospitalExternalId)){
                hospitalToDelete.hospitalId = null;
            }
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
            req.setMethod('DELETE');


            req.setBody(JSON.serialize(hospitalToDelete));
            Http http = new Http();
            HTTPResponse respDelete = http.send(req);

            LogsPageController.createLog(req, respDelete, objId);
        }
    }
}