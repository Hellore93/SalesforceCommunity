/**
 * Created by 48781 on 03.06.2022.
 */

public with sharing class Aura_AccountSearch_Controller {

    @AuraEnabled
    public static List<Account> getAccounts() {

        List<Account> account =
        [SELECT Id, Name, AccountNumber, BillingStreet, BillingCity, BillingCountry FROM Account LIMIT 100];
        return account;
    }

    @AuraEnabled
    public static List<Account> getAccountsByName(String accountName) {
        String accountNameSearch = '%' + accountName + '%';
        List<Account> account =
        [SELECT Id, Name, AccountNumber, BillingStreet, BillingCity, BillingCountry FROM Account WHERE Name LIKE :accountNameSearch LIMIT 100];
        return account;
    }

    @AuraEnabled
    public static Account deleteAccount(Account account) {
        delete account;
        return account;
    }
}