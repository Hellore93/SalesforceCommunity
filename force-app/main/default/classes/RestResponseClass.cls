public with sharing class RestResponseClass {

    private static final String endpoint = 'callout:Doctor_Search/services/apexrest/searchHospital/';

    public static HttpResponse getMethodTest() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse resp = http.send(req);
        return resp;
    }

    public static HttpResponse postMethodTest(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
         req.setMethod('POST');
        Http http = new Http();
        HTTPResponse resp = http.send(req);
        return resp;
    }

    public static HttpResponse patchMetodTest(){
        HttpRequest reqEdit = new HttpRequest();
        reqEdit.setEndpoint(endpoint);
        reqEdit.setHeader('Content-Type', 'application/json');
        reqEdit.setHeader('accept', 'application/json');
        reqEdit.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        reqEdit.setMethod('PATCH');
        Http httpEdit = new Http();
        HTTPResponse respEdit = httpEdit.send(reqEdit);
        return respEdit;
    }

    public static HttpResponse deleteMetchodTest(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('DELETE');
        Http http = new Http();
        HTTPResponse respDelete = http.send(req);
        return respDelete;
    }

    public static HttpResponse putMetchodTest(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('PUT');
        Http http = new Http();
        HTTPResponse respPut = http.send(req);
        return respPut;
    }
}