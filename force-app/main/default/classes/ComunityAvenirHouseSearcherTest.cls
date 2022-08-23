@IsTest
public with sharing class ComunityAvenirHouseSearcherTest {

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
    public static void shouldGetProductFamily(){
        ComunityAvenirHouseSearcher.getProductFamily();
    }

    @IsTest
    public static void shouldSearchHomeByName(){
        ComunityAvenirHouseSearcher.searchHomeByName('testProd');
    }

    @IsTest
    public static void shouldGetExtraOpion(){
        ComunityAvenirHouseSearcher.getExtraOpion();
    }

    @IsTest
    public static void shouldGetStandardPriceList(){
        ComunityAvenirHouseSearcher.getStandardPriceList();
    }

    @IsTest
    public static void shouldGetDiscountPriceList(){
        ComunityAvenirHouseSearcher.getDiscountPriceList();
    }

    @IsTest
    public static void shouldGetProductPhotoGallery(){
        Product2 prod = [SELECT Id, Name FROM Product2 LIMIT 1];
        ComunityAvenirHouseSearcher.getProductPhotoGallery(prod.Id);
        ComunityAvenirHouseSearcher.getProductById(prod.Id);
        ComunityAvenirHouseSearcher.startSearch(prod.Name);
        ComunityAvenirHouseSearcher.getProductDescription(prod.Id);
    }

    @IsTest
    public static void shouldSaveNewCommentary(){
        Product2 prod = [Select Id FROM Product2 LIMIT 1];
        ComunityAvenirHouseSearcher.saveNewCommentary('', 'Comment', 5, prod.Id);
    }

    @IsTest
    public static void shouldGetCommentList(){
        Product2 prod = [Select Id FROM Product2 LIMIT 1];
        ComunityAvenirHouseSearcher.getCommentList(prod.Id);
    }
    
}