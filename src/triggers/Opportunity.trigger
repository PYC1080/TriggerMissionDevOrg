/**
 * Created by 박예찬 on 2021-08-12.
 */

trigger Opportunity on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Map<Id, Opportunity> mapOpti = Trigger.oldMap;

    for(Opportunity opp : Trigger.New){
        if(opp.StageName == 'Closed Won' && mapOpti.get(opp.Id).StageName !='Closed Won'){
            if (opp.isApproved__c==True){
                new Opportunity_tr().run();
            }else{
                opp.addError('IsApproved`s value is not True');
            }
        }
    }
}