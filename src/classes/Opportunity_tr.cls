/**
 * Created by 박예찬 on 2021-08-12.
 */

public with sharing class Opportunity_tr extends TriggerHandler{

    public Opportunity_tr(){
        listNew = (List<Opportunity>) trigger.new;
        mapOld = (Map<Id, Opportunity>) trigger.oldMap;
        listOld = (List<Opportunity>) trigger.old;
    }

    public override void afterUpdate(){
        updateOpti();
    }

    private List<Opportunity> listNew{ get; set; }
    private List<Opportunity> listOld{ get; set; }
    private Map<Id,Opportunity> mapOld{ get; set;}

   private void updateOpti(){

       List<OpportunityLineItem> listOptiLineItem = [
               SELECT Id, OpportunityId, Product2Id, Product2.Name, Product2.Family, Product2.ProductCode, UnitPrice, Quantity, TotalPrice, ProductCode,PricebookEntryId
               FROM OpportunityLineItem
               WHERE OpportunityId =: listNew[0].Id
               AND PricebookEntryId != NULL
       ];
       System.debug(listOptiLineItem);
       //Contract, Order, OrderItem, Asset 생성
       List<Contract> listContract = new List<Contract>();
       List<Order> listOrder = new List<Order>();
       List<OrderItem> listOrderItem = new List<OrderItem>();
       List<Asset> listAsset = new List<Asset>();

       for(Opportunity opti : listNew){
           //Contract 생성
           Contract objContract = new Contract(
                   AccountId = opti.AccountId,
                   Pricebook2Id = opti.Pricebook2Id,
                   StartDate = Date.newInstance(
                           Date.today().year(),
                           Date.today().month(),
                           Date.today().day()
                   ),
                   ContractTerm =12
           );
           listContract.add(objContract);
           //Order에서 Contract의 id를 사용
           insert listContract;
            System.debug(objContract.Id);
//           Order 생성
           Order objOrder = new Order(
                   ContractId = objContract.Id,
                   Pricebook2Id = objContract.Pricebook2Id,
                   Status = 'Draft',
                   AccountId = opti.AccountId,
                   OpportunityId = opti.Id,
                   EffectiveDate = Date.newInstance(
                           Date.today().year(),
                           Date.today().month(),
                           Date.today().day()
                   )
           );
           listOrder.add(objOrder);
           // OderItem에서 Order.Id 번호를 사용
           insert listOrder;
//           OrderItem 및 Asset 생성
           for(OpportunityLineItem optiLineItem : listOptiLineItem){
               if(optiLineItem.Product2.Family =='Hardware'){
                   OrderItem objOrderItem = new OrderItem(
                           PricebookEntryId = optiLineItem.PricebookEntryId,
                           Product2Id = optiLineItem.Product2Id,
                           OrderId = objOrder.Id,
                           Quantity = optiLineItem.Quantity,
                           UnitPrice = optiLineItem.UnitPrice
                   );
                   listOrderItem.add(objOrderItem);

                   Asset objAsset = new Asset(
                           AccountId = opti.AccountId,
                           Product2Id = optiLineItem.Product2Id,
                           Name = optiLineItem.Product2.Name+'_'+objOrder.ContractId,
                           SerialNumber = optiLineItem.ProductCode+'_'+objOrder.ContractId,
                           Quantity = optiLineItem.Quantity,
                           Status = 'Purchased',
                           Price = optiLineItem.TotalPrice
                   );
                   listAsset.add(objAsset);

               }else if(optiLineItem.Product2.Family=='Software'){
                   Asset objAsset = new Asset(
                           AccountId = opti.AccountId,
                           Product2Id = optiLineItem.Product2Id,
                           Name = optiLineItem.Product2.Name+'_'+objOrder.ContractId,
                           SerialNumber = optiLineItem.ProductCode+'_'+objOrder.ContractId,
                           Quantity = optiLineItem.Quantity,
                           Status = 'Registered',
                           Price = optiLineItem.TotalPrice
                   );
                   listAsset.add(objAsset);
               }
           }
       }
       // 추가할 값이 있는 경우에만 해당 상태를 변경

       if(listOrderItem.size()>0){
           insert listOrderItem;
           System.debug('OrderItem : '+listOrderItem);
       }
       if(listAsset.size()>0){
           insert listAsset;
           System.debug('Asset : '+listAsset);
       }
   }

}