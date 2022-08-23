public virtual class ProductWithPriceWrapper {
        public ProductWithPriceWrapper(){}
        @AuraEnabled
        public Product2 product{get; set;}
        @AuraEnabled
        public PricebookEntry productStandardPrice{get; set;}
        @AuraEnabled
        public  List<PricebookEntry> productDiscountPrice{get; set;}

        public productWithPriceWrapper(Product2 item, PricebookEntry standardPrice,  List<PricebookEntry> discountPrice ){
            this.product = item;
            this.productStandardPrice = standardPrice;
            this.productDiscountPrice = discountPrice;
        }
      
    }