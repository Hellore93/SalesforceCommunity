public with sharing class AvenirHouseCreateProduct {

    @AuraEnabled
    public static void saveProductPrice(String productId, Decimal productPrice){
        Pricebook2 priceBookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        PricebookEntry newProductEntery = new PricebookEntry();
        newProductEntery.Product2Id = productId;
        newProductEntery.UnitPrice = (Decimal) productPrice;
        newProductEntery.Pricebook2Id = priceBookId.Id;
        newProductEntery.IsActive = true;

        insert newProductEntery;
    }

    @AuraEnabled
    public static void saveProductMainPhoto(String productId, String photoLink){

        Product2 existProduct = new Product2();
        existProduct.Id = productId;
        existProduct.DisplayUrl = photoLink;

        update existProduct;
    }

    @AuraEnabled
    public static void cancelProduct(String productId){
        Product2 cancelProduct = new Product2();
        cancelProduct.Id = productId;
        delete cancelProduct;
    }

    @AuraEnabled
    public static List<ContentVersion> getProductPhoto(String productId){
        List<ContentVersion> productPhoto = 
        [SELECT FirstPublishLocationId, FileType, ContentBodyId, Title, 	
        ContentDocumentId FROM ContentVersion WHERE FirstPublishLocationId = :productId LIMIT 100];
        return productPhoto;
    }

    @AuraEnabled
    public static void setDefaultPhotoUrl(String productId, String link){
        Product2 objectToSetDefaultPhoto = [SELECT  Id, DisplayUrl, Name FROM Product2 WHERE Id= :productId LIMIT 200];
        objectToSetDefaultPhoto.DisplayUrl = link;
        update objectToSetDefaultPhoto;
    }

    @AuraEnabled
    public static ContentDocument deletePhotoById(String photoId){
        ContentDocument contentToDelete = [SELECT Id, Title FROM ContentDocument WHERE Id = :photoId];
        delete contentToDelete;
        return contentToDelete;
    }
}