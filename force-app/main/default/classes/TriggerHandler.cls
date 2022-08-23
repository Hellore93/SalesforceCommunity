public interface TriggerHandler {
    void BeforeInsert(List<SObject> newRecord);
    void BeforeUpdate(Map<Id, SObject> newRecord, Map<Id, SObject> oldItems);
    void BeforeDelete(Map<Id, SObject> oldRecord);
    void AfterInsert(Map<Id, SObject> newRecord);
    void AfterUpdate(Map<Id, SObject> newRecord, Map<Id, SObject> oldRecord);
    void AfterDelete(Map<Id, SObject> oldRecord);
    void AfterUndelete(Map<Id, SObject> oldRecord);
    Boolean IsDisabled();
}