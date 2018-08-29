@isTest
private class WebserviceLogTest {
    
    static testmethod void parseTest(){
        
    //    string json = 'json';
        
        test.startTest();
        WebserviceLog wsLog = new WebserviceLog();
        JSON.serialize(wsLog);
        WebserviceLog.parse(JSON.serialize(wsLog));
        test.stopTest();
    }
}