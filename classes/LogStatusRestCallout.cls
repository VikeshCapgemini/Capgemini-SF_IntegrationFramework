@RestResource(urlMapping='/LogStatusByRestCallout/*')
global class LogStatusRestCallout 
{
   @HttpPost
   global static void createLogs() 
   {
      // Retrieving the request body
      //String body = System.RestContext.request.requestBody.toString().replace('__c','');
      String body = System.RestContext.request.requestBody.toString();
               
      system.debug('b4 deserialized data'+body ); 
      
      //deserializing the request body to wrapper class WebserviceLogWrapper 
      WebserviceLogWrapper objServiceWrapper =(WebserviceLogWrapper)JSON.deserialize(body,WebserviceLogWrapper.class);
      system.debug('$$$$$$$'+objServiceWrapper);
       
      //instantiated to create a Webservice Log       
      WebService_Log__c serviceLog = WebserviceLogHelper.parseServiceLog(objServiceWrapper);
    
      /*serviceLog.Response_Description__c=webStruc.Response_Description;
      serviceLog.Response_Code__c=webStruc.Response_Code;
      serviceLog.Response_Body__c=webStruc.Response_Body;
      serviceLog.Request_Body__c=webStruc.Request_Body;
      serviceLog.CalloutStartTime__c=webStruc.CalloutStartTime;
      serviceLog.Callout_End_Time__c=System.now();
      serviceLog.Name=webStruc.Name;*/
      try
      {
          insert serviceLog; 
          
          List<Attachment> attachList= new List<Attachment>();
          Attachment attach1=new Attachment();
          Attachment attach2=new Attachment();
          if(serviceLog.Response_Body__c !=''&& serviceLog.Response_Body__c !=null)
          {
                Blob b = Blob.valueOf(objServiceWrapper.Response_Body );
                attach1.ParentId = serviceLog.id;
                attach1.Name = 'Response File';
                attach1.Body = b ;
                attachList.add(attach1);
          }
          if(serviceLog.Request_Body__c!=''&& serviceLog.Request_Body__c!=null)
          {
                Blob attach2Body =Blob.valueOf(objServiceWrapper.Request_Body);
                attach2.ParentId = serviceLog.id;
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
          system.debug(serviceLog);
       } 
       catch(Exception e){
            System.debug('Error inserting logs');
       }
                    
                    
   }
}