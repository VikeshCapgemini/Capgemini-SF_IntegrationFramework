public class SampleWeatherHelper {
  SampleWeatherHelper.WeatherWrapper getWeatherWrap=new SampleWeatherHelper.WeatherWrapper();
    public void getCitiesByCountry(string countryName)
    {
        SOAPIntegration soap = new SOAPIntegration('GlobalWeather');
        CallOutResults result = (CallOutResults)soap.callout(countryName);
        System.debug('@@result : ' +result);
    }
    
    public void getWeather(SampleWeatherHelper.WeatherWrapper getWeatherWrap )
    {
        SOAPIntegration soap = new SOAPIntegration('GetWeather');
        CallOutResults result = (CallOutResults)soap.callout(getWeatherWrap);
        System.debug('@@result : ' +result);
    }
    
    public class WeatherWrapper{
         public String CityName;
     public String CountryName;
    }
    
}