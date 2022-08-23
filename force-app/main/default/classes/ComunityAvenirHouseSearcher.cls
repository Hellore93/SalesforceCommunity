public without sharing class ComunityAvenirHouseSearcher extends ProductWithPriceWrapper{

    @AuraEnabled
        public static List<String> getProductFamily() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Product2.Family.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p : pList) {
            options.add(p.getLabel());
        }
        return options;
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> searchHomeByName(String houseName){
        String nameFromSearcher = '%' + houseName + '%';
        List<Product2> listOfProduct = [SELECT Id, Name, ProductCode, Description, IsActive, Family, DisplayUrl, Avenir__c, Country__c, City__c FROM Product2 
        WHERE (Name LIKE :nameFromSearcher OR Description LIKE :nameFromSearcher OR Family LIKE :nameFromSearcher OR ProductCode 
        LIKE :nameFromSearcher OR Country__c LIKE :nameFromSearcher) AND Avenir__c = true AND Extra_option__c = false AND IsActive = true];
        return listOfProduct;
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getExtraOpion(){
        List<PricebookEntry> listOfProduct = [SELECT Id, Name, Pricebook2Id, Product2Id, UnitPrice, IsActive, ProductCode, Pricebook2.IsStandard 
        FROM PricebookEntry WHERE IsActive = true AND Pricebook2.IsStandard = true AND Product2.Extra_option__c = true];
        return listOfProduct;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, PricebookEntry> getStandardPriceList(){
        List<PricebookEntry> listOfPrice = [SELECT Id, Name, Pricebook2Id, Product2Id, UnitPrice, IsActive, ProductCode, Pricebook2.IsStandard 
        FROM PricebookEntry WHERE IsActive = true AND Pricebook2.IsStandard = true];
        Map<String, PricebookEntry> mapOfStandardPrice = new  Map<String, PricebookEntry>();

        for(PricebookEntry item: listOfPrice){
            mapOfStandardPrice.put(item.Product2Id, item);
        }
        return mapOfStandardPrice;
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getDiscountPriceList(){
        List<PricebookEntry> listOfPrice = [SELECT Id, Name, Pricebook2Id, Product2Id, UnitPrice, IsActive, ProductCode, Pricebook2.IsStandard 
        FROM PricebookEntry WHERE IsActive = true AND Pricebook2.IsStandard = false];
        return listOfPrice;
    }

    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getProductPhotoGallery(String productId){
        
        List<ContentDocumentLink> productPhoto  = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :productId];
        return productPhoto;
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductById(String productId){
        List<Product2> listOfProduct = [SELECT Id, Name, ProductCode, Description, IsActive, Family, DisplayUrl, Avenir__c, Country__c, City__c, Street__c FROM Product2 
        WHERE Id = :productId ];
        return listOfProduct;
    }

    @AuraEnabled(cacheable=true)
    public static List<productWithPriceWrapper> startSearch(String houseName){
        List<Product2> allHouseList = searchHomeByName(houseName);

        Map<String, PricebookEntry> mapOfPrice = getStandardPriceList();
        List<PricebookEntry> listOfDiscount = getDiscountPriceList();        
        List<productWithPriceWrapper> listProductWithPrice = new List<productWithPriceWrapper>();

        for(Product2 item : allHouseList) {
            List<PricebookEntry> listOfDiscountPrice = new List<PricebookEntry>();
            
            for(PricebookEntry element : listOfDiscount){
                if(element.Product2Id == item.Id){
                    listOfDiscountPrice.add(element);
                }
            }
            productWithPriceWrapper productWithPrice = new productWithPriceWrapper(item, mapOfPrice.get(item.Id), listOfDiscountPrice);
            listProductWithPrice.add(productWithPrice);
        } 

        return listProductWithPrice;
    }

    @AuraEnabled(cacheable=true)
    public static List<productWithPriceWrapper> getProductDescription(String houseId){
        
        List<Product2> productDetail = getProductById(houseId);
        Map<String, PricebookEntry> mapOfPrice = getStandardPriceList();
        List<PricebookEntry> listOfDiscount = getDiscountPriceList();        
        List<productWithPriceWrapper> listProductWithPrice = new List<productWithPriceWrapper>();

        for(Product2 item : productDetail) {
            List<PricebookEntry> listOfDiscountPrice = new List<PricebookEntry>();
            
            for(PricebookEntry element : listOfDiscount){
                if(element.Product2Id == item.Id){
                    listOfDiscountPrice.add(element);
                }
            }
            productWithPriceWrapper productWithPrice = new productWithPriceWrapper(item, mapOfPrice.get(item.Id), listOfDiscountPrice);
            listProductWithPrice.add(productWithPrice);
        } 

        return listProductWithPrice;
    }

    @AuraEnabled
    public static Avenir_Commentary__c saveNewCommentary(String commentId, String comment, Decimal rating, String productId){
        
        Avenir_Commentary__c newObject = 
        commentId == ''? new Avenir_Commentary__c() : 
        new Avenir_Commentary__c(
            Id = commentId
        );
      
        newObject.Commentary__c = comment;
        newObject.rating__c = rating;
        newObject.Product__c = productId;
        newObject.Approval__c = false;
        
        upsert newObject;
        return newObject;
    }

    @AuraEnabled(cacheable=true)
    public static List<Avenir_Commentary__c> getCommentList(String productId){
        List<Avenir_Commentary__C> productComment = [SELECT Id, OwnerId, Name, CreatedById, LastModifiedDate, Product__c,
         CreatedBy.Name, Commentary__c, rating__c, Approval__c
        FROM Avenir_Commentary__c Where Product__c = :productId];
        return productComment;
    }

}