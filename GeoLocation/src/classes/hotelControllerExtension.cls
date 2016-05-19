public with sharing class hotelControllerExtension {
   ApexPages.StandardController controller;
   Hotel__c hotel;
   PageReference page;
   Id recordId;
   
   public hotelControllerExtension(ApexPages.StandardController stdController) {
    this.controller = stdController;
    this.hotel = (Hotel__c)stdController.getrecord();
    this.page = ApexPages.currentPage();
    this.recordId = page.getParameters().get('id');  
}

public PageReference save() {
    list<Hotel__c> hList = new list<Hotel__c>();
    hList.add(hotel); 
    geocode_Methods.updateGeocodes(hList);       
    this.controller.save();
    
    PageReference newPage = New PageReference('/'+ this.recordId);
      newPage.setRedirect(true);
    return newPage;
 }
 
    
}