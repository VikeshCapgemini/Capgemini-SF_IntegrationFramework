global class MockHTTPRequestResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req){
      //  system.assertEquals('http://www.mocky.io/v2/5a3c95a03100001201b59211', req.getEndpoint());
        //system.assertEquals('GET', req.getMethod());
        
        // generating a fake response
        HttpResponse res = new HttpResponse();
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}