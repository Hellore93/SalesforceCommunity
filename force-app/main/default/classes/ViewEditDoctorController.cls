public with sharing class ViewEditDoctorController {

    public Doctor__c query { get; set; }
    public String docId { get; set; }
    public List<Contract__c> queryContract { get; set; }
    public Hospital__c hosp { get; set; }
    public String hospName { get; set; }
    public String hospMail { get; set; }
    public String hospNumber { get; set; }
    public String queryHospital { get; set; }
    public List<Hospital__c> exportList { get; set; }
    public Hospital__c singleHospital { get; set; }
    public Contract__c newContract { get; set; }
    public Date start_date { get; set; }
    public Date end_date { get; set; }
    public Integer sizeClassTable { get; set; }
    public String messageClass { get; set; }
    public String submitException { get; set; }
    public String newPhotoUrl { get; set; }
    public Boolean wasInserted { get; set; }
    public Attachment att { get; set; }
    private Id parentId { get; set; }
    public Contract__c insertedContract { get; set; }
    public Decimal doctorLatitude { get; set; }
    public Decimal doctorLongitude { get; set; }
    public Boolean isMapVisible { get; set; }
    public String editNewTitle { get; set; }

    public ViewEditDoctorController(ApexPages.StandardController controller) {
        editNewTitle = '';
        messageClass = 'firstClass';
        isMapVisible = false;
        wasInserted = false;
        newContract = new Contract__c();
        singleHospital = new Hospital__c();
        List<String> fieldDoctor = new List<String>(Schema.getGlobalDescribe().get('Doctor__c').getDescribe().fields.getMap().keySet());
        docId = ApexPages.currentPage().getParameters().get('id');

        if (docId != null) {
            query = Database.query('SELECT ' + String.join(fieldDoctor, ',') + ' FROM Doctor__c WHERE Id =:docId LIMIT 1');
            List<String> fieldContract = new List<String>(Schema.getGlobalDescribe().get('Contract__c').getDescribe().fields.getMap().keySet());
            queryContract = Database.query('SELECT ' + String.join(fieldContract, ',') + ' FROM Contract__c WHERE Doctor__c =:docId LIMIT 20');
            editNewTitle = System.Label.Edit;
        } else {
            query = new Doctor__c();
            editNewTitle = (String) System.Label.New;
        }

        hosp = new Hospital__c();
        att = new Attachment();
        parentId = controller.getId();

        if (query.Country__c != null && query.City__c != null && query.Street__c != null) {
            HttpRequest req = new HttpRequest();
            String urlLocationParameters = '';

            if (String.isNotBlank(query.Country__c)) {
                urlLocationParameters += '&country=' + EncodingUtil.urlEncode(query.Country__c, 'UTF-8');
            }

            if (String.isNotBlank(query.City__c)) {
                urlLocationParameters += '&city=' + EncodingUtil.urlEncode(query.City__c, 'UTF-8');
            }

            if (String.isNotBlank(query.Street__c)) {
                String addressDoctor = query.Street__c.replace(' ', '+');
                urlLocationParameters += '&street=' + addressDoctor;
            }

            String url = 'https://nominatim.openstreetmap.org/search.php?format=json' + urlLocationParameters;
            System.debug(url);

            req.setEndpoint(
                    url
            );

            req.setMethod('GET');

            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res);
            List<GeoLocation> geoLocation;

            try {
                geoLocation = (List<GeoLocation>) JSON.deserialize(
                        res.getBody(),
                        List<GeoLocation>.class
                );
            } catch (Exception ex) {
                System.debug('Exception : ' + ex);
            }

            if (geoLocation != null && geoLocation.size() > 0) {
                doctorLatitude = Decimal.valueOf(geoLocation[0].lat);
                doctorLongitude = Decimal.valueOf(geoLocation[0].lon);
                isMapVisible = true;
            }

        } else {
            isMapVisible = false;
        }
    }

    public PageReference save() {
        try {
            if (query.Id != null) {
                update query;
            } else {
                insert query;
            }

            String pageUrl = 'https://britenet93-dev-ed--c.visualforce.com/apex/DoctorView?id=' + query.Id;
            PageReference result = new PageReference(pageUrl).setRedirect(true);
            return result;
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }

    public PageReference saveAndNew() {
        save();
        PageReference page = new PageReference('/apex/DoctorEdit').setRedirect(true);
        return page;
    }

    public void deleteDoctor() {
        Doctor__c removeDoctor = [SELECT Id From Doctor__c WHERE Id = :docId];
        if (removeDoctor != null) {
            try {
                delete removeDoctor;

            } catch (DmlException e) {
                ApexPages.addMessages(e);
            }
        }
    }

    public void getFromFront() {

        queryHospital = 'SELECT Id, Name, Phone_Number__c, Email__c, Country__c, City__c, Street__c FROM Hospital__c WHERE Name LIKE \'%' + STRING.escapeSingleQuotes(hospName) + '%\' ' ;
        if (!(hospMail == '')) {
            queryHospital += ' AND Email__c LIKE \'%' + String.escapeSingleQuotes(hospMail) + '%\' ';
        }
        if (!(hospNumber == '')) {
            queryHospital += ' AND Phone_Number__c LIKE \'%' + String.escapeSingleQuotes(hospNumber) + '%\' ';
        }
        exportList = Database.query(queryHospital);
        sizeClassTable = exportList.size();

    }

    public List<Hospital__c> clearModal() {
        if (!(exportList == null)) {
            exportList.clear();
        }
        singleHospital = new Hospital__c();
        getHospitalFrontId();
        return null;
    }

    public void getHospitalFrontId() {
        singleHospital.Id = ApexPages.currentPage().getParameters().get('selectHospitalId');
        if (!(exportList == null)) {
            singleHospital.Name = ApexPages.currentPage().getParameters().get('selectHospitalName');
        } else {
            singleHospital.Name = ' ';
        }
    }

    public void saveNewContract() {
        newContract = new Contract__c();
        newContract.Doctor__c = query.Id;
        newContract.Hospital__c = singleHospital.Id;
        newContract.Start_Date__c = start_date;
        newContract.End_Date__c = end_date;

        try {
            if (!wasInserted || !(insertedContract == newContract)) {

                Database.SaveResult saveContract = Database.insert(newContract);
                if (saveContract.isSuccess()) {
                    submitException = ''; messageClass = 'close';
                    newContract.clear();
                } else {
                    submitException = 'You should enter data'; messageClass = 'open';
                }

                wasInserted = true;
                insertedContract = newContract.clone();
            } else {
                submitException = 'You try adding the same contract'; messageClass = 'open';
            }


        } catch (Exception e) {
            submitException = e.getMessage();
            messageClass = 'open';
            System.debug(submitException);
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured inserting the records' + e.getMessage());
            ApexPages.addMessage(errormsg);
        }
    }

    public void getNewPhoto() {

        Try {
            if (att.Name.contains('.jpg') || att.Name.contains('.png')) {
                att.parentId = parentId;
                att.Name = 'image';
                insert att;
                att = new Attachment();
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'File extension wrong'));
            }
        } catch (Exception e) {
        }
    }

    public void setDefaultPhoto() {
        List<Attachment> images = [SELECT id FROM Attachment WHERE Name = 'image' AND ParentId = :parentId];
        Database.delete(images);
    }

    public Id getPhotoId() {
        Id result = null;
        List<Attachment> images = [SELECT id FROM Attachment WHERE Name = 'image' AND ParentId = :parentId ORDER BY CreatedDate DESC];
        if (images.size() > 0) {
            result = images[0].id;
        } else {
            result = '00P7Q000000icMxUAI';
        }
        return result;
    }

    public class GeoLocation {
        public String lat { get; set; }
        public String lon { get; set; }
    }
}