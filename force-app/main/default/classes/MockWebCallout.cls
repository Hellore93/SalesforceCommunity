/**
 * Created by 48781 on 17.05.2022.
 */

@IsTest
private class MockWebCallout {
    static String IdDoc = 'a0K7Q000000VMvm';
    static String firstName = 'AB123A';
    static String lastName = 'AB123A';
    static String email = 'raf@o2.pl';
    static String specialization = 'AAAA2222AAAA';
    static String phoneNumber = '123456789';
    static Date dateOfBirth = null;
    static String country = 'Poland';
    static String city = 'Kielce';
    static String street = 'Krakowska';

    @IsTest
    static void searchTest() {
        Test.setMock(WebServiceMock.class, new MockTestClass(MockTestClass.seachDoctor));
        soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService soapDivice =
                new soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService();
        soapSforceComSchemasClassDoctorsear.ReturnClass result = soapDivice.searchDoctor
                (firstName, lastName, country);

        System.assertEquals('0 record finded', result.message);
    }

    @IsTest
    static void createTest() {
        Test.setMock(WebServiceMock.class, new MockTestClass(MockTestClass.createDoctor));
        soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService soapDivice =
                new soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService();
        soapSforceComSchemasClassDoctorsear.ReturnClass result = soapDivice.createDoctor
                (firstName, lastName, specialization, phoneNumber, email, dateOfBirth, city, country, street);

        System.assertEquals('Done', result.message);
    }

    @IsTest
    static void editTest() {
        Test.setMock(WebServiceMock.class, new MockTestClass(MockTestClass.editDoctor));
        soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService soapDivice =
                new soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService();
        soapSforceComSchemasClassDoctorsear.ReturnClass result = soapDivice.updateDoctor
                (IdDoc, firstName, lastName, specialization, phoneNumber, email, dateOfBirth, city, country, street);

        System.assertEquals('something goes wrong', result.message);
    }

    @IsTest
    static void deleteTest() {
        Test.setMock(WebServiceMock.class, new MockTestClass(MockTestClass.deleteDoctor));
        soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService soapDivice =
                new soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService();
        soapSforceComSchemasClassDoctorsear.ReturnClass result = soapDivice.deleteDoctor(IdDoc);

        System.assertEquals('Doctor Delete', result.message);
    }

    @IsTest
    static void getAll() {
        Test.setMock(WebServiceMock.class, new MockTestClass(MockTestClass.getAll));
        soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService soapDivice =
                new soapSforceComSchemasClassDoctorsear.DoctorSearchSOAPService();
        soapSforceComSchemasClassDoctorsear.ReturnClass result = soapDivice.getAllDoctor();
        System.assertEquals('Test', result.listOfDoctor[0].lastName);
    }
}