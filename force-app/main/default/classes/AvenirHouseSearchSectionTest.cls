@IsTest
public with sharing class AvenirHouseSearchSectionTest {

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

        Pricebook2 pricebook1 = new Pricebook2(
            Name = 'testPricebook1'
        );
        insert pricebook1;

        Pricebook2 pricebook2 = new Pricebook2(
            Name = 'testPricebook2'
        );
        insert pricebook2;

        PricebookEntry standardPrice = new PricebookEntry(
            UnitPrice=500,
            Product2Id=prod.Id, 
            Pricebook2Id=standardPricebook.Id, 
            IsActive=true
            );
        insert standardPrice;

        ContentVersion content=new ContentVersion(); 
        content.Title='Title_Picture'; 
        content.FirstPublishLocationId = prod.Id;
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        insert content;

    }

    @IsTest
    public static void shouldGetProducts(){
        List<Product2> prod = [SELECT Id, Name, Family, Description, ProductCode, Country__c, City__c   FROM Product2 LIMIT 1];
        List<Product2> testClass = AvenirHouseSearchSection.getProducts();
        System.assertEquals(prod, testClass);
    }

    @IsTest
    public static void shouldGetHouseByName(){
        List<Product2> prod = [SELECT Id, Name, Family, Description, ProductCode FROM Product2 LIMIT 1];
        List<Product2> testClass = AvenirHouseSearchSection.getHouseByName('testProd');
        System.assertEquals(prod, testClass);
    }

    
    @IsTest
    public static void shouldDeleteHouse(){
        Product2 prod = [SELECT Id, Name, Family, Description, ProductCode FROM Product2 LIMIT 1];
        product2 testMethodProd = AvenirHouseSearchSection.deleteHouse(prod);
        List<Product2> prod2 = [SELECT Id, Name, Family, Description, ProductCode FROM Product2 LIMIT 1];
        System.assertEquals(true, prod2.size() == 0);
    }

    @IsTest
    public static void shouldGetProductPhoto(){
        Product2 prod = [SELECT Id, Name, Family, Description, ProductCode FROM Product2 LIMIT 1];
        List<ContentVersion> contentList = AvenirHouseSearchSection.getProductPhoto(prod.Id);
        System.assertEquals(prod.Id, contentList[0].FirstPublishLocationId);
    }

    @IsTest
    public static void shouldSetDefaultPhotoUrl(){    
        Product2 objectToSetDefaultPhoto = [SELECT  Id, DisplayUrl, Name FROM Product2 LIMIT 1];
        AvenirHouseSearchSection.setDefaultPhotoUrl(objectToSetDefaultPhoto.Id, 'www.a.com');
        Product2 updateObject = [SELECT  Id, DisplayUrl, Name FROM Product2 LIMIT 1];
        System.assertEquals('www.a.com', updateObject.DisplayUrl);
    }

    @IsTest
    public static void shouldSavePriceBookEntry(){
        PricebookEntry standard = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry LIMIT 1];
        AvenirHouseSearchSection.savePriceBookEntry(standard.Id, standard.Product2Id, 666);
        PricebookEntry afterUpdate = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry LIMIT 1];
        System.assertEquals(666, afterUpdate.UnitPrice);
    }

    @IsTest
    public static void shouldGetPriceById(){
        PricebookEntry price = [SELECT  Id, Product2Id, isActive, UnitPrice FROM PricebookEntry LIMIT 1];
        PricebookEntry testObject = AvenirHouseSearchSection.getPriceById(price.Product2Id);
        System.assertEquals(price, testObject);
    }
}