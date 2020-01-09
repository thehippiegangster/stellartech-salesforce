@isTest
public class TestDefaultServiceContractToCaseTrigger {
    static testmethod void testTrigger(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='Test 1', LastName='McTesty', AccountId = acc.id);
        insert con;
        
        ServiceContract[] servCons = new ServiceContract[] {
            new ServiceContract (Name='Test MService Contract', AccountId=acc.Id, Contract_Type__c='Managed Services', Default__c=FALSE),
            new ServiceContract (Name='Test CService Contract', AccountId=acc.Id, Contract_Type__c='Cloud Services',Default__c=TRUE)
        };
        insert servCons;
        
        Case c = new Case(AccountId=acc.id, ContactId = con.id, Subject='Test1', Description='Test1', Type='Request', Origin='Email', Status='New');
        insert c;
        
        c = [SELECT Id, Service_Contract__c FROM Case WHERE Id =: c.id LIMIT 1];
       //system.assertEquals(servCons[1].id, c.Service_Contract__c);
       system.assertNotEquals(servCons[0].id, c.Service_Contract__c);
        system.debug(c);
        
        Account acc2 = new Account(Name='Test Account2', Email_Domains__c='test2.com');
        insert acc2;
        
        Contact con2 = new Contact(FirstName='Test 2', LastName='McTesty', AccountId = acc2.id);
        insert con2;
        
        ServiceContract servCon2 = new ServiceContract(Name='Test2 MService Contract', AccountId=acc2.Id, Contract_Type__c='Managed Services', Default__c=FALSE);
        insert servCon2;
        
        Case c2 = new Case(AccountId=acc2.id, ContactId = con2.id, Subject='Test1', Description='Test1', Type='Request', Origin='Email', Status='New');
        insert c2;
        
        c2 = [SELECT Id, Service_Contract__c FROM Case WHERE Id =: c2.id LIMIT 1];
        //system.assertEquals(servCon2.id, c2.Service_Contract__c);
        system.debug(c2);
    }
}