public class IncomingCaseTriggerHandler {
	
    //method to create a contact if finds matching email domain on an account
    public void createContactFromCase(List<Case> caseList){
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
        
        for (Case caseObj:caseList) {
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
                
            
        List<Contact> newContacts = emailToContactMap.values();
        insert newContacts;
        
        for (Case caseObj:casesToUpdate) {
            Contact newContact = emailToContactMap.get(caseObj.SuppliedEmail);
            caseObj.ContactId = newContact.Id;
            caseObj.AccountId = newContact.AccountId;
        }
        update casesToUpdate;
    }
}   
    /*public void addDefaultServiceContract(List<Case> caseList){
        Id acctId;
    	Id conId;
    
        for (Case c : caseList) {
            conId=c.ContactId;
        }
        
        List<Contact> acct = [SELECT id, AccountId FROM Contact WHERE Id=:conId LIMIT 1];
        if(acct.size()>0){
            acctId=acct[0].AccountId;
        }
        List<ServiceContract> accountContracts = [SELECT id, accountId, Default__c FROM ServiceContract WHERE accountId=:acctId];
        
        for (Case c : caseList) {
            if(c.ContactId!=NULL && c.Service_Contract__c==NULL && c.Status=='New'){
                if(accountContracts.size() > 1){
                    for (ServiceContract sc:accountContracts){
                        if(sc.Default__c==TRUE){
                            c.Service_Contract__c=sc.id;
                        }
                    }
                } else {
                    for (ServiceContract sc:accountContracts){
                        c.Service_Contract__c=sc.id;
                    }
                }
            }
        }
    }
    
    public void addDefaultEntitlement(List<Case> caseList){
     
        //Set<Id> contactIds = new Set<Id>();
        Id acctId;
        Id cloudRequestEntl;  
        Id cloudIncidentEntl;
        Id cloudProdDownEntl;
        Id managedRequestEntl;
        Id managedIncidentEntl;
        Id managedProdDownEntl;
        Id cloudServContId;
        Id managedServContId;

    
    
            //get case account Id
        for (Case c : caseList) {
            //contactIds.add(c.ContactId);
            acctId=c.AccountId;
        }
        //get cloud service contract Id that matches case account
        List <ServiceContract> cloudServConts = [SELECT id, AccountId, Contract_Type__C 
                                               FROM ServiceContract  
                                               WHERE AccountId =:acctId and Contract_Type__c='Cloud Services' LIMIT 1];
            if(cloudServConts.size()>0){
              cloudServContId = cloudServConts.get(0).id;
            }
        //get managed service contract Id that matches case account  
        List <ServiceContract> managedServConts = [SELECT id, AccountId, Contract_Type__C 
                                               FROM ServiceContract 
                                               WHERE AccountId =:acctId and Contract_Type__c='Managed Services' LIMIT 1];
            if(managedServConts.size()>0){
              managedServContId = managedServConts.get(0).id;
            }
        //get account entitlements
        List <Entitlement> entls = [Select Name, StartDate, Id, EndDate, 
            AccountId, Service_Type__c
            From Entitlement 
            Where AccountId =:acctId And EndDate >= Today 
            And StartDate <= Today];
        
        //get entitlement ids that match account
        for(Entitlement e:entls){
            switch on e.Service_Type__c {
                when 'Orion Cloud: Request'{
                    cloudRequestEntl=e.id;
                }
                when 'Orion Cloud: Incident'{
                    cloudIncidentEntl=e.id;
                }
                when 'Orion Cloud: Prod Down'{
                    cloudProdDownEntl=e.id;
                }
                when 'Managed Services: Request'{
                    managedRequestEntl=e.id;
                }
                when 'Managed Services: Incident'{
                    managedIncidentEntl=e.id;
                }
                when 'Managed Services: Prod Down'{
                    managedProdDownEntl=e.id;
                }
            }
        }
    
        
        //attach entitlement to case based off case detail logic
        if(entls.isEmpty()==false){
            for(Case c : caseList){
                if(c.EntitlementId == null && c.AccountId != null){
                    //cloud service contract
                    if (c.Service_Contract__c==cloudServContId){
                        switch on c.Type {
                            when 'Request'{
                                c.EntitlementId=cloudRequestEntl;
                                //break;
                            }
                            when 'Incident'{
                                c.EntitlementId = cloudIncidentEntl;
                                //break;
                            }
                            when 'Production Down'{
                                c.EntitlementId = cloudProdDownEntl;
                            }
                        }
                    }
                    //managed service contract
                    else if (c.Service_Contract__c==managedServContId){
                        switch on c.Type {
                            when 'Request'{
                                c.EntitlementId=managedRequestEntl;
                                //break;
                            }
                            when 'Incident'{
                                c.EntitlementId = managedIncidentEntl;
                                //break;
                            }
                            when 'Production Down'{
                                c.EntitlementId = managedProdDownEntl;
                            }
                        }  
                    } 
                }
            } 
        }
    }*/