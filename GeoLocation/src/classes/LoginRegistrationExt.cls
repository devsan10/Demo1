public with sharing class LoginRegistrationExt {
	Registration__c reg;
	public LoginRegistrationExt(ApexPages.standardController stdConrl) {
		reg = new Registration__c();
		reg = (Registration__c)stdConrl.getRecord();
	}
	
	public PageReference save() {
		PageReference pr;//default value: null
		if(reg.Password__c != reg.Confirm_Password__c) {
			reg.addError('Password and Confirm Password are not matched');
		}
		else {
			try {
				insert reg;
				pr = Page.LoginSuccess;
			}
			Catch(Exception e) {
				String errMsg = e.getMessage();
				if(errMsg.contains('DUPLICATE_VALUE') && errMsg.contains('Email__c'))
					errMsg = 'Duplicate Email Id.';
				Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.Error,errMsg));
			}
		}
		return pr;
	}
}