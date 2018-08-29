@isTest
private class IntegrationHelperTest {

    static testmethod void getRequestHeadersTest(){
        
        RequestHeader__c rHeader = new RequestHeader__c(name='testreqheader', Authorization__c='Basic Auth', ContentType__c='testcontent');
        insert rHeader;
        system.assert(rHeader.Id != null);
        
/*        RequestHeader__c rHeader1 = new RequestHeader__c(name='testreqheader', Authorization__c='OAuth', ContentType__c='testcontent');
        insert rHeader1;
        system.assert(rHeader1.Id != null);   */
        
        IntegrationSettings__c iSetting = new IntegrationSettings__c(name='testsettings', Certificate_Name__c='testcertificate', RequestHeader__c=rHeader.name, Username__c='testuser',
                                                                    Password__c='testpass', same_org__c=true);
        insert iSetting;
        system.assert(iSetting.Id != null);
        
 /*       IntegrationSettings__c iSetting1 = new IntegrationSettings__c(name='testsettings', Certificate_Name__c='testcertificate', RequestHeader__c=rHeader1.name, Username__c='testuser',
                                                                    Password__c='testpass', same_org__c=true);
        insert iSetting1;
        system.assert(iSetting1.Id != null);   */
        
//        RequestHeader__c rHeader = new RequestHeader__c(name='testreqheader', Authorization__c='testauth', ContentType__c='testcontent');
//        insert rHeader;
//         system.assert(rHeader.Id != null);
        
        test.startTest();
        
        IntegrationHelper.getRequestHeaders(iSetting); 
//        IntegrationHelper.getRequestHeaders(iSetting1);
        test.stopTest();
    }
    
/*   static testmethod void getRequestHeadersTest1(){
        
        RequestHeader__c rHeader1 = new RequestHeader__c(name='testreqheader', Authorization__c='OAuth', ContentType__c='testcontent');
        insert rHeader1;
        system.assert(rHeader1.Id != null);
        
    }  */
    
    static testmethod void getClientCertificateTtest(){
        
        string cName = 'testcertname';
        
        test.startTest();
        IntegrationHelper.getClientCertificate(cName);
        test.stopTest();
    }
    
    static testmethod void getWebResponseCodeTest(){
        string statusCode = 'teststatuscode';
        
        test.startTest();
        IntegrationHelper.getWebResponseCode(statusCode);
        test.stopTest();
    }
    
}