/**
 * Created by 48781 on 15.05.2022.
 */

public with sharing class DoctorSearchSoapController {

    public static soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService dominikSoap { get; set; }
    public List<DoctorWrapper> sDoctors { get; set; }
    public Doctor__c doc { get; set; }
    public Boolean isRecordExist { get; set; }
    public String messageSoap { get; set; }
    public String doctorToDeleteEdit { get; set; }
    public Doctor__c doctorToInsert { get; set; }
    public Boolean addNewDoctorRender { get; set; }
    public String doctorToEditId { get; set; }
    public Doctor__c existDoctor { get; set; }
    public String modalClass { get; set; }
    public String messageToastVisible { get; set; }
    public String messageToastContext { get; set; }
    public String modalHeader { get; set; }
    public String messageTheme { get; set; }
    public Boolean isCancelDisable { get; set; }
    public Boolean deleteModal { get; set; }

    public DoctorSearchSoapController() {
        doc = new Doctor__c();
        isRecordExist = false;
        addNewDoctorRender = false;
        messageSoap = '';
        doctorToDeleteEdit = '';
        doctorToInsert = new Doctor__c();
        existDoctor = new Doctor__c();
        modalClass = 'hidden';
        doctorToEditId = '';
        messageToastVisible = 'hidden';
        messageToastContext = '';
        modalHeader = '';
        messageTheme = 'slds-theme_success';
        isCancelDisable = false;
        deleteModal = false;
    }

    public void showModal() {
        modalClass = 'new';
        existDoctor = new Doctor__c();
        modalHeader = (String) System.Label.New;
        messageTheme = 'slds-theme_success';
        isCancelDisable = false;
    }

    public void closeModal() {
        existDoctor = new Doctor__c();
        modalClass = 'hidden';
        getDoc();
    }

    public void showDeleteModal() {
        deleteModal = true;
    }

    public soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService soapConnect() {
        partnerSoapSforceCom.Soap mypartnersoap = new partnerSoapSforceCom.Soap();

        partnerSoapSforceCom.LoginResult partnerloginresult = mypartnersoap.login('d.barchanski@icloud.com', 'zaq1@WSXXsArQxBZeCbv99UzRmzKTc7wt');

        string sessionidfetch = partnerloginresult.sessionId;

        soapSforceComSchemasClassDoctorsear.SessionHeader_element webservicesessionheader = new soapSforceComSchemasClassDoctorsear.SessionHeader_element();

        webservicesessionheader.sessionId = sessionidfetch;
        dominikSoap = new soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService();
        dominikSoap.SessionHeader = webservicesessionheader;
        return dominikSoap;
    }

    public PageReference getDoc() {
        soapConnect();
        messageTheme = 'slds-theme_success';
        sDoctors = new List<DoctorWrapper>();
        if (String.isBlank(doc.Name)) {
            isRecordExist = false;
        }

        soapSforceComSchemasClassDoctorsear.ReturnClass messageWrapper = dominikSoap.searchDoctor(doc.Name, doc.Doctor_Name__c, doc.Country__c);
        List<soapSforceComSchemasClassDoctorsear.DoctorDTO> dDoc = messageWrapper.listOfDoctor;
        messageSoap = messageWrapper.message;

        if (String.isBlank(messageSoap)) {
            isRecordExist = true;
            for (soapSforceComSchemasClassDoctorsear.DoctorDTO item : dDoc) {
                Doctor__c sDoctor = new Doctor__c();
                sDoctor.Doctor_Name__c = item.firstName;
                sDoctor.Name = item.lastName;
                sDoctor.Email__c = item.emailAddress;
                sDoctor.Phone_number__c = item.phone;
                sDoctor.Country__c = item.country;
                sDoctor.Speciality__c = item.specialty;
                DoctorWrapper docWrapper = new DoctorWrapper(sDoctor);
                docWrapper.doctorId = item.doctorId;
                sDoctors.add(docWrapper);
            }
        } else {
            isRecordExist = false;
        }
        return null;
    }

    public PageReference addNewDoctor() {
        soapConnect();
        if (String.isBlank(doctorToDeleteEdit)) {
            if (String.isNotBlank(existDoctor.Name)) {
                dominikSoap.createDoctor(existDoctor.Doctor_Name__c, existDoctor.Name, existDoctor.Speciality__c,
                        existDoctor.Phone_number__c, existDoctor.Email__c, existDoctor.DateBorn__c,
                        existDoctor.City__c, existDoctor.Country__c, existDoctor.Street__c);
                messageToastContext = 'Adding successful';
            } else {
                messageTheme = 'slds-theme_error';
                messageToastContext = 'New doctor must have last name';
                existDoctor = new Doctor__c();
                return null;
            }
        } else if (String.isNotBlank(doctorToDeleteEdit)) {
            if (String.isNotBlank(existDoctor.Name)) {
                dominikSoap.updateDoctor(doctorToDeleteEdit, existDoctor.Doctor_Name__c, existDoctor.Name,
                        existDoctor.Speciality__c, existDoctor.Phone_number__c, existDoctor.Email__c, existDoctor.DateBorn__c,
                        existDoctor.City__c, existDoctor.Country__c, existDoctor.Street__c);
                messageToastContext = 'Editing successful';
                doctorToDeleteEdit = '';
            } else {
                messageTheme = 'slds-theme_error';
                messageToastContext = 'Edit doctor must have last name';
                existDoctor.Name = null;
                isCancelDisable = true;
                return null;
            }
        }
        getDoc();
        modalClass = 'hidden';
        return null;
    }

    public PageReference deleteDoctor() {
        soapConnect();
        System.debug(dominikSoap.deleteDoctor(doctorToDeleteEdit));
        modalClass = 'hidden';
        getDoc();
        messageToastContext = 'Delete successful';
        doctorToDeleteEdit = '';
        deleteModal = false;
        return null;
    }

    public void editDoctor() {
        soapConnect();
        isCancelDisable = false;
        modalHeader = System.Label.Edit;
        modalClass = 'show';

        for (DoctorWrapper item : sDoctors) {
            if (item.doctorId == doctorToDeleteEdit) {
                existDoctor = item.doctor;
            }
        }
    }

    public class DoctorWrapper {
        public Doctor__c doctor { get; set; }
        public String doctorId { get; set; }

        public DoctorWrapper(Doctor__c docToView) {
            this.doctor = docToView;
        }
    }
}