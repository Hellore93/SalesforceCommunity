@IsTest
public with sharing class ComunityAvenirHouseOrderTest {
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

        Account acc = new Account (
            Name = 'Community Account',
            First_Name__c = 'Important Test'
        );
        insert acc;

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

        Order newOrder = new Order();
            newOrder.AccountId = acc.Id;
            newOrder.Status = 'Draft';
            newOrder.EffectiveDate = Date.today();
            newOrder.Pricebook2Id = standardPricebook.Id;
            newOrder.EndDate = Date.today().addDays(2);      
        insert newOrder;

        OrderItem orderItem = new OrderItem();
            orderItem.Product2Id = prod.Id;
            orderItem.OrderId = newOrder.Id;
            orderItem.Quantity = 1;
            orderItem.UnitPrice = standardPrice.UnitPrice;
            orderItem.PricebookEntryId = standardPrice.Id;
            orderItem.ServiceDate = Date.today();
            orderItem.endDate = Date.today();
        insert orderItem;
        
        Case caseTest = new Case();
        caseTest.AccountId = acc.Id;
        caseTest.Comments = 'comm';
        caseTest.Order_Number__c = '123';
        insert caseTest;

        List<PricebookEntry> standardPriceList = [SELECT Id FROM PricebookEntry LIMIT 2];

        ProductWithPriceWrapper minWrap = new ProductWithPriceWrapper();
        minWrap.product = prod;
        minWrap.productStandardPrice = standardPrice;
        minWrap.productDiscountPrice = standardPriceList;
        
        ComunityAvenirHouseOrder.OrderWrapper wrap = new ComunityAvenirHouseOrder.OrderWrapper();
        wrap.prod = minWrap;
        wrap.startDate = Date.today();
        wrap.endDate = Date.today();
        wrap.cost = 150;
    }

    @IsTest
    public static void shouldSearchAccount(){
        Account acc = ComunityAvenirHouseOrder.searchAccount();
    }

    @IsTest
    public static void shouldOrderItemList(){
        List<OrderItem> itemList = ComunityAvenirHouseOrder.orderItemList([SELECT Id from Order LIMIT 1].Id);
    }

    @IsTest
    public static void shouldItemAvailable(){
        List<OrderItem> itemList = ComunityAvenirHouseOrder.itemAvailable();
    }

    @IsTest
    public static void shouldOrderItemListProduct(){
        List<String> listStr = new List<String>();
        List<Product2> prodId = [SELECT Id FROM Product2 LIMIT 1];
        for(Product2 item : prodId){
            listStr.add(item.Id);
        }
        List<OrderItem> itemList = ComunityAvenirHouseOrder.orderItemListProduct(listStr);
    }

    @IsTest
    public static void shouldGetOrder(){
        Order order = [SELECT Id, OwnerId From Order LIMIT 1];
        ComunityAvenirHouseOrder.getOrder(order.OwnerId);
    }

    @IsTest
    public static void shouldGetComplainList(){
        ComunityAvenirHouseOrder.getComplainList('0057Q000003AkIXQA0', '123');
    }

    @IsTest
    public static void shouldCreateOrder(){
        Product2 prod = [SELECT Id, Name, Family, Description, ProductCode, Country__c, City__c
        FROM Product2 LIMIT 1];
        List<PricebookEntry> standardPriceList = [SELECT Id, Pricebook2Id FROM PricebookEntry LIMIT 2];

        ProductWithPriceWrapper minWrap = new ProductWithPriceWrapper();
        minWrap.product = prod;
        minWrap.productStandardPrice = standardPriceList[0];
        minWrap.productDiscountPrice = standardPriceList;
        
        ComunityAvenirHouseOrder.OrderWrapper wrap = new ComunityAvenirHouseOrder.OrderWrapper();
        wrap.prod = minWrap;
        wrap.startDate = Date.today();
        wrap.endDate = Date.today();
        wrap.cost = 150;

        List<ComunityAvenirHouseOrder.OrderWrapper> wrapperList = new List<ComunityAvenirHouseOrder.OrderWrapper>();
        wrapperList.add(wrap);

        ComunityAvenirHouseOrder.createOrder(wrapperList);
    }

    @IsTest
    public static void shouldAddOrderItem(){
        Product2 prod = [SELECT Id, Name, Family, Description, ProductCode, Country__c, City__c
        FROM Product2 LIMIT 1];
        List<PricebookEntry> standardPriceList = [SELECT Id, Pricebook2Id FROM PricebookEntry LIMIT 2];

        ProductWithPriceWrapper minWrap = new ProductWithPriceWrapper();
        minWrap.product = prod;
        minWrap.productStandardPrice = standardPriceList[0];
        minWrap.productDiscountPrice = standardPriceList;

        ComunityAvenirHouseOrder.OrderWrapper wrap = new ComunityAvenirHouseOrder.OrderWrapper();
        wrap.prod = minWrap;
        wrap.startDate = Date.today();
        wrap.endDate = Date.today().addDays(1);
        wrap.cost = 150;
        

        List<ComunityAvenirHouseOrder.OrderWrapper> wrapperList = new List<ComunityAvenirHouseOrder.OrderWrapper>();
        wrapperList.add(wrap);
        Order orderId = [SELECT Id FROM Order LIMIT 1];
        ComunityAvenirHouseOrder.addOrderItem(orderId.Id, wrapperList);
    }

}