trigger CompleteAssignResourceMilestone on Case (after update) {
	if (UserInfo.getUserType() == 'Standard'){
        DateTime completionDate = System.now(); 
            List<Id> updateCases = new List<Id>();
            for (Case c : Trigger.new){
                    if (((c.isClosed == false)||(c.Status == 'technician assigned'))&&((c.OwnerId 
                        != NULL)))
        updateCases.add(c.Id);
        }
    if (updateCases.isEmpty() == false)
        milestoneUtils.completeMilestone(updateCases, 'Assign a Resource', completionDate);
    }
}