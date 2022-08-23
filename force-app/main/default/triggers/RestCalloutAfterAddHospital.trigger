/**
 * Created by 48781 on 24.05.2022.
 */

trigger RestCalloutAfterAddHospital on Hospital__c (after insert, after update, before delete) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            for (Hospital__c newHosp : Trigger.new) {
                if (newHosp.TriggerProcess__c != true) {
                    String hospId = newHosp.Id;
                    Id hospitalIdQueueble = System.enqueueJob
                            (new RestCalloutAfterAddHospital(hospId, 'addNewHospital'));
                }
            }
        } else if (Trigger.isUpdate) {
            for (Hospital__c newHosp : Trigger.new) {
                if (newHosp.TriggerProcess__c != true) {
                    String hospId = newHosp.Id;
                    Id hospitalIdQueueble =
                            System.enqueueJob(new RestCalloutAfterAddHospital(hospId, 'editNewHospital'));
                }
            }

        }
    } else if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            for (Hospital__c oldHosp : Trigger.old) {
                Id hospitalIdQueueble =
                        System.enqueueJob(new RestCalloutAfterAddHospital(oldHosp, 'deleteNewHospital'));
            }
        }
    }
}