public class Buy {

    public String firstName { set; get; }
    public String lastName { set; get; }
    public String email { set; get; }
    public Double unitsAvailable { set; get; }
    public Integer units { set; get; }
    public Double totalCost { set; get; }
    public List <Contact> contact { set; get; }
    public List <Product_Table__c> product { set; get; }
    public List <Order_Table__c> orderTableData { set; get; }

    /* get data about Current Product*/

    public Buy() {
        product = [
                SELECT Name, Image_URL__c, Unit_Price__c, Product_Description__c, Title__c, Units_Available__c
                FROM Product_Table__c
                WHERE Id = :ApexPages.currentPage().getParameters().get('id')
        ];

        unitsAvailable = product[0].Units_Available__c;
    }

    public void adding() {

        /* validation rule for available amount of products in Product Table */

        if ((unitsAvailable - units) < 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'This amount of items are not available now'));
        } else {
            /*update data about contact */
        if (email == '') {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'The Last Name field is required'));
            } else {
            contact = [SELECT FirstName, LastName, Email FROM Contact WHERE Email = :email LIMIT 1];
            if (contact.size() > 0) {
                contact[0].FirstName = firstName;
                contact[0].LastName = lastName;
                update contact;
            } else { /*Add new contact */
                Contact newContact = new Contact(FirstName = firstName, LastName = lastName, Email = email);
                contact.add(newContact);
                insert contact[0];
            }
            /* Add data in Order Table */
            contact = [SELECT ID FROM Contact WHERE Email = :email LIMIT 1];
            totalCost = units * Product[0].Unit_Price__c; // Total price
            orderTableData = [SELECT Product__c, Units__c, Order_amount__c FROM Order_Table__c LIMIT 1];
            Order_Table__c newOrder = new Order_Table__c(Product__c = ApexPages.currentPage().getParameters().get('id'), Units__c = units, Order_amount__c = totalCost, Contact__c = contact[0].Id);
            orderTableData.add(newOrder);
            insert orderTableData[0];
            product[0].Units_Available__c = unitsAvailable - units; // change units available in product table
            update product[0];
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Thanks for your order'));
        }
    }
}

    /* dynamicly change Total Amount field on the page*/
    public void calculating() {
        totalCost = units * Product[0].Unit_Price__c;
    }
}
