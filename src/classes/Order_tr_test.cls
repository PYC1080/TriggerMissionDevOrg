/**
 * Created by pyc on 2021-08-15.
 */

@IsTest
private class Order_tr_test {
    @TestSetup
    static void order_setup(){
        //Account 생성
        Account objAccount = new Account(Name = 'Trigger_Test_Account');
        try{
            insert objAccount;
        }catch(Exception e){
            objAccount.addError('objAccount insert Error : '+e);
        }
        //Opportunity 생성
        Opportunity objOpti = new Opportunity(
                Name='Trigger_Test_Opti',
                StageName = 'Prospecting',
                CloseDate = System.today().addMonths(6),
                AccountId = objAccount.Id,
                isApproved__c = true
        );
        try{
            insert objOpti;
        }catch(Exception e){
            objOpti.addError('objOpti insert Error : '+e);
        }
        //Product2 생성
        Product2 objProduct2 = new Product2(
                Name = 'Trigger_Test_Product2 HW',
                Family = 'Hardware',
                ProductCode = 'Hardware'
        );
        try{
            insert objProduct2;
        }catch(Exception e){
            objProduct2.addError('objProduct2 insert Error : '+e);
        }
        //PriceBook 생성성
        Pricebook2 objPricebook2 = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
        );
        try{
            insert objPricebook2;
        }catch(Exception e){
            objPricebook2.addError('objPricebook2 insert Error : '+e);
        }
        //Contract 생성
        Contract objContract = new Contract(
                Name = 'Trigger_Test_Contract',
                AccountId = objAccount.Id,
                Pricebook2Id = objPricebook2.Id,
                StartDate = Date.newInstance(
                        Date.today().year(),
                        Date.today().month(),
                        Date.today().day()
                ),
                ContractTerm = 12
        );
        try{
            insert objContract;
        }catch(Exception e){
            objContract.addError('objContract insert Error : '+e);
        }
        //PricebookEntry 생성
        PricebookEntry objPricebookEntry = new PricebookEntry(
                Pricebook2Id = objPricebook2.Id,
                Product2Id = objProduct2.Id,
                UnitPrice = 10000,
                IsActive = true
        );
        try{
            insert objPricebookEntry;
        }catch(Exception e){
            objPricebookEntry.addError('objPricebookEntry insert Error : '+e);
        }
        //OpportunityLineItem 생성
        OpportunityLineItem objOptiLineItem = new OpportunityLineItem(
                PricebookEntryId = objPricebookEntry.Id,
                Product2Id = objProduct2.Id,
                OpportunityId = objOpti.Id,
                Quantity = 10 ,
                TotalPrice = objPricebookEntry.UnitPrice * (10)
        );
        try{
            insert objOptiLineItem;
        }catch(Exception e){
            objOptiLineItem.addError('objOptiLineItem insert Error : '+e);
        }
        //Order 생성
        Order objOrder = new Order(
                Name = 'Trigger_Test_Order',
                ContractId = objContract.Id,
                Pricebook2Id = objPricebook2.Id,
                Status = 'Draft',
                AccountId = objAccount.Id,
                OpportunityId = objOpti.Id,
                EffectiveDate = Date.newInstance(
                        Date.today().year(),
                        Date.today().month(),
                        Date.today().day()
                )
        );
        try{
            insert objOrder;
        }catch(Exception e){
            objOrder.addError('objOrder insert Error : '+e);
        }
        //OrderItem 생성
        OrderItem objOrderItem = new OrderItem(
                PricebookEntryId = objPricebookEntry.Id,
                Product2Id = objProduct2.Id,
                OrderId = objOrder.Id,
                UnitPrice = objOptiLineItem.TotalPrice,
                Quantity = objOptiLineItem.Quantity
        );
        try{
            insert objOrderItem;
        }catch(Exception e){
            objOrderItem.addError('objOrderItem insert Error : '+e);
        }
        //Asset 생성
        Asset objAsset = new Asset(
                Name = 'Trigger_Test_Asset',
                AccountId = objAccount.Id,
                Product2Id = objProduct2.Id
        );
        try{
            insert objAsset;
        }catch(Exception e){
            objAsset.addError('objAsset insert Error : '+e);
        }
    }
    @IsTest
    static void testBehavior() {
        Contract contract = [
                SELECT Id
                FROM  Contract
                WHERE Name = 'Trigger_Test_Contract'
        ];
        contract.Status = 'Activated';
        update contract;

        Order order = [
                SELECT Id
                FROM  Order
                WHERE Name = 'Trigger_Test_Order'
        ];
        order.Status = 'Activated';
        update order;
    }
}