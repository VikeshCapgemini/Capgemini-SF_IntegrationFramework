@isTest
private class WebserviceLogHelperTest {
    
    static testmethod void logStatusTest(){
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='StausLogCallout', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'testcertificate',
                                                                    Exception_On_OFF__c=true);
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        WebService_Log__c wsLog = new WebService_Log__c(name=iSetting.name);
        insert wsLog;
        system.assert(wsLog.Id != null);
        
        boolean WebserviceRestLogs = true;
        
        test.startTest();
        WebserviceLogHelper.logStatus(wsLog, WebserviceRestLogs);
        test.stopTest();
    }
    
    static testmethod void logStatusByRESTServiceCallTest(){
        
        String jsonString = 'testjson';
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='StausLogCallout', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'testcertificate',
                                                                    Exception_On_OFF__c=true);
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        WebserviceLogHelper.logStatusByRESTServiceCall(jsonString);
        test.stopTest();
    }
    
}