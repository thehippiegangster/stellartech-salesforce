trigger DefaultServiceContractToCaseTrigger on Case (before insert, before update) {
    Id acctId;
    Id conId;
    
    for (Case c : Trigger.new) {
        conId=c.ContactId;
    }
    
    List<Contact> acct = [SELECT id, AccountId FROM Contact WHERE Id=:conId LIMIT 1];
    if(acct.size()>0){
        acctId=acct[0].AccountId;
    }
    List<ServiceContract> accountContracts = [SELECT id, accountId, Default__c FROM ServiceContract WHERE accountId=:acctId];
    
    for (Case c : Trigger.new) {
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