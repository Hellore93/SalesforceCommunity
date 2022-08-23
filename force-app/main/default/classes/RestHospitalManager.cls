/**
 * Created by 48781 on 19.05.2022.
 */

@RestResource(urlMapping='/HospitalRafal/*')
global without sharing class RestHospitalManager {

    @HttpGet
    global static List<HospitalWrapper> getHospital() {
        RestRequest hospitalReq = RestContext.request;
        String soql;
        Map<String, String> hospitalSearchParameter = hospitalReq.params;
        String test = '';
        List<HospitalWrapper> hospWrapList = new List<HospitalWrapper>();

        String hospName = hospitalSearchParameter.get('Name');
        String hospCountry = hospitalSearchParameter.get('Country');
        if (String.isNotBlank(hospName)) {
            soql = 'SELECT Name, Id, Email__c, Country__c, City__c, Street__c, hospitalIdParametr__c, ' +
                    'externalId__c, TriggerProcess__c FROM Hospital__c WHERE Name LIKE \'%' + hospName + '%\' ';
            if (string.isNotBlank(hospCountry)) {
                soql += ' AND Country__C LIKE \'%' + hospCountry + '%\' ';
            }
            List<Hospital__c> getHospital = Database.query(soql);
            for (Hospital__c item : getHospital) {
                hospWrapList.add(new HospitalWrapper(item));
            }
        }
        return hospWrapList;
    }

    @HttpPost
    global static RestWrapper createHospital() {
        RestWrapper newRestWrapper = new RestWrapper(null, null, null);
        RestRequest hospitalReq = RestContext.request;
        String body = RestContext.request.requestBody.toString();
        Boolean superTestCheckBox;

        System.debug('Body od Domnika POST : ' + body);
        if (body != null || String.isNotBlank(body)) {
            HospitalWrapper newHospital = (HospitalWrapper) JSON.deserialize(body, HospitalWrapper.class);

            JSONParser parser = JSON.createParser(body);

            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && ((parser.getText() == 'hospitalCheckBox') || (parser.getText() == 'hospitalTrigger'))) {
                    parser.nextToken();
                    superTestCheckBox = parser.getText() == 'true' ? true : false;
                }
            }
            newHospital.hospitalTrigger = superTestCheckBox;

            Hospital__c newHospitalToSave = new Hospital__c(
                    externalId__c = newHospital.hospitalExternalId,
                    Name = newHospital.hospitalName,
                    Email__c = newHospital.hospitalEmail,
                    Country__c = newHospital.hospitalCountry,
                    City__c = newHospital.hospitalCity,
                    Street__c = newHospital.hospitalStreet,
                    TriggerProcess__c = newHospital.hospitalTrigger,
                    hospitalIdParametr__c = newHospital.paramId
            );
            System.debug('zapis obiekt: ' + newHospitalToSave);

            Database.SaveResult saveNew = Database.insert(newHospitalToSave);
            newHospital.hospitalId = saveNew.getId();
            newRestWrapper.message = 'OK';
            newRestWrapper.hospWrapper = newHospital;
            return newRestWrapper;
        } else {
            newRestWrapper.message = 'ERROR';
            newRestWrapper.hospWrapper = null;
            return newRestWrapper;
        }
    }

    @HttpPatch
    global static RestWrapper editHospital() {
        RestWrapper newRestWrapper = new RestWrapper(null, null, null);
        RestRequest hospitalReq = RestContext.request;
        Boolean superTestCheckBox;

        String body = RestContext.request.requestBody.toString();

        if (body != null || String.isNotBlank(body)) {
            HospitalWrapper newHospital = (HospitalWrapper) JSON.deserialize(body, HospitalWrapper.class);

            JSONParser parser = JSON.createParser(body);

            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'hospitalCheckBox')) {
                    parser.nextToken();
                    superTestCheckBox = parser.getText() == 'true' ? true : false;
                }
            }

            if (String.isBlank(newHospital.hospitalExternalId)) {
                Hospital__c newHospitalToEdit = new Hospital__c(
                        Id = newHospital.hospitalId,
                        Name = newHospital.hospitalName,
                        Email__c = newHospital.hospitalEmail,
                        Country__c = newHospital.hospitalCountry,
                        City__c = newHospital.hospitalCity,
                        Street__c = newHospital.hospitalStreet,
                        TriggerProcess__c = superTestCheckBox,
                        hospitalIdParametr__c = newHospital.paramId
                );
                update newHospitalToEdit;
                newRestWrapper.message = 'OK';
                newRestWrapper.hospWrapper = newHospital;
                return newRestWrapper;
            } else {
                Hospital__c partnerEditingObject = [SELECT Id FROM Hospital__c WHERE externalId__c = :newHospital.hospitalExternalId LIMIT 1];
                Hospital__c newHospitalToEdit = new Hospital__c(
                        Id = partnerEditingObject.Id,
                        externalId__c = newHospital.hospitalExternalId,
                        Name = newHospital.hospitalName,
                        Email__c = newHospital.hospitalEmail,
                        Country__c = newHospital.hospitalCountry,
                        City__c = newHospital.hospitalCity,
                        Street__c = newHospital.hospitalStreet,
                        TriggerProcess__c = newHospital.hospitalTrigger
                );
                if (newHospital.hospitalTrigger != true) {
                    newHospitalToEdit.TriggerProcess__c = true;
                } else {
                    newHospitalToEdit.TriggerProcess__c = false;
                }

                try {
                    update newHospitalToEdit;
                } catch (Exception e) {
                    System.debug('exception webserwice edit ' + e);
                }
                return newRestWrapper;
            }

        } else {
            newRestWrapper.message = 'ERROR';
            newRestWrapper.hospWrapper = null;
            return newRestWrapper;
        }
    }

    @HttpPut
    global static List<String> GlobalPicklistValue() {
        List<String> pickList = new List<String>();
        for (PicklistEntry picklistEntry : Hospital__c.Country__c.getDescribe().getPicklistValues()) {
            pickList.add(picklistEntry.getValue());
        }

        return pickList;
    }

    @HttpDelete
    global static RestWrapper deleteHospital() {
        String message;
        Hospital__c findHospitalToDelete;

        String body = RestContext.request.requestBody.toString();
        RestWrapper newRestWrapper = new RestWrapper(null, null, null);
        HospitalWrapper hospitalToDelete = (HospitalWrapper) JSON.deserialize(body, HospitalWrapper.class);
        if (String.isBlank(hospitalToDelete.hospitalExternalId)) {
            //jeśli jest pusty externalId
            findHospitalToDelete = [SELECT Name, Id FROM Hospital__c WHERE externalId__c = :hospitalToDelete.hospitalId LIMIT 1];
        } else {
            //usunąć obiekt po Id
            findHospitalToDelete = [SELECT Name, Id FROM Hospital__c WHERE Id = :hospitalToDelete.hospitalExternalId LIMIT 1];
        }

        try {
            delete findHospitalToDelete;
            newRestWrapper.hospWrapper = null;
            newRestWrapper.hospWrapperList = null;
            newRestWrapper.message = 'Delete';
        } catch (Exception e) {
            newRestWrapper.hospWrapper = null;
            newRestWrapper.hospWrapperList = null;
            newRestWrapper.message = 'Error';
        }
        return newRestWrapper;
    }


    global class HospitalWrapper {
        public Boolean hospitalTrigger { get; set; }
        public String hospitalId { get; set; }
        public String hospitalName { get; set; }
        public String hospitalEmail { get; set; }
        public String hospitalCountry { get; set; }
        public String hospitalCity { get; set; }
        public String hospitalStreet { get; set; }
        public String hospitalExternalId { get; set; }
        public String paramId { get; set; }

        global HospitalWrapper(Hospital__c hospital) {

            Boolean zmiennaTest;
            if (hospital.TriggerProcess__c != true) {
                zmiennaTest = false;
            } else {
                zmiennaTest = true;
            }
            this.hospitalTrigger = zmiennaTest;
            this.hospitalExternalId = hospital.externalId__c;
            this.hospitalId = hospital.Id;
            this.hospitalName = hospital.Name;
            this.hospitalEmail = hospital.Email__c;
            this.hospitalCountry = hospital.Country__c;
            this.hospitalCity = hospital.City__c;
            this.hospitalStreet = hospital.Street__c;
            this.paramId = hospital.hospitalIdParametr__c;
        }
    }

    global class RestWrapper {
        public List<HospitalWrapper> hospWrapperList { get; set; }
        public HospitalWrapper hospWrapper { get; set; }
        public String message;

        global RestWrapper(List<HospitalWrapper> hospWrapperList, HospitalWrapper hospWrapper, String message) {
            this.hospWrapperList = hospWrapperList;
            this.hospWrapper = hospWrapper;
            this.message = message;
        }
    }
}