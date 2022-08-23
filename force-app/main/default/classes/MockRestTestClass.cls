/**
 * Created by 48781 on 23.05.2022.
 */

@IsTest
private class MockRestTestClass {

    @IsTest
    static void getMethodTest() {
        Test.setMock(HttpCalloutMock.class, new MockRestWebCallount(MockRestWebCallount.getMethod));

        HttpResponse res = RestResponseClass.getMethodTest();
        System.assertEquals(200, res.getStatusCode());
    }

    @IsTest
    static void postMethodTest() {
        Test.setMock(HttpCalloutMock.class, new MockRestWebCallount(MockRestWebCallount.postMethod));

        HttpResponse res = RestResponseClass.postMethodTest();
        String expectedValue = '{"hospitalName" : "hospital Sopot"}';
        String actualValue = res.getBody();
        System.assertEquals(actualValue, expectedValue);
    }

    @IsTest
    static void patchMethodTest() {
        Test.setMock(HttpCalloutMock.class, new MockRestWebCallount(MockRestWebCallount.patchMethod));

        HttpResponse res = RestResponseClass.patchMetodTest();
        String actualValue = res.getBody();
        String expectedValue = '{"hospitalName" : "hospital Sopot Na Molo"}';
        System.assertEquals(actualValue, expectedValue);
    }

    @IsTest
    static void deleteMethodTest() {
        Test.setMock(HttpCalloutMock.class, new MockRestWebCallount(MockRestWebCallount.deleteMethod));

        HttpResponse res = RestResponseClass.deleteMetchodTest();
        String actualValue = res.getBody();
        String expectedValue = '{"hospitalName" : "hospital Sopot Na Molo"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

    @IsTest
    static void putMethodTest() {
        Test.setMock(HttpCalloutMock.class, new MockRestWebCallount(MockRestWebCallount.putMethod));

        HttpResponse res = RestResponseClass.putMetchodTest();
        String actualValue = res.getBody();
        String expectedValue = '["Poland", "Usa"]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
}