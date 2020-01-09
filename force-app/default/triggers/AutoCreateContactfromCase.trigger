trigger AutoCreateContactfromCase on Case (before insert) {
    List<Account> listAccounts = [SELECT Id, Email_Domains__c FROM Account WHERE Email_Domains__c != NULL];

    
    Map<Id, String> emailDomains = new Map<Id, String>();
    //List<Id> acctIds = new List<Id>();
    for(Account a:listAccounts){
        for (String domain : a.Email_Domains__c.split(',')){
            String trimmedDomain = domain.trim();
            if(trimmedDomain.length() > 0){
                emailDomains.put(a.id, trimmedDomain);
                //acctIds.add(a.id);
            }
        }
    }
    Map<String,Contact> emailToContactMap = new Map<String,Contact>();
    List<Case> casesToUpdate = new List<Case>();
    
    for (Case caseObj:Trigger.new) {
        if (caseObj.ContactId==null &&
                caseObj.SuppliedName!=null &&
                caseObj.SuppliedEmail!=null &&             
                caseObj.Email_Domain__c!=null) {
                    system.debug('this logic works');
            //List <Account> matchedAccounts = [SELECT Id, Website, Additional_Domains__c FROM Account WHERE Website ];
            for (id accId : emailDomains.keySet()){
                system.debug(accId);
                String domain = emailDomains.get(accId);
                system.debug(domain);
                    if (domain==caseObj.Email_Domain__c){
                       String[] nameParts = caseObj.SuppliedName.split(' ',2);
                        if (nameParts.size() == 2)
                        {
                            Contact cont = new Contact(FirstName=nameParts[0],
                                                        LastName=nameParts[1],
                                                        Email=caseObj.SuppliedEmail,
                                                        AccountId=accId);
                            emailToContactMap.put(caseObj.SuppliedEmail,cont);
                            casesToUpdate.add(caseObj);
                        } 
                    }
                } 
            } 
        }
            
    //}
        
    List<Contact> newContacts = emailToContactMap.values();
    insert newContacts;
    
    for (Case caseObj:casesToUpdate) {
        Contact newContact = emailToContactMap.get(caseObj.SuppliedEmail);
        caseObj.ContactId = newContact.Id;
        caseObj.AccountId = newContact.AccountId;
    }
}