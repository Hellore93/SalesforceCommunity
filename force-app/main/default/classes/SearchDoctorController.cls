public with sharing class SearchDoctorController {

    public List<Doctor__c> doctors { get; set; }
    public String query { get; set; }
    public Doctor__c doc { get; set; }
    public Boolean isVisible { get; set; }
    public Integer queryCount { get; set; }
    public List<Doctor__c> exportList { get; set; }
    public String fileId { get; set; }
    public Integer counter = 0;
    public Integer size = 5;
    public Integer lastPageNumber = 0;

    public SearchDoctorController() {
        doc = new Doctor__c();
        isVisible = false;
    }

    public PageReference search() {
        if (doc.Search_Counter__c != null) {
            size = Integer.valueOf(doc.Search_Counter__c) ;
        }

        query = 'SELECT Doctor_Name__c, Name, Country__c, Search_Counter__c FROM Doctor__c WHERE Name LIKE \'' + String.escapeSingleQuotes(doc.Name) + '%\' ' ;
        if (!(doc.Doctor_Name__c == null)) {
            query += ' AND Doctor_Name__c LIKE \'' + String.escapeSingleQuotes(doc.Doctor_Name__c) + '%\' ';
        }
        if (!(doc.Country__c == null)) {
            query += ' AND Country__c LIKE \'' + doc.Country__c + '\' ';
        }
        exportList = Database.query(query);
        queryCount = exportList.size();
        lastPageNumber = queryCount / size;

        if (queryCount > 0) {
            isVisible = true;
        } else {
            isVisible = false;
        }

        query += ' LIMIT ' + size + ' OFFSET ' + counter;

        runSearch();
        return null;
    }

    public void runSearch() {
        try {
            doctors = Database.query(query);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Something wrong'));
        }
    }

    public List<Doctor__c> clear() {
        size = 5 ;
        isVisible = false;
        queryCount = 0;
        counter = 0;
        doc.clear();
        return null;
    }

    public Integer getPageNumber() {
        return counter / size + 1;
    }

    public Integer getTotalPages() {
        if (Math.mod(queryCount, size) > 0) {
            return queryCount / size + 1;
        } else {
            return (queryCount / size);
        }
    }

    public Boolean getDisablePrevious() {
        return !(counter > 0);
    }

    public Boolean getDisableNext() {
        if (counter + size < queryCount) return false;
        else return true;
    }

    public Boolean getDisableExport() {
        return !(queryCount > 0);
    }

    public PageReference Beginning() {
        counter = 0;
        search();
        return null;
    }

    public PageReference Previous() {
        counter -= size;
        search();
        return null;
    }

    public PageReference Next() {
        counter += size;
        search();
        return null;
    }

    public PageReference End() {
        counter = queryCount - math.mod(queryCount, size);
        search();
        return null;
    }

    public void startSearch() {
        counter = 0;
        search();
    }

    public String getReportCSV() {
        String csv = 'First_Name,Last_Name,Country\n';
        for (Doctor__c items : exportList) {
            csv += (items.Doctor_Name__c == null ? '':items.Doctor_Name__c)
                    + ',' + (items.Name == null ? '' :items.Name)
                    + ',' + (items.Country__c == null ? '':items.Country__c) + '\n';
        }
        ContentVersion file = new ContentVersion(
                title = 'DoctorsBase.csv',
                versionData = Blob.valueOf(csv),
                pathOnClient = '/DoctorsBase.csv'

        );
        insert file;
        fileId = file.Id;
        return 'https://britenet93-dev-ed--c.documentforce.com/sfc/servlet.shepherd/version/download/' + fileId + '?asPdf=false&operationContext=CHATTER';
    }

    public String geReportXLS() {
        String xls = 'First_Name,Last_Name,Country\n';
        for (Doctor__c items : exportList) {
            xls += (items.Doctor_Name__c == null ? '':items.Doctor_Name__c)
                    + '\t' + (items.Name == null ? '' :items.Name)
                    + '\t' + (items.Country__c == null ? '':items.Country__c) + '\n';
        }
        ContentVersion file = new ContentVersion(
                title = 'DoctorsBase.xls',
                VersionData = Blob.valueOf(xls),
                pathOnClient = '/DoctorsBase.xls'
        );
        insert file;
        fileId = file.Id;
        return 'https://britenet93-dev-ed--c.documentforce.com/sfc/servlet.shepherd/version/download/' + fileId + '?asPdf=false&operationContext=CHATTER' ;
    }
}