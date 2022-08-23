@IsTest
public with sharing class AvenirHouseCreateProductTest {
    
    @TestSetup
    public static void testSetup(){
        product2 prod = new Product2(
            Name = 'testProd'
           );
        insert prod;

        Pricebook2 pricebookTest = new Pricebook2(
            Name = 'testPricebook'
        );
        insert pricebookTest;

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

        PricebookEntry discountPrice = new PricebookEntry(
            UnitPrice=400,
            Product2Id=prod.Id, 
            Pricebook2Id=[SELECT Id FROM Pricebook2 WHERE Name ='testPricebook'].Id, 
            IsActive=true
            );
        insert discountPrice;


        ContentVersion content=new ContentVersion(); 
        content.Title='Title_Picture'; 
        content.FirstPublishLocationId = prod.Id;
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        insert content;
    }

    @IsTest
    public static void shouldSaveProductPrice(){
        Product2 newProd = new Product2(Name = 'nowyProd');
        insert newProd;
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'nowyProd' LIMIT 1];
        AvenirHouseCreateProduct.saveProductPrice(prod.Id, (Decimal)150);
    }

    @IsTest
    public static void shouldSaveProductMainPhoto(){
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        AvenirHouseCreateProduct.saveProductMainPhoto(prod.Id, 'https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/0687Q000000WIZ4QAO');
    } 
    
    @IsTest
    public static void shouldCancelProduct(){
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        AvenirHouseCreateProduct.cancelProduct(prod.Id);
    }

    @IsTest
    public static void shouldGetProductPhoto(){
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        List<ContentVersion> prod2 = AvenirHouseCreateProduct.getProductPhoto(prod.Id);
    }

    @IsTest
    public static void shouldSetDefaultPhotoUrl(){        
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        AvenirHouseCreateProduct.setDefaultPhotoUrl(prod.Id, 'https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/0687Q000000WIZ4QAO');
    }
}