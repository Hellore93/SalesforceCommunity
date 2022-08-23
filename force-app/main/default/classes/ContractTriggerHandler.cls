/**
 * Created by 48781 on 26.04.2022.
 */

public class ContractTriggerHandler implements TriggerHandler {

//    public static Boolean TriggerDisabled = false;
//    public Boolean isDisabled() {
//        return false;
//    }
//
//    public void BeforeInsert(List<SObject> newRecord) {
//        set<id> ContactId = new set<id>();
//
//        List<Messaging.SingleEmailMessage> mails =
//                new List<Messaging.SingleEmailMessage>();
//
//        for(Contract__c ctr :(List<Contract__c>)newRecord){
//            if (ctr.Doctor__c!= null )
//            {
//                ContactId.add(ctr.Doctor__c);
//            }
//        }
//
//        Doctor__c doctor = [SELECT Name,Doctor_Name__c,Email__c from Doctor__c where Id in:ContactId];
//        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
//        List<String> sendTo = new List<String>();
//        sendTo.add(doctor.Email__c);
//        mail.setToAddresses(sendTo);
//
//        mail.setReplyTo('org@salesforce.com');
//        mail.setSenderDisplayName('Org Ceo');
//
//        mail.setSubject('New contract was created');
//        String body = 'Dear ' + doctor.name + ' ' +  doctor.Doctor_Name__c;
//
//        mail.setHtmlBody(body);
//
//        mails.add(mail);
//        Messaging.sendEmail(mails);
//    }
//
//
//    public void BeforeUpdate(Map<Id, SObject> newRecord, Map<Id, SObject> oldItems) {
//    }
//
//    public void BeforeDelete(Map<Id, SObject> oldRecord) {
//    }
//
//    public void AfterInsert(Map<Id, SObject> newRecord) {
//    }
//
//    public void AfterUpdate(Map<Id, SObject> newRecord, Map<Id, SObject> oldRecord) {
//    }
//
//    public void AfterDelete(Map<Id, SObject> oldRecord) {
//    }
//
//    public void AfterUndelete(Map<Id, SObject> oldRecord) {
//    }

    public void BeforeInsert(List<SObject> newRecord) {
    }

    public void BeforeUpdate(Map<Id, SObject> newRecord, Map<Id, SObject> oldItems) {
    }

    public void BeforeDelete(Map<Id, SObject> oldRecord) {
    }

    public void AfterInsert(Map<Id, SObject> newRecord) {
    }

    public void AfterUpdate(Map<Id, SObject> newRecord, Map<Id, SObject> oldRecord) {
    }

    public void AfterDelete(Map<Id, SObject> oldRecord) {
    }

    public void AfterUndelete(Map<Id, SObject> oldRecord) {
    }

    public Boolean IsDisabled() {
        return true;
    }
}