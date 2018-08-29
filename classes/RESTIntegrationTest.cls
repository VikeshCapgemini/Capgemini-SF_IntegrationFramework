@isTest
private class RESTIntegrationTest {

    static testmethod void calloutTest(){
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'rest');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        string request = 'test';
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.callout(request);
        test.stopTest();
    }
    
    static testmethod void prepareRequestTest(){
        
        test.setMock(HttpCalloutMock.class, new MockHTTPRequestResponseGenerator());
        string requestBody = 'testrequest';
        
        RequestHeader__c rHeader = new RequestHeader__c(name='testreqheader', Authorization__c='Basic Auth', ContentType__c='testcontent');
        insert rHeader;
        system.assert(rHeader.Id != null);
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='GETTestAPI', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'rest',
                                                                    Certificate_Password__c = '*****',EndPointURL__c = 'https://test.com',
                                                                    RequestHeader__c=rHeader.name);
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.callout(new HttpRequest());
        //restIntg.prepareRequest();
        test.stopTest();
            
            }
    
    static testmethod void executeTest(){
        
        test.setMock(HttpCalloutMock.class, new MockHTTPRequestResponseGenerator());
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'testcertificate',
                                                EndPointURL__c = 'http://www.mocky.io/v2/5a3c95a03100001201b59211');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
 /*       Http http = new Http();
        HttpRequest request = new HttpRequest();
      HttpResponse response = http.send(request);   */
      
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.execute();
        test.stopTest();
    }
    
    static testmethod void processResponseTest(){
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'GET', Certificate_Name__c = 'rest');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.processResponse();
        test.stopTest();
    }
    
    static testmethod void setMethodForCalloutTest(){
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='MoreCard', timeOut__c = 120000, ServiceMethodName__c = 'patch');
        insert iSetting;
        system.assert(iSetting.Id != null);
        
        test.startTest();
        RESTIntegration restIntg = new RESTIntegration(iSetting.name);
        restIntg.setMethodForCallout();
        test.stopTest();
    }
    
}