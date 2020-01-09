trigger DefaultEntitlement on Case (Before Insert, Before Update) {
   /* //Set<Id> contactIds = new Set<Id>();
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
        for (Case c : Trigger.new) {
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
            for(Case c : Trigger.new){
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
        }*/
    }