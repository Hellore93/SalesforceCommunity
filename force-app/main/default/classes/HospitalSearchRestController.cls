/**
 * Created by 48781 on 20.05.2022.
 */

global with sharing class HospitalSearchRestController {
    private static final String endpoint = 'callout:Doctor_Search/services/apexrest/searchHospital/';

    public List<Hospital__c> hospitalList { get; set; }
    public Hospital__c hospital { get; set; }
    public String countryOfRestHospital { get; set; }
    public String nameOfRestHospital { get; set; }
    public String messageTheme { get; set; }
    public String messageToastContext { get; set; }
    public String messageSoap { get; set; }
    public String modalClass { get; set; }
    public String modalHeader { get; set; }
    public Boolean isCancelDisable { get; set; }
    public Boolean deleteModal { get; set; }
    public Boolean isRecordExist { get; set; }
    public String hospitalToDeleteEdit { get; set; }
    public RestHospitalManager.HospitalWrapper newHostWrap { get; set; }
    Public List<RestHospitalManager.HospitalWrapper> hospItemRest { get; set; }
    public List<Hospital__c>listOfObject { get; set; }
    public Hospital__c existOrNewHospital { get; set; }
    public RestHospitalManager.HospitalWrapper editDeleteObject { get; set; }
    public List<SelectOption> globalCountryList { get; set; }
    public List<String> globalCountry { get; set; }
    public String defaultCountry { get; set; }
    public String selectedCountry { get; set; }
    public String selectedCountryForNew { get; set; }
    public String CountrySelect { get; set; }

    public HospitalSearchRestController() {
        messageTheme = 'slds-theme_success';
        messageToastContext = '';
        countryOfRestHospital = '';
        nameOfRestHospital = '';
        messageSoap = '';
        modalClass = 'hidden';
        modalHeader = '';
        hospitalToDeleteEdit = '';
        defaultCountry = '';
        selectedCountryForNew = null;
        isCancelDisable = false;
        deleteModal = false;
        isRecordExist = false;
        hospital = new Hospital__c();
        hospitalList = new List<Hospital__c>();
        existOrNewHospital = new Hospital__c();
        globalCountry = new List<String>();
        hospItemRest = new List<RestHospitalManager.HospitalWrapper>();
        newHostWrap = new RestHospitalManager.HospitalWrapper(new Hospital__c());
        listOfObject = new List<Hospital__c>();
        editDeleteObject = new RestHospitalManager.HospitalWrapper(new Hospital__c());
        globalCountryList = new List<SelectOption>();
        getPicklist();

        CountrySelect = '';
    }

    public void showModal() {
        modalClass = 'new';
        existOrNewHospital = new Hospital__c();
        modalHeader = (String) System.Label.New;
        messageTheme = 'slds-theme_success';
        isCancelDisable = false;
    }

    public void closeModal() {
        modalClass = 'hidden';
    }

    public void getPicklist() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('PUT');
        Http http = new Http();
        HTTPResponse respList = http.send(req);
        String jsonBody = respList.getBody();
        List<String> globalCountryValue =
                (List<String>) JSON.deserialize(jsonBody, List<String>.class);

        globalCountryList.add(new SelectOption('', 'NONE'));

        for (String item : globalCountryValue) {
            globalCountryList.add(new SelectOption(item, item));
        }

    }

    public PageReference getHospital() {
        isRecordExist = false;
        HttpRequest req = new HttpRequest();
        if (hospital.Country__c == null && hospital.Name == null) {
            hospital.Name = '';
            hospital.Country__c = '';
        }
        String replaceName = hospital.Name.replace(' ', '+');

        req.setEndpoint(endpoint + '?Name=' + replaceName + '&Country=' + (selectedCountry == null || selectedCountry == 'NONE' ? '' : selectedCountry.replace(' ', '+')));
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse resp = http.send(req);
        List<RestHospitalManager.HospitalWrapper> hospItemRest =
                (List<RestHospitalManager.HospitalWrapper>) JSON.deserialize(resp.getBody(), List<RestHospitalManager.HospitalWrapper>.class);
        listOfObject = new List<Hospital__c>();

        for (RestHospitalManager.HospitalWrapper item : hospItemRest) {
            Hospital__c newItem = new Hospital__c();
            newItem.hospitalIdParametr__c = item.hospitalId;
            newItem.Name = item.hospitalName;
            newItem.Email__c = item.hospitalEmail;
            newItem.Country__c = item.hospitalCountry;
            newItem.City__c = item.hospitalCity;
            newItem.Street__c = item.hospitalStreet;
            newItem.externalId__c = item.hospitalExternalId;
            listOfObject.add(newItem);
        }
        if (!(listOfObject.isEmpty())) {
            isRecordExist = true;
        }
        defaultCountry = 'test';
        if (selectedCountry != null) {
            defaultCountry = selectedCountry;
        }
        return null;
    }

    public void editHospital() {
        isCancelDisable = false;
        modalHeader = System.Label.Edit;
        modalClass = 'show';

        for (Hospital__c item : listOfObject) {
            if (item.hospitalIdParametr__c == hospitalToDeleteEdit) {
                existOrNewHospital = item;
            }
        }
    }

    public PageReference saveModalResponse() {
        if (String.isBlank(hospitalToDeleteEdit)) {
            if (String.isNotBlank(existOrNewHospital.Name)) {


                RestHospitalManager.HospitalWrapper hospitalToadd =
                        new RestHospitalManager.HospitalWrapper(existOrNewHospital);
                HttpRequest req = new HttpRequest();


                if (selectedCountryForNew == null || selectedCountryForNew == 'NONE') {
                    hospitalToadd.hospitalCountry = ' ';
                } else {
                    hospitalToadd.hospitalCountry = selectedCountryForNew.replace(' ', '+');
                }

                req.setEndpoint(endpoint);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('accept', 'application/json');
                req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
                req.setMethod('POST');
                req.setBody(JSON.serialize(hospitalToadd));
                Http http = new Http();
                HTTPResponse resp = http.send(req);

                messageToastContext = 'Adding successful';
                getHospital();
                LogsPageController.createLog(req, resp, hospitalToadd.hospitalId);
            } else {
                messageTheme = 'slds-theme_error';
                messageToastContext = 'New hospital must have Name';
                existOrNewHospital = new Hospital__c();
                closeModal();

                return null;
            }
        } else if (String.isNotBlank(hospitalToDeleteEdit)) {
            if (String.isNotBlank(existOrNewHospital.Name)) {
                RestHospitalManager.HospitalWrapper hospitalToEdit =
                        new RestHospitalManager.HospitalWrapper(existOrNewHospital);

                if (selectedCountryForNew == null || selectedCountryForNew == 'NONE') {
                    editDeleteObject.hospitalCountry = ' ';
                } else {
                    editDeleteObject.hospitalCountry = selectedCountryForNew.replace(' ', '+');
                }

                HttpRequest reqEdit = new HttpRequest();
                reqEdit.setEndpoint(endpoint);
                reqEdit.setHeader('Content-Type', 'application/json');
                reqEdit.setHeader('accept', 'application/json');
                reqEdit.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
                reqEdit.setMethod('PATCH');


                editDeleteObject = new RestHospitalManager.HospitalWrapper(existOrNewHospital);
                editDeleteObject.hospitalId = hospitalToDeleteEdit;

                if (String.isNotBlank(editDeleteObject.hospitalExternalId)) {
                    editDeleteObject.hospitalExternalId = editDeleteObject.hospitalExternalId;
                    editDeleteObject.hospitalId = editDeleteObject.paramId;
                } else {
                    editDeleteObject.hospitalId = editDeleteObject.paramId;
                    editDeleteObject.hospitalExternalId = null;
                    editDeleteObject.paramId = null;
                }
                editDeleteObject.hospitalCountry = defaultCountry;
                editDeleteObject.hospitalTrigger = false;

                reqEdit.setBody(JSON.serialize(editDeleteObject));
                Http httpEdit = new Http();
                HTTPResponse respEdit = httpEdit.send(reqEdit);

                messageToastContext = 'Editing successful';
                getHospital();
                hospitalToDeleteEdit = '';
                LogsPageController.createLog(reqEdit, respEdit, editDeleteObject.hospitalId);
            } else {
                messageTheme = 'slds-theme_error';
                messageToastContext = 'Edit doctor must have last name';
                existOrNewHospital.Name = null;
                isCancelDisable = true;
                closeModal();
                return null;
            }
        }
        modalClass = 'hidden';
        defaultCountry = 'NONE';
        selectedCountry = 'NONE';
        return null;
    }

    public void deleteHospital() {

        for (Hospital__c item : listOfObject) {
            if (item.hospitalIdParametr__c == hospitalToDeleteEdit) {
                existOrNewHospital = item;
            }
        }

        RestHospitalManager.HospitalWrapper elementToDelete = new RestHospitalManager.HospitalWrapper(existOrNewHospital);
        HttpRequest req = new HttpRequest();
        String hospitalTest = existOrNewHospital.hospitalIdParametr__c;

        elementToDelete.hospitalId = existOrNewHospital.hospitalIdParametr__c;
        elementToDelete.hospitalExternalId = existOrNewHospital.externalId__c;
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('DELETE');

        req.setBody(JSON.serialize(elementToDelete));
        Http http = new Http();
        HTTPResponse respDelete = http.send(req);
        hospitalToDeleteEdit = '';
        getHospital();
        LogsPageController.createLog(req, respDelete, elementToDelete.hospitalId);
        messageToastContext = 'Delete successful';
        hospitalToDeleteEdit = '';

    }

}