trigger CreateContentDocumentLink on ContentDocumentLink  (after insert) {
    List <ContentDocumentLink> contenDocLinkToUpdate = new List<ContentDocumentLink>();
    String idOfRecord = '';
    for(ContentDocumentLink c: Trigger.New){
        System.debug(Trigger.New);
        idOfRecord = c.Id;
    }
    List <ContentDocumentLink> contDocLink = [SELECT  Id, ShareType, Visibility FROM ContentDocumentLink WHERE Id =:idOfRecord];
    System.debug(contDocLink);
        
    for(ContentDocumentLink content: contDocLink){
        System.debug(content.Id);
        // content.ContentDocumentId = content.ContentDocumentId;
        content.ShareType = 'V';
        content.Visibility = 'AllUsers';
        contenDocLinkToUpdate.add(content);
    }
    System.debug(contenDocLinkToUpdate);
    update contenDocLinkToUpdate; 
}