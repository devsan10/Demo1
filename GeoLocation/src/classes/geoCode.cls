public with sharing class geoCode {
  /* maintained in Custom settings ; 
    1. Geo Code Output Type  - XML or JSON, based on the conguration
    2. Google GeoMap API Key - signup for free Google developer account/console*/
  private static string output= Integration_Credentials__c.getInstance('Geo Code Output Type').value__c;
  private static string key= Integration_Credentials__c.getInstance('Google GeoMap API Key').value__c;
  
  
  
  //@future(callout=true) Note: uncomment for asynchronous calls..
  public static Map<id, String>  getGeocode(id accountId, string StAddress, string postalcode){
   system.debug('geoCode.getGeocode() Entering..');     
  
   Map<id, String> geoMap= new Map<id, String>();
   output =output.toLowercase();
   PageReference p = new Pagereference('https://maps.googleapis.com/maps/api/geocode/'+ output);
   p.getParameters().put('address',StAddress+','+ postalcode);
   p.getParameters().put('key',key); 
   string endpoint =p.getURL();
   
   system.debug(endpoint);
   HTTPRequest req= new HTTPRequest();
   req.setEndpoint(endpoint);
   req.setMethod('GET');
   req.setTimeout(120000);
   HttpResponse res= new Http().send(req);
   system.debug(res.getBody());
   string responsestring=res.getBody();
   if (res.getStatusCode()==200){
    if (output=='xml'){
    String strLatitude = responsestring.substringbetween('<lat>','</lat>' );
    String strlongitude = responsestring.substringbetween('<lng>','</lng>' );
    geoMap.put(accountId, strLatitude+':'+ strlongitude);
    }
    else if (output=='json'){
        // Parse JSON response.
        JSONParser parser = JSON.createParser(responsestring);
        Double dLatitude, dLongitude;
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'location')) {
                // Get the value.
                parser.nextToken();
               while (parser.nextToken() != null){
                  if(parser.getText() == 'lat') {
                     parser.nextToken();
                      dLatitude = parser.getDoubleValue();
                   }
                   else if(parser.getText() == 'lng') {
                      parser.nextToken();
                     dLongitude = parser.getDoubleValue();
                   }
               }
            }
        }
          geoMap.put(accountId, dLatitude+':'+ dLongitude);  
     } /* JSON**/
   } /** IF **/
   system.debug('geoCode.getGeocode() Exiting..'); 
   return geoMap;
  } /** method getGeocode end **/
  
}/** class end**/