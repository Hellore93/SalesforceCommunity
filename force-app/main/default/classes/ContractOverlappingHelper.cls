/**
 * Created by 48781 on 30.04.2022.
 */

public with sharing class ContractOverlappingHelper {

    public static void handleAfterInsert(List<Contract__c> newContract) {
        NewContractId searchId = idsToQuery(newContract);

        List<Contract__c> existDoctorContract = [
                SELECT Id, Doctor__c, Start_Date__c, End_Date__c, Hospital__c, Hospital__r.Name
                FROM
                        Contract__c
                WHERE
                        Doctor__c IN :searchId.doctorId AND
                        Hospital__c IN :searchId.hospitalId
        ];

        Map<String, List<Contract__c>> existContract = new Map<String, List<Contract__c> >();

        for (Contract__c item : existDoctorContract) {
            if (existContract.containsKey((String) item.Doctor__c + (String) item.Hospital__c)) {
                existContract.get((String) item.Doctor__c + (String) item.Hospital__c).add(item);
            } else {
                existContract.put((String) item.Doctor__c + (String) item.Hospital__c, new List<Contract__c>{
                        item
                }
                );
            }
        }

        try {
            for (Contract__c val : newContract) {

                if (existContract.containsKey((String) val.Doctor__c + (string) val.Hospital__c)) {

                    for (Contract__c item : existContract.get((String) val.Doctor__c + (string) val.Hospital__c)) {

                        if ((val.Start_Date__c >= item.Start_Date__c && val.Start_Date__c <= item.End_Date__c) ||
                                (val.End_Date__c >= item.Start_Date__c && val.End_Date__c <= item.End_Date__c) ||
                                (val.Start_Date__c >= item.Start_Date__c && val.End_Date__c <= item.End_Date__c) ||
                                (val.Start_Date__c <= item.Start_Date__c && val.End_Date__c >= item.End_Date__c)) {
                            val.addError('Dates from :' + item.Start_Date__c + ' to ' + item.End_Date__c + ' for your new Contract are occupied. Please select a new date.');
                        } else if ((val.Start_Date__c >= item.Start_Date__c && item.End_Date__c == null) || (
                                val.End_Date__c >= item.Start_Date__c && item.End_Date__c == null)) {
                            val.addError('That\'s doctor have permanent Contract from ' + item.Start_Date__c + ' for ' + item.Hospital__r.Name);
                        }
                    }
                    existContract.get((String) val.Doctor__c + (string) val.Hospital__c).add(val);
                } else {
                    existContract.put((String) val.Doctor__c + (string) val.Hospital__c, new List<Contract__c>{
                            val
                    }) ;
                }

            }
        } catch (Exception e) {
            System.debug(e);
        }

    }

    public static NewContractId idsToQuery(List<Contract__c> newContract) {
        NewContractId dataId = new NewContractId() ;

        for (Contract__c getParameters : newContract) {
            dataId.hospitalId.add(getParameters.Hospital__c);
            dataId.doctorId.add(getParameters.Doctor__c);
            dataId.startDate.add(getParameters.Start_Date__c);
            dataId.endDate.add(getParameters.End_Date__c);
        }
        return dataId;
    }

    public class NewContractId {
        public List<String> hospitalId { get; set; }
        public List<String> doctorId { get; set; }
        public List<Date> startDate { get; set; }
        public List<Date> endDate { get; set; }

        public NewContractId() {
            this.hospitalId = new List<String>();
            this.doctorId = new List<String>();
            this.startDate = new List<Date>();
            this.endDate = new List<Date>();
        }
    }
}