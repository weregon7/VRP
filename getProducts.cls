public class getProducts {
    public List<Product_Table__c> myData { set; get; }
    public getProducts() {
        myData = [SELECT Name, Image_URL__c, Unit_Price__c, Product_Description__c, Title__c FROM Product_Table__c];
    }
}