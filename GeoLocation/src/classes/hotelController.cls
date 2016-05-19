public with sharing class hotelController {
    public Hotel__c hotel { get; private set; }

    public hotelController() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        hotel = (id == null) ? new Hotel__c() : 
            [SELECT name, location__latitude__s, location__longitude__s, street__c, city__c, state_province__c, zip_postal_code__c,country__c FROM Hotel__c WHERE Id = :id];
    }

    public PageReference save() {
        try {
           system.debug('Custom Controller Save call...Entering..');
            list<Hotel__c> hList = new list<Hotel__c>();
            hList.add(hotel); 
            
            geocode_Methods.updateGeocodes(hList);
           
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        // After successful Save, navigate to the default view page
        system.debug('Custom Controller Save call...Exiting..');
        PageReference redirectSuccess = new ApexPages.StandardController(hotel).view();
        return (redirectSuccess);
    }
    
     public PageReference Cancel()
     {
       return new PageReference('/a0M/o'); 
     }
  
    
}