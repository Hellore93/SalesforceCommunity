@IsTest
public with sharing class AutocreatedRegHandler1657700749895Test {

    @TestSetup
    public static void testSetup() {
        Account ac = new Account(Name='Community Account');
        insert ac;

    }

    @isTest
    public static void shouldCreateAndUpdateUser() {
        AutocreatedRegHandler1657700749895 handler = new AutocreatedRegHandler1657700749895();
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast', 'testFirst testLast', 
        'testuse8888r@gmail.com', null, 'testuserlong', 'en_US', 
        'google', null, new Map<String, String>{'language' => 'en_US'});
        Profile prof = new Profile(Name = 'Customer Community User2');

    try { 
        User u = handler.createUser(null, sampleData);
        sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
                                    'testNewFirst testNewLast', 'testnewuser@gmail.com', null, 'testnewuserlong', 'en_US', 'google',
                                     null, new Map<String, String>{});
        handler.updateUser(null, null, sampleData);
        
    } catch(Exception e){}
    }

    @isTest
    public static void shouldCreateAndUpdateUser2() {
        AutocreatedRegHandler1657700749895 handler = new AutocreatedRegHandler1657700749895();
        Auth.UserData sampleData = new Auth.UserData('testId', null, 'testLast', 'testFirst testLast', 
        'testuse8888r@gmail.com', null, 'testuserlong', 'en_US', 
        'google', null, new Map<String, String>{'language' => 'en_US'});
        Profile prof = new Profile(Name = 'Customer Community User2');

    try { 
        User u = handler.createUser(null, sampleData);
        sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
                                    'testNewFirst testNewLast', 'testnewuser@gmail.com', null, 'testnewuserlong', 'en_US', 'google',
                                     null, new Map<String, String>{});
        handler.updateUser(null, null, sampleData);
        
    } catch(Exception e){}
    }

}