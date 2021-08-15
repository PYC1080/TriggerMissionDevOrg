/**
 * Created by 박예찬 on 2021-08-12.
 */

trigger Order on Order (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Map<Id, Order> mapOrder = Trigger.oldMap;
    for (Order order : Trigger.New){
        if(order.Status=='Activated' && mapOrder.get(order.Id).Status!='Activated'){
            new Order_tr().run();
        }
    }

}