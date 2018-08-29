public without sharing class IntegrationHelper {

    //Declare final static string variables for Certificate
    //
    public static final String WS_AUTHORIZATION_HEADER                      = 'Authorization';
    public static final String WS_AUTH_TYPE_BASIC                           = 'Basic ';
    public static final String WS_BASIC_AUTH                                = 'Basic Auth';
    public static final String WS_OAUTH                                     = 'OAuth';
    public static final String WS_OAUTH_2                                   = 'OAuth 2.0';
    public static final String WS_USER_AGENT                                = 'User-Agent';
    public static final String WS_EXCEPTION                                 = 'Exception';
    public static final String CONTENT_TYPE                                 = 'Content-Type';
    public static final String WS_HTTP_CODE_SUCCESS_START                   = '2';
    public static final String HTTP_CONTENT_TYPE_JSON                       = 'Accept';
    public static final String WS_OAUTH_ACCESS_TOKEN                        = 'access_token';
    public static final String WS_RESPONSE_OK                              = 'OK';
    public static final String WS_API_KEY                  = 'x-api-key';
    public static final string WS_SUCCESS_MESSAGE                         = 'SUCCESS';
    public static final string WS_FAILURE_MESSAGE                         = 'Integration failed, please contact system admin';
    public static final integer WS_STATUS_CODE                            = 200;
    public static final string WS_429_CODE                                = '429';
    public static final string WS_500_CODE                                = '500';
    public static final string WS_GET_Method                              = 'GET';
    public static final string WS_POST_Method                             = 'POST';
    public static final string WS_RESTSTATUSLOG_NAME                      ='StausLogCallout';
    
    
    public static Map<string, string> getRequestHeaders(IntegrationSettings__c integrationSettings)
    {
        system.debug('IntegrationHelper - getRequestHeaders');
      map<string, string> headers = new map<string, string>();
        
        if(integrationSettings.RequestHeader__c != null)
        {
            RequestHeader__c requestHeader = RequestHeader__c.getInstance(integrationSettings.RequestHeader__c);
            if(requestHeader != NULL)
            {
                if(requestHeader.ContentType__c != null) headers.put(CONTENT_TYPE,requestHeader.ContentType__c);
                
                if(requestHeader.Authorization__c != null && requestHeader.Authorization__c == WS_BASIC_AUTH)
                {
                    String username = integrationSettings.Username__c;
                    String password = integrationSettings.Password__c;
                    Blob authStringToEncode = Blob.valueOf(username + ':' + password);
                    
                    headers.put(WS_AUTHORIZATION_HEADER, WS_AUTH_TYPE_BASIC + EncodingUtil.base64Encode(authStringToEncode));
                    System.debug('@@Basic authentication');
                    //headers.put('Authorization',requestHeader.Authorization__c);
                }
                else if(requestHeader.Authorization__c != null && requestHeader.Authorization__c == WS_OAUTH)
                {
                    System.debug('@@OAuth authentication');
          			if(integrationSettings.same_org__c)
                    {
                        headers.put(WS_AUTHORIZATION_HEADER, WS_OAUTH + ' ' + UserInfo.getSessionId()); 
                        System.Debug('UserInfo.getSessionId'+ UserInfo.getSessionId());
                    }
                }
            }
        }
        
        return headers;
    }
    
    public static string getClientCertificate(string name)
    {
        string certificate;
        if(name != null)
        {
            //Add if condition to compare with Certificate name declared above as string
            //If true then set Certificate = string variable value
            
        }
        return certificate;
    }
    
    public static WS_ResponseCode__c getWebResponseCode(string statusCode) {
        return  WS_ResponseCode__c.getValues(statusCode);
    }
}