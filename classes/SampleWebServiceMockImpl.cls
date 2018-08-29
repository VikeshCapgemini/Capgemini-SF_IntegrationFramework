global class SampleWebServiceMockImpl implements WebServiceMock {
  global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
      /* docSample.EchoStringResponse_element respElement = 
           new docSample.EchoStringResponse_element();
       respElement.EchoStringResult = 'Mock response'; */
       Map<String, wwwWebservicexNet.GetCitiesByCountryResponse_element> response_map_x = new Map<String, wwwWebservicexNet.GetCitiesByCountryResponse_element>();
       wwwWebservicexNet.GetCitiesByCountryResponse_element response_x = new wwwWebservicexNet.GetCitiesByCountryResponse_element();
       response_x.GetCitiesByCountryResult = '<string xmlns="http://www.webserviceX.NET"><NewDataSet> <Table> <Country>Belarus</Country> <City>Riga Airport</City> </Table> <Table> <Country>Mauritius</Country> <City>Plaisance Mauritius</City></Table> </NewDataSet></string>';
       //response_map_x.put('response_x',response_x);
       response.put('response_x', response_x);
}
}