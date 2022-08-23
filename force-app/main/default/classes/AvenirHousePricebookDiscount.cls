public with sharing class AvenirHousePricebookDiscount {

    @AuraEnabled
    public static void saveNewPrice(Map<String, Object> getFromFront){
        pricebookDiscount newWrapper = new pricebookDiscount(getFromFront);
        System.debug(newWrapper);
        Pricebook2 newProduct = new Pricebook2();
        newProduct.Name = newWrapper.NamePricabook;
        newProduct.Description = newWrapper.Description;
        newProduct.IsActive = newWrapper.IsActive;  
        newProduct.Discount_Start__c = Date.valueOf(newWrapper.StartDate);
        newProduct.Discount_Finish__c = Date.valueOf(newWrapper.EndDate);

        try {
            insert newProduct;
        } catch (DmlException e) {
            system.debug(e);
        }

        List<PricebookEntry> listToPush = new List<PricebookEntry>();
        System.debug(newWrapper.listOfProduct);
        for(Object item : newWrapper.listOfProduct){
            PricebookEntry entryItem = new PricebookEntry();
            Map<String,Object> element = (Map<String, Object>) item;
            System.debug(element);
            entryItem.Pricebook2Id = newProduct.id;
            entryItem.Product2Id = (Id) element.get('Product2Id');
            entryItem.IsActive = true ;
            entryItem.UnitPrice = element.get('UnitPriceDiscount') != null ?  (Decimal)element.get('UnitPriceDiscount') :(Decimal) element.get('UnitPrice') ;
            listToPush.add(entryItem);
        }
        insert listToPush;
    }

    public class pricebookDiscount {
        @AuraEnabled
        public String NamePricabook;
        @AuraEnabled
        public String Description;
        @AuraEnabled
        public Boolean IsActive;
        @AuraEnabled
        public String StartDate;
        @AuraEnabled
        public String EndDate;
        @AuraEnabled
        public List<Object> listOfProduct;

        public pricebookDiscount(Map<String, Object> productDiscount){
            System.debug(productDiscount);
            this.NamePricabook = (String) productDiscount.get('Name');
            this.Description = (String) productDiscount.get('Description');
            this.IsActive = (Boolean) productDiscount.get('IsActive');
            this.StartDate = (String) (productDiscount.get('StartDate'));
            this.EndDate = (String) (productDiscount.get('EndDate'));
            this.listOfProduct = (List<Object>) JSON.deserializeUntyped(JSON.serialize(productDiscount.get('product')));
        }
    }
}