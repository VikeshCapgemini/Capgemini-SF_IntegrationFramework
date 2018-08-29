@isTest
private class BaseIntegrationTest {
    
    public CallOutResults calloutResponse = new CallOutResults();

    static testmethod void getCertificateTest(){
        
    
 //       BaseIntegration baseIntg = new BaseIntegration();
     IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'testcertificate');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.getCertificate();
        test.stopTest();
    }
    
    static testmethod void populateEndPointTest(){
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'testcertificate',
                                                                    EndPointURL__c = 'https://wmcustomer.apiary.io/customer/v1/cards/');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.populateEndPoint();
        test.stopTest();
        
    }
    
    static testmethod void addParametersTest(){
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'testcertificate',
                                                                    EndPointURL__c = 'https://wmcustomer.apiary.io/customer/v1/cards/');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('param1', 'param2');
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.addParameters(iSetting.EndPointURL__c, parameters);
        test.stopTest();
    }
    
    static testmethod void getRequestHeadersTest(){
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'testcertificate',
                                                                    EndPointURL__c = 'https://wmcustomer.apiary.io/customer/v1/cards/');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.getRequestHeaders();
        test.stopTest();
        
    }
    
    static testmethod void performCalloutTest(){
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'testcertificate',
                                                                    EndPointURL__c = 'https://wmcustomer.apiary.io/customer/v1/cards/');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        string finalEndPoint;
        
        string serviceInput = 'testservip';
//        insert serviceInput;
    datetime executionStartTime = system.now();
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.performCallout(serviceInput);
        System.assertEquals(iSetting.EndPointURL__c, restIntg.finalEndPoint);
        test.stopTest();
    }
}