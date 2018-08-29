public class SampleServiceLog {

    public void logStatus()
    {
        WebService_Log__c wsLogs = new WebService_Log__c(name='testwslogs', Response_Body__c='test', Request_Body__c='test');
        string requestBody = JSON.serializePretty(wsLogs);
        
        WebserviceLogHelper.logStatusByRESTServiceCall(requestBody);
    }
    
    @AuraEnabled
    public static void logStatusLightning()
    {
        WebserviceLogWrapper wsLogs = new WebserviceLogWrapper();
        wsLogs.name='testwslogs'; 
        wsLogs.Response_Body='test'; 
        wsLogs.Request_Body='test';
        string requestBody = JSON.serializePretty(wsLogs);
        
        WebserviceLogHelper.logStatusByRESTServiceCall(requestBody);
    }
    
}