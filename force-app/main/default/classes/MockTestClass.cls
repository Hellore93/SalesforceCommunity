/**
 * Created by 48781 on 17.05.2022.
 */

@IsTest
global class MockTestClass implements WebServiceMock {

    public String mode;
    public static String seachDoctor = 'seachDoctor';
    public static String createDoctor = 'createDoctor';
    public static String editDoctor = 'editDoctor';
    public static String deleteDoctor = 'deleteDoctor';
    public static String getAll = 'getAll';

    public MockTestClass(String mockMode) {
        this.mode = mockMode;
    }

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        if (mode == seachDoctor) {
            soapSforceComSchemasClassDoctorsear.searchDoctorResponse_element addResponse =
                    new soapSforceComSchemasClassDoctorsear.searchDoctorResponse_element();
            addResponse.result = new soapSforceComSchemasClassDoctorsear.ReturnClass();
            addResponse.result.message = '0 record finded';
            response.put('response_x', addResponse);

        } else if (mode == createDoctor) {
            soapSforceComSchemasClassDoctorsear.createDoctorResponse_element addResponse =
                    new soapSforceComSchemasClassDoctorsear.createDoctorResponse_element();
            addResponse.result = new soapSforceComSchemasClassDoctorsear.ReturnClass();
            addResponse.result.message = 'Done';
            response.put('response_x', addResponse);

        }
        else if (mode == editDoctor) {
            soapSforceComSchemasClassDoctorsear.updateDoctorResponse_element addResponse =
                    new soapSforceComSchemasClassDoctorsear.updateDoctorResponse_element();
            addResponse.result = new soapSforceComSchemasClassDoctorsear.ReturnClass();
            addResponse.result.message = 'something goes wrong';
            response.put('response_x', addResponse);
        }
        else if (mode == deleteDoctor) {
            soapSforceComSchemasClassDoctorsear.deleteDoctorResponse_element addResponse =
                    new soapSforceComSchemasClassDoctorsear.deleteDoctorResponse_element();
            addResponse.result = new soapSforceComSchemasClassDoctorsear.ReturnClass();
            addResponse.result.message = 'Doctor Delete';
            response.put('response_x', addResponse);
        }
        else if (mode == getAll) {
            soapSforceComSchemasClassDoctorsear.getAllDoctorResponse_element addResponse =
                    new soapSforceComSchemasClassDoctorsear.getAllDoctorResponse_element();
            soapSforceComSchemasClassDoctorsear.DoctorDTO newDoctorDTO = new soapSforceComSchemasClassDoctorsear.DoctorDTO();
            newDoctorDTO.lastName = 'Test';
            List<soapSforceComSchemasClassDoctorsear.DoctorDTO> listOfDoctorDto = new List<soapSforceComSchemasClassDoctorsear.DoctorDTO>();
            listOfDoctorDto.add(newDoctorDTO);
            addResponse.result = new soapSforceComSchemasClassDoctorsear.ReturnClass();
            addResponse.result.listOfDoctor = listOfDoctorDto;
            response.put('response_x', addResponse);
        }
    }
}