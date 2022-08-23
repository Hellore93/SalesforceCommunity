global with sharing class schedulePromotions implements Schedulable{

    global void execute(SchedulableContext param1) {
        AvenirHousePricebookBatch scs = new AvenirHousePricebookBatch();
        Database.executeBatch(scs);
    }
}