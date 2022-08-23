public with sharing class AvenirHousePricebook {
    public AvenirHousePricebook() { 
       }


    @AuraEnabled
    public static List<priceWithDiscount> getProductAndPrice(){
        List<PricebookEntry> price = [SELECT Id, Name, Product2Id, Pricebook2.Name, Pricebook2.Description, UnitPrice FROM PricebookEntry WHERE IsActive = true AND Pricebook2Id = '01s7Q00000A6q1sQAB' LIMIT 200];
        List<PricebookEntry> priceWithDiscount = [SELECT Id, Name, Product2Id, Pricebook2.Name, Pricebook2.Description, UnitPrice FROM PricebookEntry WHERE IsActive = true LIMIT 200];
        List<PriceWithDiscount> listOfWrapper = new List<PriceWithDiscount>();
        Map<String, PricebookEntry> priceWithDiscountMap = new Map<String, PricebookEntry>();
        
        for(PricebookEntry item: priceWithDiscount){
            priceWithDiscountMap.put(item.Product2Id, item);
        }   

        for(PricebookEntry item:price){ 
            if(priceWithDiscountMap.containsKey(item.Product2Id)){ 
                    PriceWithDiscount newWrapper = new PriceWithDiscount(item, priceWithDiscountMap.get(item.Product2Id));
                    listOfWrapper.add(newWrapper);                               
            }
        }
        return listOfWrapper;
    }

    @AuraEnabled
    public static List<priceWithDiscount> getProductByName(String houseName) {
        String houseNameSearch = '%' + houseName + '%';
        List<PricebookEntry> price =
        [SELECT Id, Name, Product2Id, UnitPrice FROM PricebookEntry WHERE IsActive = true AND Pricebook2Id = '01s7Q00000A6q1sQAB' AND Name LIKE :houseNameSearch LIMIT 200];
        List<PricebookEntry> priceWithDiscount = [SELECT Id, Name, Product2Id, Pricebook2.Name, Pricebook2.Description, UnitPrice FROM PricebookEntry WHERE IsActive = true LIMIT 200];

        List<PriceWithDiscount> listOfWrapper = new List<PriceWithDiscount>();
        Map<String, PricebookEntry> priceWithDiscountMap = new Map<String, PricebookEntry>();
        
        for(PricebookEntry item: priceWithDiscount){
            priceWithDiscountMap.put(item.Product2Id, item);
        }   

        for(PricebookEntry item:price){ 
            if(priceWithDiscountMap.containsKey(item.Product2Id)){ 
                    PriceWithDiscount newWrapper = new PriceWithDiscount(item, priceWithDiscountMap.get(item.Product2Id));
                    listOfWrapper.add(newWrapper);                               
            }
        }
        return listOfWrapper;
    }

    public class PriceWithDiscount{
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String Product2Id;
        @AuraEnabled
        public Decimal UnitPrice;
        @AuraEnabled
        public Decimal PriceAfterDiscount;
        @AuraEnabled
        public String PricebookName;
        @AuraEnabled
        public String PricebookDescription;
  

    public PriceWithDiscount (PricebookEntry price, PricebookEntry discountPrice){
        this.Id = (String) price.Id;
        this.Name = (String) price.Name;
        this.Product2Id = (String) price.Product2Id;
        this.UnitPrice = (Decimal) price.UnitPrice;
        this.PriceAfterDiscount = (Decimal) discountPrice.UnitPrice;
        this.PricebookName = (String) discountPrice.Pricebook2.Name;
        this.PricebookDescription = (String) discountPrice.Pricebook2.Description;
    }
    }
}