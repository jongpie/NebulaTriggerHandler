/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
@isTest
private class TriggerSObjectHandler_Tests {

    private class AccountTriggerHandlerTest extends TriggerSObjectHandler {
        public AccountTriggerHandlerTest() {
            this.isTestMode         = true;
            this.isTriggerExecuting = true;
        }

        public override Schema.SObjectType getSObjectType() {
            return Schema.Account.SObjectType;
        }

        public override void executeBeforeInsert(List<SObject> newRecordList) {
            List<Account> newAccountList = (List<Account>)this.newRecordList;

            for(Account newAccount : newAccountList) {
                this.setDescription(newAccount);
            }
        }

        private void setDescription(Account account) {
            // Add logic here. Methods should be simple & independent from each other (except for overloaded methods)
            account.Description = 'Open - Not Contacted';
        }
    }

    static List<Account> accountList = new List<Account>();

    @testSetup
    static void setupData() {
        insert TriggerHandlerSettings__c.getInstance();

        for(Integer i = 0; i < 5; i++) {
            Account account = new Account(Name = 'Test account');
            new TestDataFactory(account).populateRequiredFields();

            accountList.add(account);
        }
        insert accountList;
    }

    @isTest
    static void it_should_not_execute_triggers_when_setting_is_disabled() {
        TriggerHandlerSettings__c triggerHandlerSettings = TriggerHandlerSettings__c.getInstance();
        triggerHandlerSettings.ExecuteTriggers__c = false;
        upsert triggerHandlerSettings;

        AccountTriggerHandlerTest accountTriggerHandler = new AccountTriggerHandlerTest();
        accountTriggerHandler.currentOperation          = System.TriggerOperation.BEFORE_INSERT;
        accountTriggerHandler.newRecordList             = accountList;

        Test.startTest();

        accountTriggerHandler.execute();

        Test.stopTest();
    }

    @isTest
    static void it_should_execute_all_contexts() {
        AccountTriggerHandlerTest accountTriggerHandler = new AccountTriggerHandlerTest();
        accountTriggerHandler.newRecordList = accountList;

        Test.startTest();
        for(System.TriggerOperation operation : System.TriggerOperation.values()) {
            accountTriggerHandler.currentOperation = operation;
            accountTriggerHandler.execute();
        }
        Test.stopTest();
    }

    @isTest
    static void it_should_execute_before_insert() {
        AccountTriggerHandlerTest accountTriggerHandler = new AccountTriggerHandlerTest();
        accountTriggerHandler.currentOperation          = System.TriggerOperation.BEFORE_INSERT;
        accountTriggerHandler.newRecordList             = accountList;

        Test.startTest();

        accountTriggerHandler.execute();

        Test.stopTest();
    }

    @isTest
    static void it_should_execute_before_update() {
        AccountTriggerHandlerTest accountTriggerHandler = new AccountTriggerHandlerTest();
        accountTriggerHandler.currentOperation          = System.TriggerOperation.BEFORE_UPDATE;
        accountTriggerHandler.newRecordList             = accountList;
        accountTriggerHandler.newRecordMap              = new Map<Id, Account>(accountList);
        accountTriggerHandler.oldRecordList             = accountList;
        accountTriggerHandler.oldRecordMap              = new Map<Id, Account>(accountList);

        Test.startTest();

        accountTriggerHandler.execute();

        Test.stopTest();
    }

}