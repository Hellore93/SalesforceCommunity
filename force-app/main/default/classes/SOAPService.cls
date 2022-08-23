global class SOAPService {

    global class DoctorDTO {
        webService String drID;
        webService String lastName;
        webService String firstName;
        webService String specialty;
        webService String country;
        webService String phone;
        webService String emailAdr;

        global DoctorDTO(Doctor__c doctor) {
            this.drID = doctor.Id;
            this.lastName = doctor.Name;
            this.firstName = doctor.Doctor_Name__c;
            this.specialty = doctor.Speciality__c;
            this.country = doctor.Country__c;
            this.phone = doctor.Phone_number__c;
            this.emailAdr = doctor.Email__c;
        }
    }

    global class messageWrapper {
        webService List<DoctorDTO> doctorList;
        webService DoctorDTO newAddingDoctor;
        webService String message;

        public messageWrapper(List<DoctorDTO> docList) {
            if (docList.size() > 0) {
                doctorList = docList;
            } else {
                message = 'No record found';
            }
        }

        public messageWrapper(Boolean isSuccess, DoctorDTO newDoctor) {
            if (isSuccess = true) {
                newAddingDoctor = newDoctor;
            } else if (isSuccess = false) {
                message = 'You cannot adding that doctor';
            }
        }

        public messageWrapper(String editMessage, DoctorDTO docToEdit) {
            if (editMessage == null) {
                newAddingDoctor = docToEdit;
            } else {
                message = editMessage;
            }
        }

        public messageWrapper(String deleteMessage, String docId) {

            if (deleteMessage.length() > 0) {
                message = 'You cannot delete doctor';
            } else {
                message = 'You delete doctor with Id=' + docId;
            }
        }
    }

    webservice static messageWrapper getRecord(String doctorLastName, String doctorName, String doctorCountry) {
        String query;
        List<Doctor__c> doctor = new List<Doctor__c>();
        List<String> fieldContract = new List<String>(Schema.getGlobalDescribe().get('Doctor__c').getDescribe().fields.getMap().keySet());

        if (String.isNotBlank(doctorLastName)) {
            query = 'SELECT ' + String.join(fieldContract, ',') + ' FROM Doctor__c WHERE Name LIKE \'%' + doctorLastName + '%\' ';
        }
        if (string.isNotBlank(doctorName)) {
            query += ' AND Doctor_Name__c LIKE \'%' + doctorName + '%\' ';
        }
        if (String.isNotBlank(doctorCountry)) {
            query += ' AND Country__c LIKE \'%' + doctorCountry + '%\' ';
        }


        if (query != null) {
            doctor = Database.query(query);
        } else {
            doctor = new List<Doctor__c>();
        }
        List<DoctorDTO> doctorsToDto = new List<DoctorDTO>();
        for(Doctor__c item : doctor){
            DoctorDTO doctorDTOcast = new DoctorDTO(item);
            doctorsToDto.add(doctorDTOcast);
        }

        return new messageWrapper(doctorsToDto);

    }

    webService static messageWrapper saveNewDoctor(String doctorLastName, String doctorName, String doctorNumber,
            String doctorEmail, String doctorSpeciality, Date doctorDateOfBirth,
            String doctorNationality, String doctorCity, String doctorStreet) {

        Doctor__c newDoctor = new Doctor__c();
        Boolean isSuccess;

        newDoctor.Name = doctorLastName;
        newDoctor.Doctor_Name__c = doctorName;
        newDoctor.Phone_number__c = doctorNumber;
        newDoctor.Email__c = doctorEmail;
        newDoctor.Speciality__c = doctorSpeciality;
        newDoctor.DateBorn__c = doctorDateOfBirth;
        newDoctor.Country__c = doctorNationality;
        newDoctor.City__c = doctorCity;
        newDoctor.Street__c = doctorStreet;

        if (string.isNotBlank(newDoctor.Name)) {
            Database.SaveResult newDoctorToPush = Database.insert(newDoctor);
            isSuccess = newDoctorToPush.isSuccess();
        } else {
            newDoctor = new Doctor__c();
            isSuccess = false;
        }
        DoctorDTO newDoctorDTO = new DoctorDTO(newDoctor);
        return new messageWrapper(isSuccess, newDoctorDTO);
    }

    webService static messageWrapper editExistDoctor(String docId, String doctorLastName, String doctorName, String doctorNumber,
            String doctorEmail, String doctorSpeciality, Date doctorDateOfBirth,
            String doctorNationality, String doctorCity, String doctorStreet) {

        Doctor__c docToEdit = new Doctor__c();
        String editMessage;
        try {
            docToEdit = [
                    SELECT Name, Doctor_Name__c, Phone_number__c, Email__c, Speciality__c, DateBorn__c, Country__c, City__c, Street__c
                    FROM Doctor__c
                    WHERE Id = :docId
                    LIMIT 1
            ];
        } catch (Exception e) {
            editMessage = e.getMessage();
        }

        docToEdit.Name = doctorLastName;
        docToEdit.Doctor_Name__c = doctorName;
        docToEdit.Phone_number__c = doctorNumber;
        docToEdit.Email__c = doctorEmail;
        docToEdit.Speciality__c = doctorSpeciality;
        docToEdit.DateBorn__c = (Date) doctorDateOfBirth;
        docToEdit.Country__c = doctorNationality;
        docToEdit.City__c = doctorCity;
        docToEdit.Street__c = doctorStreet;

        try {
            Database.SaveResult item = Database.update(docToEdit);

        } catch (Exception e) {
            editMessage += e.getMessage();
        }

        DoctorDTO docToEditDTO = new DoctorDTO(docToEdit);
        return new messageWrapper(editMessage, docToEditDTO);
    }

    webService static messageWrapper deleteExistDoctor(String docId) {
        Doctor__c query = new Doctor__c();
        String deleteMessage = '';

        try {
            query = [SELECT Id, Name FROM Doctor__c WHERE Id = :docId];
        } catch (Exception e) {
            deleteMessage = e.getMessage();
        }
        if (!(deleteMessage.length()>0)) {
            Database.delete(query);
        }else{
            deleteMessage += ' Your Id is invalid';
        }

        return new messageWrapper(deleteMessage, docId);
    }

}