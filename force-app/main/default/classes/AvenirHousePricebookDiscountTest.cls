@IsTest
public with sharing class AvenirHousePricebookDiscountTest {
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
    public static void shouldPricebookDiscount(){
        Product2 prod = [SELECT Id FROM Product2 LIMIT 1];
        Pricebook2 pricebook = [SELECT Id FROM Pricebook2 LIMIT 1];
        Map<String,Object> mapProd = new Map<String,Object>();
        mapProd.put('Name', 'a');
        mapProd.put('Id', prod.Id);

        Object ab = pricebook.Id;
        Object bc = prod.Id;
        Object cd = true;
        Object de = null;
        List<Object> listOb = new List<Object>{ab, bc, cd, de};
        List<Object> newList = new List<Object>{listOb};
        Map<String,Object> mapTest = new Map<String,Object>();
        mapTest.put('Name', 'Test name');
        mapTest.put('Description', 'Test description');
        mapTest.put('IsActive', true);
        mapTest.put('StartDate', String.valueOf(Date.today()));
        mapTest.put('EndDate', String.valueOf(Date.today().addDays(2)));
        mapTest.put('product', newList);
        try {
            AvenirHousePricebookDiscount.saveNewPrice(mapTest);
        } catch (Exception e) {
            System.debug(e);
        }
        
    }
}