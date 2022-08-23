public with sharing class ComunityAvenirHouseOrder extends ProductWithPriceWrapper{
    public ComunityAvenirHouseOrder() {}

    @AuraEnabled(cacheable=true)
    public static Account searchAccount(){
        Account accountItem = [SELECT Id, Name, Type, First_Name__c, OwnerId FROM Account 
        where Name ='Community Account'];
        return accountItem;
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> orderItemList(String OrderId){
        List<OrderItem> itemList = [SELECT IsDeleted, UnitPrice, TotalPrice, ListPrice, 
        ServiceDate, EndDate, SystemModstamp, LastModifiedDate, CreatedDate, Id, Product2Id, 
        PricebookEntryId, OrderId, LastModifiedById, CreatedById, OrderItemNumber, Description, 
        Product2.Name, Product2.Country__c, Product2.DisplayUrl FROM OrderItem where OrderId =:OrderId];

        return itemList;
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> itemAvailable(){
        Date today = Date.today();
        List<OrderItem> itemList = [SELECT IsDeleted, UnitPrice, TotalPrice, ListPrice, 
        ServiceDate, EndDate, SystemModstamp, LastModifiedDate, CreatedDate, Id, Product2Id, 
        PricebookEntryId, OrderId, LastModifiedById, CreatedById, OrderItemNumber, Description, 
        Product2.Name, Product2.Country__c, Product2.Id FROM OrderItem where ServiceDate > today OR EndDate > today];
        return itemList;
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> orderItemListProduct(List<String> ProductId){
        Date today = Date.today();
        List<OrderItem> itemList = [SELECT IsDeleted, UnitPrice, TotalPrice, ListPrice, 
        ServiceDate, EndDate, SystemModstamp, LastModifiedDate, CreatedDate, Id, Product2Id, 
        PricebookEntryId, OrderId, LastModifiedById, CreatedById, OrderItemNumber, Description, 
        Product2.Name, Product2.Country__c, Product2.DisplayUrl FROM OrderItem where Product2Id IN :ProductId
        AND EndDate >= today];
        return itemList;
    }

    @AuraEnabled
    public static String getOrder(String userId){
        List<Order> itemList = [SELECT Id, OwnerId, ContractId, AccountId, Pricebook2Id, 
        EffectiveDate, EndDate, IsReductionOrder, Status, Description,StatusCode, OrderNumber, 
        TotalAmount, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, IsDeleted,
        SystemModstamp, LastViewedDate, LastReferencedDate FROM Order where OwnerId =:userId
        ORDER BY OrderNumber ASC];
        return JSON.serialize(itemList);
    }

    @AuraEnabled
    public static List<Case> getComplainList(String userId, String orderId){
        List<Case> userCase = [SELECT Id, IsDeleted, CaseNumber,  BusinessHoursId, ParentId, SuppliedEmail, SuppliedPhone, Type, 
        Status, Origin, Subject, Priority, Description, IsClosed, ClosedDate, IsEscalated, OwnerId, IsClosedOnCreate, IsStopped, 
        StopStartDate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, 
        Data_Quality_Description__c, Data_Quality_Score__c, Product_To_Case__c, Order_Number__c FROM Case 
        WHERE OwnerId = :userId AND Order_Number__c =:orderId];
        System.debug(userCase);
        return userCase;
    }

    @AuraEnabled
    public static Order createOrder(List<OrderWrapper> orderObject){
        System.debug(orderObject);
        Account acc = searchAccount();
        Order newOrder = new Order(
            AccountId = acc.Id,
            Status = 'Draft',
            EffectiveDate = orderObject[0].startDate.addDays(1),
            Pricebook2Id = orderObject[0].prod.productStandardPrice.Pricebook2Id,
            EndDate = orderObject[orderObject.size()-1].endDate.addDays(1)
        );
        try {
             insert newOrder;
        } catch (DmlException e) {
         System.debug(e);   
        }finally {
            addOrderItem(newOrder.Id, orderObject);
        }

        return newOrder;
    }

    @AuraEnabled
    public static void addOrderItem(String orderId, List<OrderWrapper> orderObject){

        List<OrderItem> orderItems = new List<OrderItem>();

        for (OrderWrapper item: orderObject){
            OrderItem orderItem = new OrderItem();
            System.debug(item.prod.productStandardPrice.Id);
            
            orderItem.Product2Id = item.prod.product.Id;
            orderItem.OrderId = orderId;
            orderItem.Quantity = 1;
            orderItem.UnitPrice = item.cost;
            orderItem.PricebookEntryId = item.prod.productStandardPrice.Id;
            orderItem.ServiceDate = item.startDate.addDays(1);
            orderItem.endDate = item.endDate.addDays(1);

            orderItems.add(orderItem);
        }
        insert orderItems;
    }

    public class OrderWrapper{
        @AuraEnabled
        public productWithPriceWrapper prod {get; set;}
        @AuraEnabled
        public Date startDate {get; set;}
        @AuraEnabled
        public Date endDate {get; set;}
        @AuraEnabled
        public Integer cost {get; set;}
    }
}