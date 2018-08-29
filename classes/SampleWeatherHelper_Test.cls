@IsTest(seeAllData = FALSE)
public class SampleWeatherHelper_Test {

    @IsTest
    private static void getCitiesByCountry_test()
    {
        IntegrationSettings__c integrationSetting = new IntegrationSettings__c();
        integrationSetting.Name = 'GlobalWeather';
        integrationSetting.timeOut__c = 30000;
        integrationSetting.EndPointURL__c = 'http://www.webservicex.com/globalweather.asmx';
        integrationSetting.HelperClassName__c = 'SampleWeatherService';
        integrationSetting.RequestHeader__c = 'SOAPBASIC';
        insert integrationSetting;
        Test.setMock(WebServiceMock.class, new SampleWebServiceMockImpl());
        Test.startTest();
        SampleWeatherHelper whObj = new SampleWeatherHelper();
        whObj.getCitiesByCountry('India');
        Test.stopTest();
    }
    
    @IsTest
     private static void getWeather_test()
     {
         SampleWeatherHelper.WeatherWrapper getWeatherWrap=new SampleWeatherHelper.WeatherWrapper();
         getWeatherWrap.CityName='London';
         getWeatherWrap.CountryName='India';
        IntegrationSettings__c integrationSetting = new IntegrationSettings__c();
        integrationSetting.Name = 'GetWeather';
        integrationSetting.timeOut__c = 30000;
        integrationSetting.EndPointURL__c = 'http://www.webservicex.com/globalweather.asmx';
        integrationSetting.HelperClassName__c = 'GetWeatherService';
        integrationSetting.RequestHeader__c = 'SOAPBASIC';
        insert integrationSetting;
        Test.setMock(WebServiceMock.class, new SampleWebServiceMockImplWeather());
        Test.startTest();
        SampleWeatherHelper whObj = new SampleWeatherHelper();
        whObj.getWeather(getWeatherWrap);
        Test.stopTest();
    }
    
}