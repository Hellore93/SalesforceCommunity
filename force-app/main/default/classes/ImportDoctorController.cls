/**
 * Created by 48781 on 04.05.2022.
 */

public with sharing class ImportDoctorController {

    public BLOB csvFileBody { get; set; }
    public string csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public Boolean ifDisable { get; set; }
    public Boolean isVisible { get; set; }
    public Boolean isCheckbox { get; set; }
    public String successDescription { get; set; }
    public String importDoctorId { get; set; }
    public List<DoctorWrapper> doctorListLoad { get; set; }
    public Boolean descriptionVisible { get; set; }
    public String importErrorMessage { get; set; }


    public ImportDoctorController() {
        doctorListLoad = new List<DoctorWrapper>();
        successDescription = '';
        isCheckbox = false;
        ifDisable = false;
        isVisible = false;
        descriptionVisible = false;
        csvFileLines = new String[]{
        };
    }

    public String getImportTemplate() {
        return 'https://britenet93-dev-ed--c.documentforce.com/sfc/servlet.shepherd/version/download/0687Q000000V8kR?asPdf=false&operationContext=CHATTER';
    }

    public String blobEncode(Blob input, String inCharset) {
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for (Integer i = 0; i < bytesCount; ++i)
            bytes[i] = hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }

    public void importCSVFile() {
        if (csvFileBody.size() > 0) {
            ifDisable = true;
            isVisible = true;
        }

        try {
            csvAsString = blobEncode(csvFileBody, 'UTF-8');
            csvFileLines = csvAsString.split('\n');
            doctorListLoad = new List<DoctorWrapper>();

            for (Integer i = 1; i < csvFileLines.size(); i++) {
                Doctor__c doctorItem = new Doctor__c() ;
                DoctorWrapper doc = new DoctorWrapper(doctorItem);
                string[] csvRecordData = csvFileLines[i].split('","');

                doc.extendDoc.Doctor_Name__c = csvRecordData[0] ;
                doc.extendDoc.Name = csvRecordData[1];
                doc.extendDoc.Phone_number__c = csvRecordData[2];
                doc.extendDoc.Email__c = csvRecordData[3];
                doc.extendDoc.Speciality__c = csvRecordData[4];
                doc.extendDoc.DateBorn__c = Date.parse(csvRecordData[5]);
                doc.extendDoc.City__c = csvRecordData[6];
                doc.extendDoc.Street__c = csvRecordData[7];
                doc.extendDoc.Country__c = csvRecordData[8];
                doc.isCheckbox = false;
                System.debug(doc.isCheckbox);
                doctorListLoad.add(doc);
            }
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occurred while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
    }

    public void allCheckbox() {
        for (DoctorWrapper checkbox : doctorListLoad) {
            checkbox.isCheckbox = true;
        }
    }

    public void noneCheckbox() {
        for (DoctorWrapper checkbox : doctorListLoad) {
            checkbox.isCheckbox = false;
        }
    }

    public void reverseCheckbox() {
        for (DoctorWrapper checkbox : doctorListLoad) {
            checkbox.isCheckbox = !checkbox.isCheckbox;
        }
    }

    public void importCheckedFile() {
        List<Doctor__c> newDoc = new List<Doctor__c>();
        List<DoctorWrapper> newListToLoad = new List<DoctorWrapper>();

        try {
            for (DoctorWrapper doctorIterable : doctorListLoad) {

                    if (doctorIterable.isCheckbox == true) {
                        newDoc.add(doctorIterable.extendDoc);
                        newListToLoad.add(doctorIterable);
                    } else {
                        doctorIterable.information = 'Your not choice that record to send';
                        doctorIterable.isDisabled = true;
                    }


                Database.SaveResult[] item = Database.insert(newDoc, false);
                Integer i = 0;
                for (Database.SaveResult sr : item) {
                    if (sr.isSuccess()) {
                        System.debug('message' + sr.getId());
                        newListToLoad.get(i).insertDocId = sr.getId();
                        newListToLoad.get(i).information = 'Success';
                        newListToLoad.get(i).isDisabled = false;
                        i++;
                    } else {
                        for (Database.Error er : sr.getErrors()) {
                            importErrorMessage += er.getMessage() + ' ';
                            newListToLoad.get(i).isDisabled = true;
                        }
                        newListToLoad.get(i).information = importErrorMessage;
                        i++;
                    }
                }
            }
        } catch (Exception e) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured inserting the records' + e.getMessage());
            ApexPages.addMessage(errormsg);
        }
        descriptionVisible = true;

    }

    public class DoctorWrapper {
        public Doctor__c extendDoc { get; set; }
        public Boolean isCheckbox { get; set; }
        public String information { get; set; }
        public String valueLink { get; set; }
        public Boolean isDisabled { get; set; }
        public String insertDocId { get; set; }

        public DoctorWrapper(Doctor__c doc) {
            isCheckbox = false;
            isDisabled = false;
            this.extendDoc = doc;
            this.information = '';
            valueLink = '';
            this.insertDocId = '';
        }
    }

}