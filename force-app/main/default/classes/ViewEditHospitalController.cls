public with sharing class ViewEditHospitalController {
    public Hospital__c query { get; set; }
    public String hospitalId { get; set; }
    public List<Contract__c> queryContract { get; set; }

    public ViewEditHospitalController(ApexPages.StandardController controller) {
        List<String> field = new List<String>(Schema.getGlobalDescribe().get('Hospital__c').getDescribe().fields.getMap().keySet());
        hospitalId = ApexPages.currentPage().getParameters().get('id');
        if (hospitalId != null) {
            query = Database.query('SELECT ' + String.join(field, ',') + ' FROM Hospital__c WHERE Id = :hospitalId LIMIT 1');
            List<String> fieldContract = new List<String>(Schema.getGlobalDescribe().get('Contract__c').getDescribe().fields.getMap().keySet());
            queryContract = Database.query('SELECT ' + String.join(fieldContract, ',') + ' FROM Contract__c WHERE Hospital__c =:hospitalId LIMIT 20');
        } else {
            query = new Hospital__c();
        }
    }

    public PageReference save() {
        try {
            if (query.Id != null) {
                query.TriggerProcess__c = false;
//                System.debug('edytowany obiekt w view ' + query);
                update query;
            } else {
//                System.debug('Rafał tworzy swój obiekt ' + query);
                query.TriggerProcess__c = false;
                insert query;
            }
            String pageUrl = '/apex/HospitalView?Id=' + query.Id;
            PageReference result = new PageReference(pageUrl).setRedirect(true);
            return result;
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }

    public PageReference saveAndNew() {
        save();
        PageReference page = new PageReference('/apex/HospitalEdit').setRedirect(true);
        return page;
    }

    public void deleteHospital() {
        Hospital__c removeHospital = [SELECT Id, Name From Hospital__c WHERE Id = :hospitalId];
        if (removeHospital != null) {
            try {
                delete removeHospital;

            } catch (DmlException e) {
                ApexPages.addMessages(e);
            }
        }
    }
}