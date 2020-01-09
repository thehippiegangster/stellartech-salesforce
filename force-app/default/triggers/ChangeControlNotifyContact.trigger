trigger ChangeControlNotifyContact on Change_Control__c (after update) {
	
    public String[] bccAddresses = new String[]{};
    //get active cloud service contracts
	List<ServiceContract> servContracts = [SELECT Id, Contact.Email, Orion_Data_Center__c, Contract_Type__c, Status FROM ServiceContract WHERE Contract_Type__c='Cloud Services' AND Status='Active'];
    //get email template
    EmailTemplate et = [Select Id from EmailTemplate where Name = 'Change_Notification'];
    
   //start trigger
    for(Change_Control__c cc : Trigger.New){
        //verifies exec approval is not blank and status is correct
        if (cc.Executive_Approval__c != NULL && cc.Status__c == 'Submitted for Approval'){
            for(ServiceContract sc : servContracts){
                //get list of data center from service contract and put into individual strings
                if(sc.Orion_Data_Center__c!=NULL){
                	String[] dataCenter = sc.Orion_Data_Center__c.split(';');
                
                    for (String dc : dataCenter){
                        if(cc.Orion_Data_Center__c.Contains(dc)){
                            if(sc.Contact.Email!=NULL){
                               //add contact email from service contract to bcc list to send
                                bccAddresses.add(sc.Contact.Email); 
                        }
                    }
                }
        	}
        } 
	}
        if (bccAddresses!=NULL){    
            // First, reserve email capacity for the current Apex transaction to ensure
            // that we won't exceed our daily email limits when sending email after
            // the current transaction is committed.
            Messaging.reserveSingleEmailCapacity(4);
            
            // Processes and actions involved in the Apex transaction occur next,
            // which conclude with sending a single email.
            
            // Now create a new single email message object
            // that will send out a single email to the addresses in the To, CC & BCC list.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
       
            // Assign the addresses for the To and CC lists to the mail object.
            mail.toAddresses = new String[] {'orion@stellar.tech'};
            mail.setBccAddresses(bccAddresses);
            
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo('support@stellar.tech');
            
            // Specify the name used as the display name.
            //mail.setSenderDisplayName('Stellar Support');
            
            // Specify the subject line for your email address.
            mail.setSubject('Change Notification : ' + Change_Control__c.Name);
            
            // Set to True if you want to BCC yourself on the email.
            mail.setBccSender(false);
            
            // Optionally append the salesforce.com email signature to the email.
            // The email address of the user executing the Apex Code will be used.
            mail.setUseSignature(false);
            
            // Specify the text content of the email.
            mail.setTemplateId(et.Id);
    
            //mail.setPlainTextBody('Your Case: ' + case.Id +' has been created.');
            
            //mail.setHtmlBody('Your case:<b> ' + case.Id +' </b>has been created.<p>'+
                 //'To view your case <a href=https://yourInstance.salesforce.com/'+case.Id+'>click here.</a>');
            
            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
	}
}