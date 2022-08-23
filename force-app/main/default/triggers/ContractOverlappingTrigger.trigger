/**
 * Created by 48781 on 30.04.2022.
 */

trigger ContractOverlappingTrigger on Contract__c (before insert, before update) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {

            ContractOverlappingHelper.handleAfterInsert( Trigger.new );
        }
    }
}