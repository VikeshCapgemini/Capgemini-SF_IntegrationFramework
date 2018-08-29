public without sharing class RESTIntegration extends BaseIntegration {
  
    HttpRequest request = new HttpRequest();
    HttpResponse response = new HttpResponse();
    Http http = new Http();
        
    public RESTIntegration(string name)
    {
        system.debug('RESTIntegration - Constructor');
        integrationSettings = IntegrationSettings__c.getInstance(name);
    }
    
    public Object callout(Object request)
    {        
        return performCallout(request);
    }
    
    @TestVisible
    private void prepareRequest()
    {
        if(integrationSettings.Timeout__c != null) request.setTimeout(integer.ValueOf(integrationSettings.Timeout__c));
        if(integrationSettings.ServiceMethodName__c != null) setMethodForCallout();
        if(integrationSettings.Certificate_Name__c != null) request.setClientCertificateName(integrationSettings.Certificate_Name__c);
        if(certificate != null) request.setClientCertificate(certificate, integrationSettings.Certificate_Password__c);
        
        if(requestHeader != null && !requestHeader.isEmpty())
        {
            //The authorization replace code is for status logs service call to add user's session in header.
            /*string strUrl = System.URL.getSalesforceBaseUrl().toString();
            system.debug('@Url : ' + strUrl);
            List<string> lstStr = strUrl.split('=');
            system.debug('@Url1 : ' + lstStr[lstStr.size() - 1]);
            strUrl = lstStr[lstStr.size() - 1].replace(']', '');
            system.debug('@Url : ' + strUrl);
            system.debug('@requestHeader : ' + requestHeader);*/
            //if(requestHeader.containsKey('Authorization') && finalEndPoint.startsWith(strUrl))
            /*if(requestHeader.containsKey('Authorization') && integrationSettings.same_org__c)
            {
                requestHeader.put('Authorization', requestHeader.get('Authorization') + ' ' + UserInfo.getSessionId()); 
             System.Debug('UserInfo.getSessionId'+ UserInfo.getSessionId());
            }*/
            
            Set<string> keys = requestHeader.keySet();
            for(string key : keys){
                request.setHeader(key, requestHeader.get(key));
            }          
        }
        
        
        
        string jsonString;
        if(requestBody != null){
            if(requestBody instanceof string){
                jsonString = (string)requestBody;}
            else {
                jsonString = JSON.serializePretty(requestBody);}            
        }        
        
        request.setEndpoint(finalEndPoint);
            
        if(endPointParameters == null && jsonString != null)  request.setBody(jsonString);
      //      request.setBody(jsonString);
        
        
        requestBody = jsonString;        
        System.debug('Request Body : ' + requestBody);
    }
    
    @TestVisible
    private void execute()
    {
        try{
            system.debug('Request : ' + request);
            system.debug('Request get Body: ' + request.getEndpoint());
            response = http.send(request); 
            system.debug('Response : ' + response);
        }
        catch(Exception ex) {
            system.debug('Interface Error : '+ex.getMessage());
            throw ex;
        }
    }
    
    public void processResponse(){
        if(response != null)
        {
            responseBody = response.getBody();
            System.Debug('Response Body : ' + responseBody);
            
            string jsonResponse = (string)responseBody;
            system.debug('@@jsonResponse' + jsonResponse);
            
            calloutResponse.statusCode = response.getStatusCode();
            if(calloutResponse.statusCode <> null) 
            {
                WS_ResponseCode__c resObj = IntegrationHelper.getWebResponseCode(string.valueOf(calloutResponse.statusCode));
                if(resObj <> null) {
                    calloutResponse.description = resObj.WS_Description__c;
                    calloutResponse.uiDescription = resObj.UI_Description_Message__c;
                }
                
              if(calloutResponse.statusCode != 200 && calloutResponse.statusCode != 201)
                {
                    calloutResponse.status = 'E';
                    calloutResponse.errorCode = string.valueOf(response.getStatusCode());
                    calloutResponse.errorMessage = response.getStatus();                    
                }
                
                system.debug('serviceSettings.OutputClass__c :' + integrationSettings.OutputClass__c);
                if(integrationSettings.OutputClass__c != null && responseBody != null && responseBody instanceof string)
                {
                    system.debug('Type.forName(serviceSettings.OutputClass__c) :' + Type.forName(integrationSettings.OutputClass__c));
                
                  responseBody = JSON.deserialize(jsonResponse, Type.forName(integrationSettings.OutputClass__c));
                system.debug('Final JSON deserialized :' + responseBody);
                    calloutResponse.response = responseBody;
                }
                else
                    calloutResponse.response = responseBody;
            }
            
            serviceOutput = calloutResponse;
        } 
        
    }
    
    /*******************************************************************
    * @description Sets Method for the Callout
    * @Param  String
    * @Param  HttpRequest
    * @Throws [Exceptions]: None                                                 
    ********************************************************************/  
  @TestVisible    
    private Void setMethodForCallout() 
    {
        //Populates the Method of the API request
        If (integrationSettings.ServiceMethodName__c.tolowerCase() == 'patch') {           
            request.setMethod('POST');
            request.setHeader('X-HTTP-Method-Override', integrationSettings.ServiceMethodName__c);        
        } else {
            request.setMethod(integrationSettings.ServiceMethodName__c);
        }    
    }
    
}