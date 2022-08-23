@IsTest
public with sharing class ComunityAvenirHouseCacheTest {

    @TestSetup
    public static void testSetup(){
        product2 prod = new Product2(
            Name = 'testProd',
            Family = 'fam',
            Description = 'test',
            ProductCode = 'AAABBB',
            Country__c = 'Poland',
            City__c = 'Kielce',
            DisplayUrl = ''
           );
        insert prod;

        Pricebook2 standardPricebook = new Pricebook2(
            Id=Test.getStandardPricebookId(), 
            IsActive=true);
        update  standardPricebook;


        PricebookEntry standardPrice = new PricebookEntry(
            UnitPrice=500,
            Product2Id=prod.Id, 
            Pricebook2Id=standardPricebook.Id, 
            IsActive=true
            );
        insert standardPrice;
    }

    @IsTest
    public static void shouldGetCache(){
        ComunityAvenirHouseCache.getCache();
    }

    @IsTest
    public static void shouldAddToCache(){
        Product2 prod = [Select Id FROM Product2 LIMIT 1];
        PricebookEntry standardPricebook = [SELECT Id FROM PricebookEntry LIMIT 1];
        List<PricebookEntry> discountPricebook = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry LIMIT 1];
        Date today = Date.today();
        Date yesterday = Date.today() -1;
        ComunityAvenirHouseCache.addToCache(prod, standardPricebook, discountPricebook, today, yesterday, '1');
    }

    @IsTest
    public static void shlouldClearShoppingCart(){
        ComunityAvenirHouseCache.clearShoppingCart();
    }

    @IsTest
     public static void shouldRemoveFromCache(){
         Product2 prod = [Select Id FROM Product2 LIMIT 1];
         PricebookEntry standardPricebook = [SELECT Id FROM PricebookEntry LIMIT 1];
         List<PricebookEntry> discountPricebook = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry LIMIT 1];
         Date today = Date.today();
         Date yesterday = Date.today() -1;
         ComunityAvenirHouseCache.addToCache(prod, standardPricebook, discountPricebook, today, yesterday, '1');

         ComunityAvenirHouseCache.removeFromCache(prod.Id);
     }
}