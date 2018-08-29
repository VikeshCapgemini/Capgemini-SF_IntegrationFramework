public without sharing abstract class BaseIntegration 
{
  public IntegrationSettings__c integrationSettings; 
    
    public CallOutResults calloutResponse = new CallOutResults();
    
    public string finalEndPoint;
    public map<string, string> requestHeader;
    public string certificate;
    public Object requestBody;
    
    public Map<string, string> responseHeader;
    public Object responseBody;
    
    public Object serviceOutput;
    
    private datetime executionStartTime;
    private long serviceCalloutTime;
    private datetime executionEndTime;
    
    public Map<String, String> urlReplacements;
    public Map<String, String> endPointParameters;    
    
    private abstract void setMethodForCallout();
    
    private abstract void prepareRequest();
    
    private abstract void execute();
    
    private abstract void processResponse();
    
    @TestVisible
    private void getCertificate()
    {
        certificate = IntegrationHelper.getClientCertificate(integrationSettings.Certificate_Name__c);
    }
    
    /*******************************************************************
    Purpose: Utility method for building an endpoint to be called by a web-service
    Parameters: URL, Record ID, web-service function and a map of parameters to be appended
    Returns: String endpoint for the web-service call
    Throws [Exceptions]: [optional]
    ********************************************************************/     
    @TestVisible
    private void populateEndPoint() 
    {        
        finalEndPoint = integrationSettings.EndPointURL__c;
        
        // Determine if endpoint already has a trailing slash - if not, add one
        if (!finalEndPoint.endsWith('/')) {            
            finalEndPoint += '/';            
        }
        
        //replace any required URI Replacements e.g. www.example.com/{UID}/test  to be www.example.com/123423423423/test
        if (urlReplacements!= null && urlReplacements.size()>0) 
        {            
            for(String aKey : urlReplacements.keySet())
            {                
                finalEndPoint = finalEndPoint.replace(aKey, urlReplacements.get(aKey));                
            }            
        }
        
        //These are the parameters at the end of the URI e.g. www.example.com?Take=value&Skip=value
        if (endPointParameters != null && endPointParameters.size()>0) 
        {            
            finalEndPoint = addParameters(finalEndPoint,endPointParameters);            
        }
        system.debug('@@finalEndPoint' + finalEndPoint);
    }
    
    /*******************************************************************
    * @description Adds Parameters onto the URL                       
    * @return Strin
    * @Throws [Exceptions]: None                                                 
    ********************************************************************/
    @TestVisible
    private String addParameters(String endPoint, Map<String, String> parameters) 
    {        
        // If the URL has a trailing slash, remove it before adding the parameters
        if (endPoint.endsWith('/')) 
        {            
            endPoint = endPoint.substring(0, endPoint.length() -1);            
        }
        
        // Add parameters to the end of the URL
        if (parameters != null && parameters.size()>0) 
        {            
            endPoint += '?';
            
            for (String arg : parameters.keySet()) 
            {                
                if (endPoint.endsWith('?')) 
                {                    
                    endPoint += arg + '=' + parameters.get(arg);                    
                } else 
                {                    
                    endPoint += '&' + arg + '=' + parameters.get(arg);                    
                } 
            }            
        }           
        
        return endPoint;        
    }
    
    @TestVisible
    private void getRequestHeaders()
    {
        requestHeader = IntegrationHelper.getRequestHeaders(integrationSettings);
    }
    
    public Object performCallout(Object serviceInput)
    {
        System.Debug('Start performCallout');
        System.Debug('serviceInput : ' + serviceInput);
        
        try
        {
            this.calloutResponse.status = 'S';
            populateEndPoint();
            getRequestHeaders();    
            getCertificate();
            
            requestBody = serviceInput;
            prepareRequest();
            
        }
        catch(Exception ex)
        {
            this.calloutResponse.status = 'E';
            this.calloutResponse.errorCode = 'Input';
            this.calloutResponse.errorMessage = ' Processing Error : ' + ex.getMessage();
            system.debug('@@ErrorBaseIntegration :' + ex.getMessage() + ex.getstacktracestring());
        }
        
        executionStartTime = system.now();                
        try
        {
            if(this.calloutResponse.status == 'S')
                execute();
        }
        catch(Exception ex)
        {
            this.calloutResponse.status = 'E';
            this.calloutResponse.errorCode = 'Interface';
            this.calloutResponse.errorMessage = ex.getMessage();
            system.debug('@@ErrorBaseIntegration :' + ex.getMessage());
        }
        executionEndTime = system.now();
        serviceCalloutTime = executionEndTime.getTime() - executionStartTime.getTime();
        
        try
        {  
          processResponse();
        }
        catch(Exception ex)
        {
            this.calloutResponse.status = 'E';
            this.calloutResponse.errorCode = 'Output';
            this.calloutResponse.errorMessage = ' Processing Error : ' + ex.getMessage();
            system.debug('@@ErrorBaseIntegration :' + ex.getMessage() + ex.getstacktracestring());      
        }
        
        logServiceStatus();
        System.Debug('End performCallout');
        
        System.Debug('serviceOutput:' +string.valueof(serviceOutput));
        return serviceOutput;
    }
    
    
    private void logServiceStatus()
    {
        System.Debug('Log Service Status');
        if(integrationSettings.Exception_On_OFF__c){
            /*WebService_Log__c WebServiceLog = new WebService_Log__c();
            WebServiceLog.Name = integrationSettings.Name;
            WebServiceLog.Status__c = this.calloutResponse.status;          
            WebServiceLog.Response_Code__c = this.calloutResponse.errorCode;
            WebServiceLog.Response_Description__c = this.calloutResponse.errorMessage;
            WebServiceLog.CalloutStartTime__c = executionStartTime;
            WebServiceLog.CalloutTime__c = serviceCalloutTime;
            WebServiceLog.Callout_End_Time__c = executionEndTime;*/
            
            WebserviceLogWrapper WebServiceLog = new WebserviceLogWrapper();
            WebServiceLog.Name = integrationSettings.Name;
            WebServiceLog.Status = this.calloutResponse.status;          
            WebServiceLog.Response_Code = this.calloutResponse.errorCode;
            WebServiceLog.Response_Description = this.calloutResponse.errorMessage;
            WebServiceLog.CalloutStartTime = executionStartTime;
            WebServiceLog.CalloutTime = serviceCalloutTime;
            WebServiceLog.Callout_End_Time = executionEndTime;
            
            {
                string request;
                if(requestBody instanceof string)
                    request = (String) requestBody;
                else
                    request = string.valueof(requestBody);
                
                /*if(request!= null && request.length() > 32767)  
                    request = request.substring(0,32767); */
                
                WebServiceLog.Request_Body = request;
            }
            
            {
                string response;
                if(responseBody instanceof string)
                    response = (String) responseBody;
                else
                    response = string.valueof(responseBody);
                
                /*if(response!= null && response.length() > 32767)
                    response = response.substring(0,32767);*/
                WebServiceLog.Response_Body = response;
            }            
            
            WebserviceLogHelper.logStatus(WebServiceLog, integrationSettings.WebserviceRestLogs__c);    
            
        }
    }
    
}