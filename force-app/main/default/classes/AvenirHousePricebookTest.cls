@IsTest
public with sharing class AvenirHousePricebookTest {

    @TestSetup
    public static void testSetup(){

        Pricebook2 standartPricebook = new Pricebook2(
            Id=Test.getStandardPricebookId(), 
            IsActive=true);
        update standartPricebook;

        Pricebook2 discountPricebook = new Pricebook2(
            Name= 'discountPrice',
            Description='Description',
            IsActive=true);
        insert discountPricebook;

        Product2 prod = new Product2(
            Name = 'Product test'
        );
        insert prod;

        PricebookEntry standartPrice = new PricebookEntry(
            UnitPrice=500,
            Product2Id=prod.Id, 
            Pricebook2Id=standartPricebook.Id, 
            IsActive=true
            );
        insert standartPrice;
    }

    @IsTest
    public static void shouldGetProductAndPrice(){
        Product2 prod = [SELECT Id FROM product2 LIMIT 1];
        AvenirHousePricebook.getProductAndPrice();
        Product2 prod2 = [SELECT Id FROM product2 LIMIT 1];
        System.assertEquals(prod, prod2);
    }

    @IsTest
    public static void shouldGetProductByName(){
        Boolean test = AvenirHousePricebook.getProductByName('discountPrice').size()>0;
        System.assertEquals(false, test);

    }
}