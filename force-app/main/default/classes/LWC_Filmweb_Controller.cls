/**
 * Created by 48781 on 07.06.2022.
 */

 public with sharing class LWC_Filmweb_Controller {

        public LWC_Filmweb_Controller(){}
    
        @AuraEnabled(cacheable=true)
        public static ApiWrapper getFilms(String filmName, Integer counter) {

        String titleContain = '%' + filmName.replace(' ', '+') + '%';

        List<newFilm__c> customArray =  [SELECT id, genres__c, original_title__c, overview__c, popularity__c,
        poster_path__c, release_date__c, budget__c, vote_average__c, vote_count__c FROM newFilm__c
        WHERE original_title__c LIKE :titleContain];    

        List<CustomFilm> customFilm = new List<CustomFilm>();
        for (newFilm__c item : customArray) {
            CustomFilm  customItem = new CustomFilm();
                customItem.id = item.id;
                // customItem.genre_ids = item.genres__c;
                customItem.original_title = item.original_title__c;
                customItem.overview = item.overview__c;
                customItem.popularity =  item.popularity__c;
                customItem.backdrop_path = item.poster_path__c;
                customItem.release_date = item.release_date__c;
                customItem.vote_average = item.vote_average__c;
                customItem.vote_count =  item.vote_count__c;
                customFilm.add(customItem);
        }   

            String endpoint = 'https://api.themoviedb.org/3/search/movie?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US&query=' +
                    filmName.replace(' ', '+') +
                    '&page=' +
                    counter +
                    '&include_adult=false';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            Http http = new Http();
            HttpResponse resp = http.send(req);

            ApiWrapper appiWrap = new ApiWrapper();
            appiWrap = (ApiWrapper)JSON.deserialize(resp.getBody(), ApiWrapper.class);
            if(counter == 1 ){
            appiWrap.results.addAll(customFilm);
            }
            return  appiWrap;
        }

        @AuraEnabled(cacheable=true)
        public static String sendToFront(String filmName, Integer counter){
            ApiWrapper remoteData = getFilms(filmName, counter);
       
            return JSON.serialize(remoteData);
        }

    @AuraEnabled(cacheable=true)
    public static String getUpcomingFilms(Integer counter) {
        String endpoint = 'https://api.themoviedb.org/3/movie/upcoming?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US&page='
        + counter;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        Http http = new Http();
        HttpResponse resp = http.send(req);

        return resp.getBody();
    }

    @AuraEnabled(cacheable=true)
        public static String getFilmInformation(String filmId) {
            if(filmId.length() == 18){
                newFilm__c customArray =  [SELECT id, genres__c, original_title__c, overview__c, popularity__c,
        poster_path__c, release_date__c, budget__c, vote_average__c, vote_count__c FROM newFilm__c
        WHERE id= :filmId];    
        
                ApiWrapperInformationObject appiWrap = new ApiWrapperInformationObject();
                appiWrap.id = customArray.id;
                appiWrap.genre_ids = customArray.genres__c;
                appiWrap.original_title = customArray.original_title__c;
                appiWrap.overview = customArray.overview__c;
                appiWrap.popularity =  customArray.popularity__c;
                appiWrap.poster_path = customArray.poster_path__c;
                appiWrap.release_date = customArray.release_date__c;
                appiWrap.vote_average = customArray.vote_average__c;
                appiWrap.vote_count =  customArray.vote_count__c;
                appiWrap.budget = customArray.budget__c;
                return JSON.serialize(appiWrap);


            } else if ( filmId != '0'){
            String endpoint = 'https://api.themoviedb.org/3/movie/' +
                    filmId +
                    '?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            Http http = new Http();
            HttpResponse resp = http.send(req);  
            
            ApiWrapperInformationObject appiWrap = new ApiWrapperInformationObject();
            appiWrap = (ApiWrapperInformationObject)JSON.deserialize(resp.getBody(), ApiWrapperInformationObject.class);
            return JSON.serialize(appiWrap);
            }
            return null;
        }

        @AuraEnabled(cacheable=true)
        public static String getFilmCast(String filmId) {
            String endpoint = 'https://api.themoviedb.org/3/movie/' +
            filmId +
            '/credits?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            Http http = new Http();
            HttpResponse resp = http.send(req);        
            return resp.getBody();
        }

        @AuraEnabled(cacheable=true)
        public static List<Movie_Film_Rating__c> getBlacklist(){
 
            List<Movie_Film_Rating__c> blackList = [SELECT Id, movieIds__c, unfavourite__c FROM Movie_Film_Rating__c
            WHERE unfavourite__c = true];

            System.debug(blackList);
        
            return blackList;
        }

        @AuraEnabled(cacheable=true)
        public static List<Movie_Actor_Rating__c> getBlacklistActor(){
 
            List<Movie_Actor_Rating__c> blackList = [SELECT Id, actorId__c, unfavourite__c FROM Movie_Actor_Rating__c
            WHERE unfavourite__c = true];
        
            return blackList;
        }        

        @AuraEnabled(cacheable=true)
        public static ApiWrapperActor getActor(String actorName, Integer counter) {

            String nameContain = '%' + actorName.replace(' ', '+') + '%';

        List<newActor__c> customArray =  [SELECT id, biography__c, birthday__c, deathday__c, gender__c,
        name__c, newFilm__c, place_of_birth__c, popularity__c, profile_path__c  FROM newActor__c
        WHERE Name LIKE :nameContain];

        List<CustomActor> customActor = new List<CustomActor>();
        for (newActor__c item : customArray) {
            CustomActor customItem = new CustomActor();
                customItem.id = item.id;
                // customItem.genre_ids = item.genres__c;
                customItem.birthday = item.birthday__c;
                customItem.gender = item.gender__c;
                customItem.name =  item.name__c;
                customItem.place_of_birth = item.place_of_birth__c;
                customItem.popularity = item.popularity__c;
                customItem.profile_path = item.profile_path__c;
                customItem.biography = item.biography__c;
                customActor.add(customItem);
        }

            String endpoint = 'https://api.themoviedb.org/3/search/person?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US&query=' +
            actorName.replace(' ', '+') +
                    '&page=' + 
                    counter +
                    '&include_adult=false';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            Http http = new Http();
            HttpResponse resp = http.send(req);

            ApiWrapperActor appiWrap = new ApiWrapperActor();
            appiWrap = (ApiWrapperActor)JSON.deserialize(resp.getBody(), ApiWrapperActor.class);
            if(counter == 1 ){
            appiWrap.results.addAll(customActor);
            }
            return appiWrap;
        }

        @AuraEnabled(cacheable=true)
        public static String sendToFrontActor(String actorName, Integer counter){
            ApiWrapperActor remoteData = getActor(actorName, counter);
            System.debug(remoteData);
            return JSON.serialize(remoteData);
        }

        // @AuraEnabled(cacheable=true)
        // public static String getActorById(String actorId) {
        //     String endpoint = 'https://api.themoviedb.org/3/person/' +
        //     actorId +
        //     '?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US';
        //     HttpRequest req = new HttpRequest();
        //     req.setEndpoint(endpoint);
        //     req.setMethod('GET');
        //     req.setHeader('Content-Type', 'application/json');
        //     req.setHeader('accept', 'application/json');
        //     Http http = new Http();
        //     HttpResponse resp = http.send(req);
        //     return resp.getBody();
        // }

        @AuraEnabled(cacheable=true)
        public static String getActorById(String actorId) {

            if(actorId.length() == 18){
                newActor__c customArray =  [SELECT id, biography__c, birthday__c, deathday__c, gender__c,
                name__c, newFilm__c, place_of_birth__c, popularity__c, profile_path__c  FROM newActor__c
                WHERE Id = :actorId];    
        
        ApiWrapperActorInformationObject appiWrap = new ApiWrapperActorInformationObject();
                appiWrap.id = customArray.id;
                appiWrap.biography = customArray.biography__c;
                appiWrap.birthday = customArray.birthday__c;
                appiWrap.deathday = customArray.deathday__c;
                appiWrap.gender =  customArray.gender__c;
                appiWrap.name = customArray.name__c;
                appiWrap.newFilm = customArray.newFilm__c;
                appiWrap.place_of_birth = customArray.place_of_birth__c;
                appiWrap.popularity =  customArray.popularity__c;
                appiWrap.profile_path = customArray.profile_path__c;
                return JSON.serialize(appiWrap);


            } else if ( actorId != '0'){
            String endpoint = 'https://api.themoviedb.org/3/person/' +
            actorId +
            '?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            Http http = new Http();
            HttpResponse resp = http.send(req);

            ApiWrapperActorInformationObject appiWrap = new ApiWrapperActorInformationObject();
            appiWrap = (ApiWrapperActorInformationObject)JSON.deserialize(resp.getBody(), ApiWrapperActorInformationObject.class);
            return JSON.serialize(appiWrap);
            }
            return null;
        }

        @AuraEnabled(cacheable=true)
        public static String getActorFilms(String actorId) {
            String endpoint = 'https://api.themoviedb.org/3/person/' +
            actorId +
            '/combined_credits?api_key=ca15f0e732a7a8f7e3a678b559e2e6da&language=en-US';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            Http http = new Http();
            HttpResponse resp = http.send(req);
            return resp.getBody();
        }

        public class CustomFilm {
            @AuraEnabled
            public String id;
            // public List<Integer> genre_ids;
            @AuraEnabled
            public String original_title ;
            @AuraEnabled
            public String overview;
            @AuraEnabled
            public Decimal popularity;
            @AuraEnabled
            public String backdrop_path;
            @AuraEnabled
            public String release_date;
            @AuraEnabled
            public Decimal vote_average;
            @AuraEnabled
            public Decimal vote_count;
        }

        public class CustomActor {
            @AuraEnabled
            public String id;
            @AuraEnabled
            public String birthday ;
            @AuraEnabled
            public String gender;
            @AuraEnabled
            public String name;
            @AuraEnabled
            public String place_of_birth;
            @AuraEnabled
            public Decimal popularity;
            @AuraEnabled
            public String profile_path;
            @AuraEnabled
            public String biography;
        }

        public class CustomerActorFilms {

        }

        public class ApiWrapper {
            public Integer page;
            public Integer total_pages;
            public List<CustomFilm> results;
        }

        public class ApiWrapperActor {
            public Integer page;
            public Integer total_pages;
            public List<CustomActor> results;
        }

        public class ApiActorFilms {
            public List<CustomerActorFilms> castFilms;
        }

        public class ApiWrapperInformationObject {
            public String id;
            public String genre_ids ;
            public String original_title;
            public String overview;
            public Decimal popularity; 
            public String poster_path ;
            public String release_date ;
            public Decimal vote_average ;
            public Decimal vote_count ;
            public Decimal budget;
        }

        public class ApiWrapperActorInformationObject {            
            public String id;
            public String birthday ;
            public String deathday;
            public String gender;
            public String name;
            public String place_of_birth;
            public Decimal popularity;
            public String profile_path;
            public String biography;
            public String newFilm;
        }
}