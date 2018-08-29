public class SampleWeatherService implements ServiceInterface {

    public wwwWebservicexNet.GetCitiesByCountry_element requestElement = new wwwWebservicexNet.GetCitiesByCountry_element();
    
    public object prepareInputRequest(object serviceInput)
    {
        requestElement.CountryName = (string)serviceInput;
        System.debug('@@WeatherService - prepareInputRequest: ' + requestElement);
        return requestElement;
    }
       
    public object executeCallout(SOAPHeader soapHeader)
    {
        wwwWebservicexNet.GlobalWeatherSoap soap = new wwwWebservicexNet.GlobalWeatherSoap();
        //wwwWebservicexNet.GetCitiesByCountryResponse_element response = new wwwWebservicexNet.GetCitiesByCountryResponse_element();
        
        if (soapHeader.endpoint.endsWith('/')) 
        {            
            soapHeader.endpoint = soapHeader.endpoint.substring(0, soapHeader.endpoint.length() -1);            
        }
        
        soap.endpoint_x = soapHeader.endpoint;
        System.debug('@@WeatherService - inputHttpHeaders_x: ' + soapHeader.inputHttpHeaders);
        //soap.inputHttpHeaders_x = soapHeader.inputHttpHeaders;
        soap.clientCertName_x = soapHeader.clientCertName;
        soap.timeout_x = soapHeader.timeout;
        
        string response = soap.GetCitiesByCountry(requestElement.CountryName);         
        System.debug('@@WeatherService - executeCallout: ' + response);
        
        return response;
    }
    
    public object prepareOutputResponse(CallOutResults calloutResponse)
    {
        string strCitiesNames;
        
        if(calloutResponse != null && calloutResponse.status == 'S')
        {
            strCitiesNames = (string)calloutResponse.response;
        }
        return strCitiesNames;
    }
    
}