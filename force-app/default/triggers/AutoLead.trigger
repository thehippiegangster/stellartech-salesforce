trigger AutoLead on Case(after insert) {
    case c=trigger.new[0];
    if(c.ContactId==null && c.SuppliedEmail!=null) {
        list<lead> l=[select id,Email from lead where email =: c.SuppliedEmail];

        if(l.size()==0 && c.SuppliedName !=null) {
            lead caseLead=new lead(lastname=c.SuppliedName, Email=c.SuppliedEmail, Company=c.SuppliedEmail, LeadSource='Case');
            insert caseLead;
        }
    }
}