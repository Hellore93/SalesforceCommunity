public with sharing class AvenirHousePricebookBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    public Database.QueryLocator start(Database.BatchableContext baseRecord){
        String query = 'SELECT Id, IsActive, Discount_Start__c, Discount_Finish__c  FROM Pricebook2';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext baseRecord, List<Pricebook2> scope){
        List<Pricebook2> pricebookForUpdate = new List<Pricebook2>();
        for(Pricebook2 pricebook : scope){
            if((Date.today() >= pricebook.Discount_Start__c) && (Date.today() <= pricebook.Discount_Finish__c)){
                pricebook.IsActive = true;
                pricebookForUpdate.add(pricebook);
            } else{
                pricebook.IsActive = false;
                pricebookForUpdate.add(pricebook);
            }
        }
        update pricebookForUpdate;
    }
  
    public void finish(Database.BatchableContext BC){
    }
}