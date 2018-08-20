trigger ProductTable on Product_Table__c (before insert) {

    Product_Table_Trigger_Handler.handleBeforeInsert(Trigger.new);

}