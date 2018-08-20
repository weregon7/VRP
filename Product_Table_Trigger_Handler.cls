/**
 * Created by Витя on 19.08.2018.
 */

public with sharing class Product_Table_Trigger_Handler {
    public static void handleBeforeInsert(List<Product_Table__c> Products) {

        List<Product_Table__c> tempProducts = new List<Product_Table__c>();
        List<Warehouse__c> currentWarehouses = Database.query('SELECT Id, Period_Start__c, Period_End__c FROM Warehouse__c');
        List<Warehouse__c> tempWarehouses = new List<Warehouse__c>();
        List<OrgConfiguration__c> abs = [SELECT Period_Term__c FROM OrgConfiguration__c];
        Integer periodTerm = Integer.valueOf(abs[0].Period_Term__c);

        /* Set Data of today if Added_date is undefined by default*/
        for (Integer a = 0; a < Products.size(); a ++){
            if(Products[a].Added_Date__c == null){
                Products[a].Added_Date__c = Date.today();
            }
        }
        /*if there is existed Warehouse then get this one*/
        for (Integer i = 0; i < currentWarehouses.size(); i++) {
            for (Integer j = 0; j < Products.size(); j++) {
                if (currentWarehouses[i].Period_Start__c <= Products[j].Added_Date__c && currentWarehouses[i].Period_End__c >= Products[j].Added_Date__c) {
                    tempWarehouses.add(currentWarehouses[i]);
                }
            }
        }
        if (!tempWarehouses.isEmpty()) {

            for (Integer k = 0; k < Products.size(); k++) {

                Products[k].Warehouse__c = tempWarehouses[0].Id;

            }

        } else {
            /* if there is no existed warehouse create new one and put the product item into it*/
            for (Integer p = 0; p < Products.size(); p++) {
                Warehouse__c temp = new Warehouse__c(Name = 'Warehouse ' + Products[p].Added_Date__c + ' ' + Products[p].Added_Date__c.addDays(periodTerm), Period_Start__c = Products[p].Added_Date__c, Period_End__c = Products[p].Added_Date__c.addDays(periodTerm));
                tempWarehouses.add(temp);

            }
            System.debug(tempWarehouses);
            insert tempWarehouses[0];

            for (Integer q = 0; q < Products.size(); q++) {

                Products[q].Warehouse__c = tempWarehouses[0].Id;

            }

        }

    }
}


