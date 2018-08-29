public without sharing class SOAPIntegration extends BaseIntegration
{
    SOAPHeader soapHeader = new SOAPHeader();
    private ServiceInterface serviceClass;
    private object serviceRequest;
    private object serviceResponse;
    
    public SOAPIntegration(string name)
    {
        system.debug('SOAPIntegration - Constructor');
        integrationSettings = IntegrationSettings__c.getInstance(name);
        
        serviceClass = (ServiceInterface)Type.forName(integrationSettings.HelperClassName__c).newInstance();        
    }
    
    public Object callout(Object request)
    {        
        return performCallout(request);
    }
    
  private void prepareRequest()
    {
    if(integrationSettings.Timeout__c != null) soapHeader.timeout = integer.ValueOf(integrationSettings.Timeout__c);
        if(integrationSettings.Certificate_Name__c != null) soapHeader.clientCertName = integrationSettings.Certificate_Name__c;
        
      soapHeader.endpoint = finalEndPoint;
        
        if(requestHeader != null && !requestHeader.isEmpty()) soapHeader.inputHttpHeaders = requestHeader;        
        
        serviceRequest = serviceClass.prepareInputRequest(requestBody);
        System.debug('@@serviceRequest : ' +serviceRequest);
    }
    
    private void execute()
    {
        serviceResponse = serviceClass.executeCallout(soapHeader);
        System.debug('@@serviceResponse : ' +serviceResponse);
    }
    
    public void processResponse()
    {
    if(serviceResponse != null)
        {
            //calloutResponse.response = serviceResponse;
            
            responsebody =   serviceClass.prepareOutputResponse(calloutResponse);
            
            calloutResponse.response = responsebody;
        }
        
        serviceOutput = calloutResponse;
    }
    
    private Void setMethodForCallout() 
    {
        //do nothing
    }
}