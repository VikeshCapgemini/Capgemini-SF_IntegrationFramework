public interface ServiceInterface {

    object prepareInputRequest(object serviceInput);
       
    object executeCallout(SOAPHeader soapHeader);
    
    object prepareOutputResponse(CallOutResults calloutResponse);

}