@IsTest
public with sharing class AvenirHousePricebookShowTest {

    @TestSetup
    public static void testSetup(){
        product2 prod = new Product2(
            Name = 'testProd'
           );
        insert prod;

        Pricebook2 standartPricebook = new Pricebook2(
            Id=Test.getStandardPricebookId(),
            IsActive=true);
        update standartPricebook;

        Pricebook2 pricebook1 = new Pricebook2(
            Name = 'testPricebook1'
        );
        insert pricebook1;

        Pricebook2 pricebook2 = new Pricebook2(
            Name = 'testPricebook2'
        );
        insert pricebook2;

        PricebookEntry standartPrice = new PricebookEntry(
            UnitPrice=500,
            Product2Id=prod.Id, 
            Pricebook2Id=standartPricebook.Id, 
            IsActive=true
            );
        insert standartPrice;

        PricebookEntry discountPrice = new PricebookEntry(
            UnitPrice=400,
            Product2Id=prod.Id, 
            Pricebook2Id=[SELECT Id FROM Pricebook2 WHERE Name ='testPricebook1'].Id, 
            IsActive=true
            );
        insert discountPrice;

    }

    @IsTest
    public static void shouldGetAllPricebook(){
        List<Pricebook2> listPricebook = AvenirHousePricebookShow.getAllPricebook();
    }

    @IsTest
    public static void shouldGetPricebookDiscountById(){
        List<PricebookEntry> listPricebook = AvenirHousePricebookShow.getPricebookDiscountById([SELECT Id from Pricebook2 LIMIT 1].Id);
    }

    @IsTest
    public static void shouldDeletePricebook(){
        AvenirHousePricebookShow.deletePricebook([SELECT Id FROM Pricebook2 WHERE Name = 'testPricebook1' LIMIT 1]);
        List<Pricebook2> listPrice = [SELECT Id FROM Pricebook2 WHERE Name = 'testPricebook1' LIMIT 1 ];
    }

    @IsTest
    public static void shouldGetStandardPrice(){
        Map<String, Object> testMap = AvenirHousePricebookShow.getStandardPrice();
    }

    @IsTest
    public static void shouldUpdatePricebookEntry(){
        List<PricebookEntry> pricebookEntry = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry LIMIT2];
        AvenirHousePricebookShow.updatePricebookEntry(pricebookEntry);
    }

    @IsTest
    public static void shouldAddNewProductToPricebook(){
        Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        List<PricebookEntry> pricebookEntry = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry LIMIT2];
        AvenirHousePricebookShow.addNewProductToPricebook(pricebook.Id);
    }

    @IsTest
    public static void shouldSaveNewProductInPricebook(){
        Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'testPricebook1' LIMIT 1];
        List<PricebookEntry> pricebookEntry = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry LIMIT2];
        AvenirHousePricebookShow.saveNewProductInPricebook(pricebookEntry, pricebook.Id);
    }
}