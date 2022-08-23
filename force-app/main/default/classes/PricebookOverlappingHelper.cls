public with sharing class PricebookOverlappingHelper {

    public static void hndleAfterInsert(List<Pricebook2> pricebookTrigger){
        String pricebookId = String.valueOf(pricebookTrigger[0].Id);
        System.debug(pricebookTrigger);
        System.debug('tutaj ' + pricebookId);
        

        List<PricebookEntry> allPricebookEntries = [
            SELECT Id, Name, Pricebook2Id, Product2Id, Pricebook2.Name, Pricebook2.Discount_Start__c, Pricebook2.Discount_Finish__c, Pricebook2.IsActive FROM PricebookEntry 
            WHERE Pricebook2.IsActive = true
        ];
        List<PricebookEntry> newPricebookEntries = [
            SELECT Id, Name, Pricebook2Id, Product2Id, Pricebook2.Name, Pricebook2.Discount_Start__c, Pricebook2.Discount_Finish__c, Pricebook2.IsActive FROM PricebookEntry 
            WHERE Pricebook2.IsActive = true AND Pricebook2Id = :pricebookId
            ];
       System.debug(newPricebookEntries);
       System.debug(allPricebookEntries);
    }
}