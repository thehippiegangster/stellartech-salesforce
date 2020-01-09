trigger IncomingCaseTrigger on Case (before insert, before update) {
	Id conId;
    Id servContrId;
    Id entlId;
    IncomingCaseTriggerHandler handler = new  IncomingCaseTriggerHandler();
    
    for (Case c : Trigger.new) {
        conId=c.ContactId;
        //servContrId=c.Service_Contract__c;
        //entlId = c.EntitlementId;
    }
    if(conId==NULL){
        // Call method for create new contact, attach to account and case
        handler.createContactFromCase(Trigger.new); 
        //Call method to add default service contract on account to the case
        /*if(servContrId==NULL){
            handler.addDefaultServiceContract(Trigger.new);
        }
        //Call method to add default entitlment from service contract to the case
        if(entlId==NULL){
            handler.addDefaultEntitlement(Trigger.new); 
        }*/
            

    } /*else if (conId!=NULL){
        //Call method to add default service contract on account to the case
        if(servContrId==NULL){
           handler.addDefaultServiceContract(Trigger.new);
            //Call method to add default entitlment from service contract to the case
            
        }
    }
    if(entlId==NULL){
    	handler.addDefaultEntitlement(Trigger.new); 
    }*/
}