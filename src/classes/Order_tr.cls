/**
 * Created by 박예찬 on 2021-08-12.
 */

public with sharing class Order_tr extends TriggerHandler{

    public Order_tr(){
        listNew = (List<Order>) trigger.new;
    }

    private List<Order> listNew{ get; set; }

    public override void afterUpdate(){
        updateOrder();
    }

    private void updateOrder(){
        List<OrderItem> listOrderItem = [
                SELECT Id,Product2Id,OrderId,OrderItemNumber
                FROM OrderItem
                WHERE OrderId=: listNew[0].Id
        ];
        Set<Id> productIds = new Set<Id>();
        if(listOrderItem !=null){
            for(OrderItem orderItem : listOrderItem){
                productIds.add(orderItem.Product2Id);
            }
        }
        List<Asset> listAsset = [
          SELECT Id, Status, Product2Id, AccountId,OwnerId,SerialNumber,Name
          FROM  Asset
          WHERE Product2Id =: productIds AND AccountId =: listNew[0].AccountId
        ];
        System.debug('Asset : '+listAsset);
        if(listAsset != null){
            for(Asset asset : listAsset){
                asset.Status='Shipped';
            }
            update listAsset;
        }
    }
}