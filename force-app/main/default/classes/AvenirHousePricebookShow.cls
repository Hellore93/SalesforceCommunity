public with sharing class AvenirHousePricebookShow {
    public AvenirHousePricebookShow() {}

    @AuraEnabled
    public static List<Pricebook2> getAllPricebook(){
        List<Pricebook2> allPricebook = [SELECT Id, Name, Description, IsActive, Discount_Start__c, Discount_Finish__c FROM Pricebook2 LIMIT 200];
        return allPricebook;
    }

    @AuraEnabled
    public static List<PricebookEntry> getPricebookDiscountById(String pricebookId){
        List<PricebookEntry> pricebookDiscountProductList = [SELECT Id, Name, Pricebook2Id, Product2Id, UnitPrice, IsActive FROM PricebookEntry WHERE Pricebook2Id = :pricebookId LIMIT 200];
        return pricebookDiscountProductList;
    }

    @AuraEnabled
    public static void deletePricebook(Pricebook2 pricebook){
        delete pricebook;        
    }

    @AuraEnabled
    public static Map<String, Object> getStandardPrice(){
        Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        List<PricebookEntry> standardPriceList = [SELECT Id, Name, Pricebook2Id, Product2Id, UnitPrice, IsActive FROM PricebookEntry WHERE Pricebook2Id = :pricebook.Id LIMIT 200];
        Map<String, Object> mapOfStandardPrice = new Map<String, Object>();
        for(PricebookEntry item : standardPriceList){
            mapOfStandardPrice.put(item.Product2Id, item);
        }
        
        return mapOfStandardPrice;
    }

    @AuraEnabled
    public static void updatePricebookEntry(List<PricebookEntry> priceUpdate){
        Map<String, Object> standardPriceMap = getStandardPrice();
        List<PricebookEntry> pricebookToUpdate = new List<PricebookEntry>();
        for(PricebookEntry item : priceUpdate){
            PricebookEntry obj =  (PricebookEntry) standardPriceMap.get(item.Product2Id);
            System.debug(item);
            System.debug(obj);
            if(item.UnitPrice > obj.UnitPrice){
                PricebookEntry newEditObject = new PricebookEntry();
                newEditObject.Id = item.Id;
                newEditObject.Pricebook2Id = item.Pricebook2Id;
                newEditObject.Product2Id = item.Product2Id;
                newEditObject.UnitPrice = obj.UnitPrice;
                    // IsActive = item.IsActive
                
                pricebookToUpdate.add(newEditObject);
            } else {
                pricebookToUpdate.add(item);
            }
        }
        update priceUpdate;
    }

    @AuraEnabled
    public static List<PricebookEntry> addNewProductToPricebook(String pricebookId){
        Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        List<PricebookEntry> product = [SELECT Id, Name, Product2Id, Pricebook2.Name, Pricebook2.Description, UnitPrice FROM PricebookEntry WHERE IsActive = true AND Pricebook2Id = :pricebook.Id LIMIT 200];
        List<PricebookEntry> existProduct = [SELECT Id, Name, Product2Id, Pricebook2.Name, Pricebook2.Description, UnitPrice FROM PricebookEntry WHERE IsActive = true AND Pricebook2Id = :pricebookId LIMIT 200];
    
        Map<String, Object> mapOfExistProduct = new Map<String, Object>();
        List<PricebookEntry> sendProductToFront = new List<PricebookEntry>();
        for(PricebookEntry item: existProduct){
            mapOfExistProduct.put(item.Product2Id, item);
        }

        for(PricebookEntry item : product){
            if(!mapOfExistProduct.containsKey(item.Product2Id)){
                sendProductToFront.add(item);
            }        
        } 
        return sendProductToFront;
    }

    @AuraEnabled
    public static void saveNewProductInPricebook(List<PricebookEntry> newProductToPricebook, String pricebookId){
        List<PricebookEntry> listToPush = new List<PricebookEntry>();
        for(PricebookEntry item: newProductToPricebook){
            PricebookEntry entryItem = new PricebookEntry();
            entryItem.Pricebook2Id = pricebookId;
            entryItem.Product2Id = (Id) item.Product2Id;
            entryItem.IsActive = true ;
            entryItem.UnitPrice = item.UnitPrice;
            listToPush.add(entryItem);
        }
        insert listToPush;
    }

    @AuraEnabled
    public static void deletePricebookProduct(List<PricebookEntry> pricebookItem){
        delete pricebookItem;
    }

}