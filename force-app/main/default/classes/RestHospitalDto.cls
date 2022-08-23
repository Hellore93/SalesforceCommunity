/**
 * Created by 48781 on 22.05.2022.
 */

global with sharing class RestHospitalDto {
    global String hospitalExternalId;
    global String hospitalId;
    global String hospitalName;
    global String hospitalPhone;
    global String hospitalEmail;
    global String hospitalCountry;
    global String hospitalCity;
    global String hospitalStreet;

    global RestHospitalDto(Hospital__c hospital) {
        this.hospitalExternalId = hospital.externalId__c;
        this.hospitalId = hospital.Id;
        this.hospitalName = hospital.Name;
        this.hospitalPhone = (String) hospital.Phone_Number__c;
        this.hospitalEmail = hospital.Email__c;
        this.hospitalCountry = hospital.Country__c;
        this.hospitalCity = hospital.City__c;
        this.hospitalStreet = hospital.Street__c;
    }
}