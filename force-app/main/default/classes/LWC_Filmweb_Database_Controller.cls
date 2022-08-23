public with sharing class LWC_Filmweb_Database_Controller {
    public LWC_Filmweb_Database_Controller() {}

    @AuraEnabled(cacheable=true)
    public static List<Movie_Films__c> getMovieCommentary(String filmId){
        return [SELECT movieId__c, Name, Commentary__c, 
        favourite__c,  CreatedById, Creator__c,CreateData__c
         FROM Movie_Films__c WHERE movieId__c = :filmId
         ORDER BY CreateData__c ASC LIMIT 100];        
    }

    @AuraEnabled(cacheable=true)
    public static Movie_Film_Rating__c getMovieRating(String OwnerId, String filmId){
        return [SELECT favourite__c, movieIds__c, OwnerId, Rating__c, unfavourite__c
        FROM Movie_Film_Rating__c WHERE OwnerId= :OwnerId AND movieIds__c= :filmId
         LIMIT 1];        
    }

    @AuraEnabled(cacheable=true)
    public static Movie_Actor_Rating__c getActorRating(String OwnerId, String actorId){
        return [SELECT favourite__c, actorId__c, OwnerId, Rating__c, unfavourite__c
        FROM Movie_Actor_Rating__c WHERE OwnerId= :OwnerId AND actorId__c= :actorId
         LIMIT 1];        
    }

    @AuraEnabled(cacheable=true)
    public static List<Movie_Actor__c> getActorCommentary(String actorId){
        return [SELECT actorId__c, Name, Commentary__c, 
         CreatedById, Creator__c, CreateData__c
         FROM Movie_Actor__c WHERE actorId__c = :actorId
         LIMIT 100];        
    }
}