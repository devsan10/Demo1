public with sharing class geocode_Methods {       
  // New to Hotel Object.... 
   public static void updateGeocodes(list<sobject> sObjList) {
      system.debug('account_Methods.updateGeocodes() Entering..');
      string sStreetAddress, sZip;
      Account act;
      Hotel__c ht; 
      id recordId;
      for (sObject o : sObjList ){
         if (o.getSObjectType() == Account.Sobjecttype){
            act = (Account)o;
            sStreetAddress=act.billingstreet;
            sZip =act.billingpostalcode;
            recordId =o.id;
         }  
         else if (o.getSObjectType() == Hotel__c.sObjectType){
            ht = (Hotel__c)o;
            sStreetAddress=ht.street__c;
            // decimal myDecimal=ht.zip_postal_code__c;
            // sZip =myDecimal.toplainString();
            sZip =ht.zip_postal_code__c;
            recordId =ht.id;
         } 
                
         Map<id, string> m = geoCode.getGeocode(recordId, sStreetAddress, sZip);
         String geoValues = m.get(recordId);
         List<String> geoList = geoValues.split(':');         
        // Geocode updates...
        if (geoList.get(0)!=null){
          if (o.getSObjectType() == Account.Sobjecttype)
              act.billinglatitude = double.valueof(geoList.get(0));
           else if (o.getSObjectType() == Hotel__c.sObjectType)
              ht.Location__Latitude__s = double.valueof(geoList.get(0));
        } 
        if (geoList.get(1)!=null){
         if (o.getSObjectType() == Account.Sobjecttype)
              act.billinglongitude = double.valueof(geoList.get(1));
          else if (o.getSObjectType() == Hotel__c.sObjectType)
              ht.Location__Longitude__s = double.valueof(geoList.get(1));
        }
        upsert o;
         }
         
        system.debug('geocode_Methods.updateGeocodes() Exiting..');
    
   }  
     
       public static list<double> getGeocodeByAddress(string sStreet, string sZipCode) {
        list<double> ListDbl= new List<double>();
        //geoCode.output='json';
        Map<id, string> m = geoCode.getGeocode(null, sStreet, sZipCode);
        String geoValues = m.get(null);
        List<String> geoList = geoValues.split(':');         
        // Geocode updates.......
        if (geoList.get(0) != null)
        ListDbl.add(double.valueof(geoList.get(0)));
        else
        ListDbl.add(0);
        // Geocode updates.......to..vvvv...
        if (geoList.get(1) != null)
        ListDbl.add(double.valueof(geoList.get(1)));
        else
        ListDbl.add(0);  /** Test....**/     
        system.debug('geocode.getGeocodeByAddress(): ListDbl -->' + ListDbl);
        return ListDbl;
        } 
    
         
    }