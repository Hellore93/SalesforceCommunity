@IsTest
public with sharing class AvenirHouseCreateProductTest {
    
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
        Product2 prod = [SELECT Id FROM Product2 LIMIT 1];
        AvenirHouseCreateProduct.saveProductPrice(prod.Id, (Decimal)150);
    }

    @IsTest
    public static void shouldSaveProductMainPhoto(){
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        AvenirHouseCreateProduct.saveProductMainPhoto(prod.Id, 'https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/0687Q000000WIZ4QAO');
        Product2 prodNew = [SELECT Id, DisplayUrl FROM Product2 LIMIT 1];
        System.assertEquals('https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/0687Q000000WIZ4QAO',prodNew.DisplayUrl);
    } 
    
    @IsTest
    public static void shouldCancelProduct(){
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        AvenirHouseCreateProduct.cancelProduct(prod.Id);
        List<Product2> prod2 = [SELECT Id FROM product2];
        System.assertEquals(0, prod2.size());
    }

    @IsTest
    public static void shouldGetProductPhoto(){
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        List<ContentVersion> prod2 = AvenirHouseCreateProduct.getProductPhoto(prod.Id);
        System.assertEquals(1, prod2.size());
    }

    @IsTest
    public static void shouldSetDefaultPhotoUrl(){        
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        AvenirHouseCreateProduct.setDefaultPhotoUrl(prod.Id, 'https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/0687Q000000WIZ4QAO');
        Product2 prodNew = [SELECT Id, DisplayUrl FROM Product2 LIMIT 1];
        System.assertEquals('https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/0687Q000000WIZ4QAO',prodNew.DisplayUrl);
    }
}