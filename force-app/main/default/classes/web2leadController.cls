public with sharing class web2leadController {

    public static String form {get; set;}
    public static String information {get; set;}

    public web2leadController() {
        form = 'form';
        information = 'hidden';
        submitAction();
    }

    public static void submitAction(){
        // System.debug('Test');
        // System.debug(System.currentPageReference().getParameters().get('success'));
        if(Apexpages.currentPage().getParameters().get('success') == 'true'){
            form = 'hidden';
            information = 'displayClass';
        } 
    }
}