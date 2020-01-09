trigger CompleteImplementResolutionMilestone on Case (before insert) {
    if (UserInfo.getUserType() == 'Standard'){
        DateTime completionDate = System.now(); 
            List<Id> updateCases = new List<Id>();
            for (Case c : Trigger.new){
                if ((c.Status=='Closed'))
                    updateCases.add(c.Id);
        }
    if (updateCases.isEmpty() == false)
        milestoneUtils.completeMilestone(updateCases, 'Implement Resolution', completionDate);
    }
}