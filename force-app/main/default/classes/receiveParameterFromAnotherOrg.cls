/**
 * Created by 48781 on 15.05.2022.
 */

global class receiveParameterFromAnotherOrg {
    webservice static string createcontactinorganisationsecond(string name,string name2,string title,string email1)
    {
        contact obj=new contact();
        obj.FirstName=name;
        obj.LastName=name2;
        obj.Title=title;
        obj.email=email1;
        insert obj;
        return 'success';
    }
}