/**********************************************************************
 Name:  WebserviceLogWrapper 
 Copyright © 2017  UK ODC.
====================================================== 
======================================================
Purpose:  Wrapper Class used for  Rest Web Service class: LogStatusRestCallout 
======================================================
======================================================
History                                                            
-------                                                            
VERSION    AUTHOR             DATE              DETAIL                         
0.1       Chavi Goel         01/16/2018         INITIAL DEVELOPMENT
0.2        Vikesh Gajula     28/08/2018         Updated variables
***********************************************************************/

public class WebserviceLogWrapper {
        
    //public String jsonString;
    //public String Method_Type;   
    public String Response_Description;
    public String Response_Body;
    public String Response_Code;
    //public String Endpoint;
    //public String Apex_Class;
    public String Request_Body;
    //public Decimal Timeout_Session;
    //public String Log_Type;
    public DateTime CalloutStartTime; 
    public DateTime Callout_End_Time;
    public long CalloutTime;
    public String Name;
    public string status; 
}