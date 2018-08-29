public class WebserviceLogHelper {
  
    public static webservice_Log__c parseServiceLog(WebserviceLogWrapper objServiceWrapper)
    {
        WebService_Log__c serviceLog = new WebService_Log__c();
        serviceLog.Name = objServiceWrapper.Name;
        serviceLog.Callout_End_Time__c = objServiceWrapper.Callout_End_Time;
        serviceLog.CalloutStartTime__c = objServiceWrapper.CalloutStartTime;
        serviceLog.CalloutTime__c = objServiceWrapper.CalloutTime;
        
        if(objServiceWrapper.Request_Body!= null && objServiceWrapper.Request_Body.length() > 32767)  
                objServiceWrapper.Request_Body = objServiceWrapper.Request_Body.substring(0,32767);
        
        if(objServiceWrapper.Response_Body!= null && objServiceWrapper.Response_Body.length() > 32767)  
                objServiceWrapper.Response_Body = objServiceWrapper.Response_Body.substring(0,32767);
        
        serviceLog.Request_Body__c = objServiceWrapper.Request_Body;
        serviceLog.Response_Body__c = objServiceWrapper.Response_Body;
        serviceLog.Response_Code__c = objServiceWrapper.Response_Code;
        serviceLog.Response_Description__c = objServiceWrapper.Response_Description;
        serviceLog.Status__c = objServiceWrapper.status;
        return serviceLog;
    }
    
    public static void logStatus(WebserviceLogWrapper statusLogWrapper, boolean WebserviceRestLogs)
    {        
        WebService_Log__c statusLog = parseServiceLog(statusLogWrapper);
        if(statusLog != null){
            if(WebserviceRestLogs)
            {
                system.debug('WebserviceLogHelper - in if logStatus');
                logStatusByRESTServiceCall(JSON.serializePretty(statusLogWrapper));
                
            }
            else     
            {
                system.debug('WebserviceLogHelper - in else if logStatus');
                insert statusLog;
                
                List<Attachment> attachList= new List<Attachment>();
                Attachment attach1=new Attachment();
                Attachment attach2=new Attachment();
                if(statusLog.Response_Body__c !='' && statusLog.Response_Body__c !=null){
                    Blob b = Blob.valueOf(statusLogWrapper.Response_Body);
                    attach1.ParentId = statusLog.id;
                    attach1.Name = 'Response File';
                    attach1.Body = b ;
                    attachList.add(attach1);
                }
                if(statusLog.Request_Body__c!=''&& statusLog.Request_Body__c!=null){
                    Blob attach2Body =Blob.valueOf(statusLogWrapper.Request_Body);
                    attach2.ParentId = statusLog.id;
                    attach2.Name = 'Request File';
                    attach2.Body = attach2Body ;
                    system.debug('attachement-->'+attach1);
                    attachList.add(attach2);
                }
                try{
                    insert attachList;
                }
                catch(Exception e){
                    system.debug('Error while creating attachment in REST callout');
                }
            }
        }        
    }
    
    public static void logStatusByRESTServiceCall(String jsonString)
    {    
        System.debug('WebserviceLogHelper - logStatusByRESTServiceCall');
        RESTIntegration rest = new RESTIntegration('StausLogCallout');        
        Object status = rest.callout(jsonString);
        system.debug('@@logStatusByRESTServiceCall - status' + status); 
  }
    
}