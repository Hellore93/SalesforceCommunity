/**
 * Created by 48781 on 27.05.2022.
 */

public with sharing class LogsPageController {
    public static Log__c record ;

    public static void createLog(HttpRequest req, HttpResponse resp, string objId) {
        record = LogsPageController.getBuilder()
                .setCreatedDate(Date.today())
                .setHttpMethod(req.getMethod())
                .setRequestBody(req.getBody())
                .setResponseBody(resp.getBody())
                .setStatusCode(resp.getStatusCode())
                .setLogId(objId)
                .save()
                .getRecord();

        if (record.Status_Code__c != 200) {
            Hospital__c updateCounterRequestField = [
                    SELECT Id, FailRequestNumber__c, TriggerProcess__c
                    FROM Hospital__c
                    WHERE Id = :objId
            ];
            updateCounterRequestField.TriggerProcess__c = true;
            updateCounterRequestField.FailRequestNumber__c = 1;
            update updateCounterRequestField;
        }

    }

    public static Builder getBuilder() {
        return new Builder();
    }

    public class Builder {
        public Log__c record;

        public Builder() {
            record = new Log__c();
        }

        public Builder setLogId(String objectId) {
            record.ObjectId__c = objectId;
            return this;
        }

        public Builder setCreatedDate(Date createDate) {
            record.Create_Data__c = createDate;
            return this;
        }

        public Builder setHttpMethod(String httpMethod) {
            record.Http_Method__c = httpMethod;
            return this;
        }

        public Builder setRequestBody(String requestBody) {
            record.Request_Body__c = requestBody;
            return this;
        }

        public Builder setResponseBody(String responseBody) {
            record.Response_Body__c = responseBody;
            return this;
        }

        public Builder setStatusCode(Integer statusCode) {
            record.Status_Code__c = statusCode;
            return this;
        }

        public Builder save() {
            insert (SObject) record;
            return this;
        }

        public Log__c getRecord() {
            return record;
        }
    }

}