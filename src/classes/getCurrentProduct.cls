public class getCurrentProduct {

    public List<Product_Table__c> myData { set; get; }

    public getCurrentProduct() {
        myData = [
                SELECT Name, Image_URL__c, Unit_Price__c, Product_Description__c, Title__c
                FROM Product_Table__c
                WHERE Id = :ApexPages.currentPage().getParameters().get('id')
        ];
    }


}