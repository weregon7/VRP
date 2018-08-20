@isTest(seeAllData=true)


private class BuyTest {
    @isTest

    static void adding() {

        PageReference pageRef = Page.Buy;
        system.test.setCurrentPageReference(pageRef);
        Product_Table__c product = [SELECT Id, Name, Units_Available__c FROM Product_Table__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', product.id);

        Buy test = new Buy();
        test.unitsAvailable = product.Units_Available__c;
        test.units = 1000;
        test.adding();
        System.assertEquals('This amount of items are not available now', ApexPages.getMessages().get(0).getSummary());
        test.units = 1;
        test.firstName ='vasya';
        test.lastName='asd';
        test.email= 'weregon7@gmail.com';
        test.adding();
        Contact contact = [SELECT FirstName, LastName, Email FROM Contact WHERE Email = :test.email limit 1];
        System.assertEquals('vasya', contact.FirstName);
        test.email = 'ookljkflf@mail.ru';
        test.adding();
        Contact newContact = [SELECT FirstName, Email FROM Contact WHERE Email = :test.email limit 1];
        System.assertEquals('ookljkflf@mail.ru', newContact.Email);
        System.assertEquals('vasya', contact.FirstName);
        Order_Table__c table = [SELECT Id, Product__c FROM Order_Table__c WHERE Product__c =: ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        System.assertEquals(table.Product__c, product.id);
        System.assertEquals('Thanks for your order', ApexPages.getMessages().get(1).getSummary());

    }
}