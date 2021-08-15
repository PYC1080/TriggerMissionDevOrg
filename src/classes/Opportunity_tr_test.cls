/**
 * Created by pyc on 2021-08-15.
 */

@IsTest
private class Opportunity_tr_test {
    @TestSetup
    static void opti_setup(){
        //Account 생성
        Account objAccount = new Account(Name = 'Trigger_Test_Account');
        try{
            insert objAccount;
        }catch(Exception e){
            objAccount.addError('objAccount insert Error : '+e);
        }
        //Opportunity 생성
        List<Opportunity> listOpti = new List<Opportunity>();
        for(Integer i=0; i<5; i++){
            Opportunity objOpti = new Opportunity(
                    Name='Trigger_Test_Opti 0'+(i+1),
                    StageName = 'Prospecting',
                    CloseDate = System.today().addMonths(6),
                    AccountId = objAccount.Id,
                    isApproved__c = true
            );
            listOpti.add(objOpti);
        }
        insert listOpti;
        //Product2 생성
        List<Product2> listProduct2s = new List<Product2>();
        //Hardware 4개
        for(Integer i=0; i<4; i++){
            Product2 objProduct2 = new Product2(
                    Name = 'Trigger_Test_Product2 HW0'+(i+1),
                    Family = 'Hardware',
                    ProductCode = 'Hardware 0'+(i+1)
            );
            listProduct2s.add(objProduct2);
        }
        //Software 1개
        listProduct2s.add(
          new Product2(
                  Name = 'Trigger_Test_Product2_SW01',
                  Family = 'Software',
                  ProductCode = 'Software 01'
          )
        );
        insert listProduct2s;
        //PriceBook 생성성
        Pricebook2 objPricebook2 = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
        );
        try{
            insert objPricebook2;
        }catch(Exception e){
            objPricebook2.addError('objPricebook2 update Error : '+e);
        }
        //Contract 생성
        List<Contract> listContract = new List<Contract>();
        for(Integer i=0; i<listOpti.size(); i++){
            Contract objContract = new Contract(
                    AccountId = objAccount.Id,
                    Pricebook2Id = objPricebook2.Id,
                    StartDate = Date.newInstance(
                            Date.today().year(),
                            Date.today().month(),
                            Date.today().day()
                    ),
                    ContractTerm = 12
            );
            listContract.add(objContract);
        }
        insert listContract;
        //PricebookEntry 생성
        List<PricebookEntry> listPricebookEntry = new List<PricebookEntry>();
        for(Integer i=0; i<listProduct2s.size(); i++){
            PricebookEntry objPricebookEntry = new PricebookEntry(
                    Pricebook2Id = objPricebook2.Id,
                    Product2Id = listProduct2s[i].Id,
                    UnitPrice = 10000+10000*i,
                    IsActive = true
            );
            listPricebookEntry.add(objPricebookEntry);
        }
        insert listPricebookEntry;
        //OpportunityLineItem 생성
        List<OpportunityLineItem> listOptiLineItems = new List<OpportunityLineItem>();
        for(Integer i=0; i<listOpti.size();i++){
            OpportunityLineItem objOptiLineItem = new OpportunityLineItem(
                    PricebookEntryId = listPricebookEntry[i].Id,
                    Product2Id = listProduct2s[i].Id,
                    OpportunityId = listOpti[i].Id,
                    Quantity = 10 + 10*i,
                    TotalPrice = listPricebookEntry[i].UnitPrice * (10+10*i)
            );
            listOptiLineItems.add(objOptiLineItem);
        }
        insert listOptiLineItems;
   }
    @IsTest
    static void testBehavior_01() {
        Opportunity opti1 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 01'
        ];
        opti1.StageName = 'Closed Won';
        update  opti1;
        Opportunity opti2 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 02'
        ];
        opti2.StageName = 'Closed Won';
        update  opti2;
        Opportunity opti3 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 03'
        ];
        opti3.StageName = 'Closed Won';
        update  opti3;
        Opportunity opti4 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 04'
        ];
        opti4.StageName = 'Closed Won';
        update  opti4;
        Opportunity opti5 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 05'
        ];
        opti5.StageName = 'Closed Won';
        update  opti5;
    }
    @IsTest
    static void testBehavior_02() {
        Opportunity opti1 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 01'
        ];
        Opportunity opti2 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 02'
        ];
        update  opti2;
        Opportunity opti3 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 03'
        ];
        Opportunity opti4 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 04'
        ];
        Opportunity opti5 = [
                SELECT Id
                FROM Opportunity
                WHERE  Name = 'Trigger_Test_Opti 05'
        ];

        opti1.isApproved__c = false;
        opti2.isApproved__c = false;
        opti3.isApproved__c = false;
        opti4.isApproved__c = false;
        opti5.isApproved__c = false;

        update  opti1;
        update  opti2;
        update  opti3;
        update  opti4;
        update  opti5;

        opti1.StageName = 'Closed Won';
        opti2.StageName = 'Closed Won';
        opti3.StageName = 'Closed Won';
        opti4.StageName = 'Closed Won';
        opti5.StageName = 'Closed Won';

        update  opti1;
        update  opti2;
        update  opti3;
        update  opti4;
        update  opti5;
    }
}