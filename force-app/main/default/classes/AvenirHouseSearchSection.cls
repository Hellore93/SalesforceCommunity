public with sharing class AvenirHouseSearchSection {

        @AuraEnabled
        public static List<Product2> getProducts() {
    
        List<Product2> productList =
        [SELECT Id, Name, Family, Description, ProductCode, Country__c, City__c  FROM Product2 WHERE Avenir__c = TRUE LIMIT 100];
        return productList;
        }

        @AuraEnabled
    public static List<Product2> getHouseByName(String houseName) {
        String houseNameSearch = '%' + houseName + '%';
        List<Product2> productList =
        [SELECT Id, Name, Family, Description, ProductCode FROM Product2 WHERE Name LIKE :houseNameSearch AND Avenir__c = TRUE LIMIT 100];
        return productList;
    }

    @AuraEnabled
    public static Product2 deleteHouse(Product2 house) {
        delete house;
        return house;
    }

    @AuraEnabled
    public static List<ContentVersion> getProductPhoto(String productId){
        List<ContentVersion> productPhoto = 
        [SELECT FirstPublishLocationId, FileType, ContentBodyId, Title, 	
        ContentDocumentId FROM ContentVersion WHERE FirstPublishLocationId = :productId LIMIT 100];
        return productPhoto;
    }

    @AuraEnabled
    public static ContentDocument deletePhotoById(String photoId){
        ContentDocument contentToDelete = [SELECT Id, Title FROM ContentDocument WHERE Id = :photoId];
        delete contentToDelete;
        return contentToDelete;
    }

    @AuraEnabled
    public static void setDefaultPhotoUrl(String productId, String link){
        Product2 objectToSetDefaultPhoto = [SELECT  Id, DisplayUrl, Name FROM Product2 WHERE Id= :productId LIMIT 200];
        objectToSetDefaultPhoto.DisplayUrl = link;
        update objectToSetDefaultPhoto;
    }

    @AuraEnabled
    public static String savePriceBookEntry(String priceId, String productId, Decimal price){
        
        Pricebook2 priceBookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        if(priceId != null){
            PricebookEntry createPriceBookItemSoql = [SELECT Id, Product2Id, IsActive, Pricebook2Id, UnitPrice FROM PricebookEntry WHERE Id = :priceId LIMIT 10];
            PricebookEntry createPriceBookItem = new PricebookEntry(
                Id = priceId,
                Product2Id = productId,
                IsActive = true,
                Pricebook2Id = priceBookId.Id,
                UnitPrice = price
            );
            update createPriceBookItem;
        } else {
            PricebookEntry createPriceBookItem = new PricebookEntry();
            createPriceBookItem.Product2Id = productId;
            createPriceBookItem.IsActive = true;
            createPriceBookItem.Pricebook2Id = priceBookId.Id;
            createPriceBookItem.UnitPrice = price;
            upsert createPriceBookItem;
        }

        return null;
    }

    @AuraEnabled
    public static PricebookEntry getPriceById(String Product2IdFront){
        PricebookEntry price = [SELECT  Id, Product2Id, isActive, UnitPrice FROM PricebookEntry WHERE Product2Id= :Product2IdFront LIMIT 1];
        return price;
    }
}