public with sharing class ComunityAvenirHouseCache extends ProductWithPriceWrapper {

    @AuraEnabled(cacheable=true)
    public static String getCache(){
        List<ShoppingCartWrapper> wrapperProductList = (List<ShoppingCartWrapper> ) Cache.Session.get('HouseCart');
        System.debug(wrapperProductList);
        // return wrapperProductList;
        return JSON.serialize(wrapperProductList);
    }

    @AuraEnabled(cacheable=true)
    public static ShoppingCartWrapper addToCache(Product2 product, PricebookEntry standardPrice,  List<PricebookEntry> discountPrice, Date startDate, Date endDate, String extraOption){
        ProductWithPriceWrapper productToCart = new ProductWithPriceWrapper(product, standardPrice, discountPrice);

        ShoppingCartWrapper newWrap = new ShoppingCartWrapper(productToCart, startDate, endDate, extraOption);        

        List<ShoppingCartWrapper> wrapperProductList = (List<ShoppingCartWrapper> ) Cache.Session.get('HouseCart');
        // List<productWithPriceWrapper> wrapperProductList = (List<productWithPriceWrapper> ) Cache.Session.get('HouseCart');
        if(wrapperProductList == null){
            wrapperProductList = new List<ShoppingCartWrapper>();
            wrapperProductList.add(newWrap);
            Cache.Session.put('HouseCart', wrapperProductList);
            // System.debug(Cache.Session.get('HouseCart'));
        } else {
            wrapperProductList.add(newWrap);
            Cache.Session.put('HouseCart', wrapperProductList);
        }
        return newWrap;
    }

    @AuraEnabled(cacheable=true)
    public static void clearShoppingCart(){
       List<ShoppingCartWrapper> wrapperProductList = (List<ShoppingCartWrapper> ) Cache.Session.get('HouseCart');
        wrapperProductList = new  List<ShoppingCartWrapper>();
        Cache.Session.put('HouseCart', wrapperProductList);
    }
 
    @AuraEnabled
    public static List<ShoppingCartWrapper> removeFromCache(String productId){
        List<ShoppingCartWrapper> wrapperProductList = (List<ShoppingCartWrapper> ) Cache.Session.get('HouseCart');
            for (Integer i = 0; i < wrapperProductList.size(); i++) {
                if(wrapperProductList[i].prod.product.Id == productId){
                    wrapperProductList.remove(i); 
                }
            }
            Cache.Session.put('HouseCart', wrapperProductList);
        return wrapperProductList;
    }

    public class ShoppingCartWrapper{

        @AuraEnabled
        public productWithPriceWrapper prod {get; set;}
        @AuraEnabled
        public Date startDate {get; set;}
        @AuraEnabled
        public Date endDate {get; set;}
        @AuraEnabled
        public String extraOption {get; set;}

        public ShoppingCartWrapper (productWithPriceWrapper wrap, Date stDate, Date enDate, String extraOpt){
            this.prod = wrap;
            this.startDate = stDate;
            this.endDate = enDate;
            this.extraOption = extraOpt;
        }
    }

}