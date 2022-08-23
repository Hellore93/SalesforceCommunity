public with sharing class Aura_SearchFilms_Controller {
    public Aura_SearchFilms_Controller(){}

    @AuraEnabled
    public static String getFilms(String filmName) {

        String endpoint = 'https://api.themoviedb.org/3/search/movie?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US&query=' +
                filmName.replace(' ', '+') +
                '&page=1&include_adult=false';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        Http http = new Http();
        HttpResponse resp = http.send(req);
        return resp.getBody();
    }

    @AuraEnabled
    public static String getUpcomingFilms() {

        String endpoint = 'https://api.themoviedb.org/3/movie/upcoming?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US&page=1';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        Http http = new Http();
        HttpResponse resp = http.send(req);

        return resp.getBody();
    }

    @AuraEnabled
    public static String getFilmInformation(String urlParam) {
        System.debug(urlParam);

        String endpoint = 'https://api.themoviedb.org/3/movie/' +
                urlParam +
                '?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        Http http = new Http();
        HttpResponse resp = http.send(req);
        System.debug(resp.getBody());
        return resp.getBody();
    }

}