/**
 * Created by pyc on 2021-08-15.
 */

@IsTest
private class Order_tr_test {
    @TestSetup
    static void order_setup(){
        //Account 생성
        Account objAccount = new Account(Name = 'Trigger_Test_Account');
        insert objAccount;
        //Opportunity 생성
        Opportunity objOpti = new Opportunity(
                Name='Trigger_Test_Opti',
                StageName = 'Prospecting',
                CloseDate = System.today().addMonths(6),
                AccountId = objAccount.Id,
                isApproved__c = true
        );
        insert objOpti;
        //Product2 생성
        Product2 objProduct2 = new Product2(
                Name = 'Trigger_Test_Product2 HW',
                Family = 'Hardware',
                ProductCode = 'Hardware'
        );
        insert objProduct2;
        //PriceBook 생성성
        Pricebook2 objPricebook2 = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
        );
        update objPricebook2;
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
        insert objContract;
        //PricebookEntry 생성
        PricebookEntry objPricebookEntry = new PricebookEntry(
                Pricebook2Id = objPricebook2.Id,
                Product2Id = objProduct2.Id,
                UnitPrice = 10000,
                IsActive = true
        );
        insert objPricebookEntry;
        //OpportunityLineItem 생성
        OpportunityLineItem objOptiLineItem = new OpportunityLineItem(
                PricebookEntryId = objPricebookEntry.Id,
                Product2Id = objProduct2.Id,
                OpportunityId = objOpti.Id,
                Quantity = 10 ,
                TotalPrice = objPricebookEntry.UnitPrice * (10)
        );
        insert objOptiLineItem;
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
        insert objOrder;
        //OrderItem 생성
        OrderItem objOrderItem = new OrderItem(
                PricebookEntryId = objPricebookEntry.Id,
                Product2Id = objProduct2.Id,
                OrderId = objOrder.Id,
                UnitPrice = objOptiLineItem.TotalPrice,
                Quantity = objOptiLineItem.Quantity
        );
        insert objOrderItem;
        //Asset 생성
        Asset objAsset = new Asset(
                Name = 'Trigger_Test_Asset',
                AccountId = objAccount.Id,
                Product2Id = objProduct2.Id
        );
        insert objAsset;
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