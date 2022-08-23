@IsTest
global class MockRestWebCallount implements HttpCalloutMock {

    public String mode;
    public static String getMethod = 'getMethod';
    public static String postMethod = 'postMethod';
    public static String patchMethod = 'patchMethod';
    public static String deleteMethod = 'deleteMethod';
    public static String putMethod = 'putMethod';

    public MockRestWebCallount(String mockMode) {
        this.mode = mockMode;
    }

    global HttpResponse respond(HttpRequest request) {
        if (mode == getMethod) {

            System.assertEquals('callout:Doctor_Search/services/apexrest/searchHospital/', request.getEndpoint());
            System.assertEquals('GET', request.getMethod());

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('accept', 'application/json');
            res.setStatusCode(200);
            return res;

        } else if (mode == postMethod) {

            System.assertEquals('callout:Doctor_Search/services/apexrest/searchHospital/', request.getEndpoint());
            System.assertEquals('POST', request.getMethod());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"hospitalName" : "hospital Sopot"}');
            return res;

        } else if (mode == patchMethod) {

            System.assertEquals('callout:Doctor_Search/services/apexrest/searchHospital/', request.getEndpoint());
            System.assertEquals('PATCH', request.getMethod());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"hospitalName" : "hospital Sopot Na Molo"}');
            return res;

        } else if (mode == deleteMethod) {

            System.assertEquals('callout:Doctor_Search/services/apexrest/searchHospital/', request.getEndpoint());
            System.assertEquals('DELETE', request.getMethod());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"hospitalName" : "hospital Sopot Na Molo"}');
            return res;

        } else if (mode == putMethod) {

            System.assertEquals('callout:Doctor_Search/services/apexrest/searchHospital/', request.getEndpoint());
            System.assertEquals('PUT', request.getMethod());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('["Poland", "Usa"]');
            return res;

        }
        return null;
    }
}