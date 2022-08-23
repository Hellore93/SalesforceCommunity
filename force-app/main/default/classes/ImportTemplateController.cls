/**
 * Created by 48781 on 04.05.2022.
 */

public with sharing class ImportTemplateController {
    public Doctor__c doctorsTemplate { get; set; }

    public ImportTemplateController() {

        doctorsTemplate = new Doctor__c();

        doctorsTemplate.Doctor_Name__c = 'Jan';
        doctorsTemplate.Name = 'Kowalski';
        doctorsTemplate.Phone_number__c = '3538454354';
        doctorsTemplate.Email__c = 'kowalski.jan@o2.pl';
        doctorsTemplate.Speciality__c = 'ABSC/2222/QWER';
        doctorsTemplate.DateBorn__c = date.newInstance(2022, 05, 15 );
        doctorsTemplate.City__c = 'Warsaw';
        doctorsTemplate.Street__c = 'Pierwsza';
        doctorsTemplate.Country__c = 'Poland';
    }

}