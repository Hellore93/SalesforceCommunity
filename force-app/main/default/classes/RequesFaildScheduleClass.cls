/**
 * Created by 48781 on 28.05.2022.
 */

public with sharing class RequesFaildScheduleClass implements Schedulable {

    public void execute(SchedulableContext param1) {
        HospitalLogSendRequestBatch run = new HospitalLogSendRequestBatch();
        database.executeBatch(run);
    }
}