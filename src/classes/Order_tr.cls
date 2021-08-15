/**
 * Created by 박예찬 on 2021-08-12.
 */

public with sharing class Order_tr extends TriggerHandler{

    public Order_tr(){
        listNew = (List<Order>) trigger.new;
        mapOld = (Map<Id, Order>) trigger.oldMap;
        listOld = (List<Order>) trigger.old;
    }

    private List<Order> listNew{ get; set; }
    private List<Order> listOld{ get; set; }
    private Map<Id,Order> mapOld{ get; set;}

    public override void afterUpdate(){
        updateOrder();
    }

    private void updateOrder(){
        System.debug('listNew : '+listNew);
        System.debug('listOld : '+listOld);

        List<OrderItem> listOrderItem = [
                SELECT Id,Product2Id,OrderId,OrderItemNumber
                FROM OrderItem
                WHERE OrderId=: listNew[0].Id
        ];
        System.debug('OrderItem : '+listOrderItem);
        Set<Id> productIds = new Set<Id>();
        if(listOrderItem !=null){
            for(OrderItem orderItem : listOrderItem){
                productIds.add(orderItem.Product2Id);
            }
        }
        System.debug('productIds : '+productIds);

        List<Asset> listAsset = [
          SELECT Id, Status, Product2Id, AccountId,OwnerId,SerialNumber,Name
          FROM  Asset
          WHERE Product2Id =: productIds AND AccountId =: listNew[0].AccountId
        ];
        System.debug('Asset : '+listAsset);
        if(listAsset != null){
            for(Asset asset : listAsset){
                System.debug(asset.Status);
                asset.Status='Shipped';
            }
            update listAsset;
        }
    }
}