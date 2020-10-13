/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
@isTest
private class TriggerHandler_Tests {

    private class UserTriggerHandlerTest extends TriggerHandler {
        public UserTriggerHandlerTest() {
            this.isTestMode         = true;
            this.isTriggerExecuting = true;
        }

        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }

        public override void execute() {}

        public override void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
            List<User> updatedUserList = (List<User>)updatedRecordList;

            for(User updatedUser : updatedUserList) {
                this.setFirstName(updatedUser);
            }
        }

        private void setFirstName(User user) {
            // Add logic here. Methods should be simple & independent from each other (except for overloaded methods)
            user.FirstName = 'TestFirstName';
        }
    }

    static List<User> userList = new List<User>();

    @testSetup
    static void setupData() {
        insert TriggerHandlerSettings__c.getInstance();
    }

    @isTest
    static void it_should_not_execute_triggers_when_setting_is_disabled() {
        TriggerHandlerSettings__c triggerHandlerSettings = TriggerHandlerSettings__c.getInstance();
        triggerHandlerSettings.ExecuteTriggers__c = false;
        upsert triggerHandlerSettings;

        UserTriggerHandlerTest userTriggerHandler = new UserTriggerHandlerTest();
        userTriggerHandler.currentOperation = System.TriggerOperation.BEFORE_INSERT;
        userTriggerHandler.newRecordList    = userList;

        Test.startTest();

        userTriggerHandler.execute();

        Test.stopTest();
    }

    @isTest
    static void it_should_execute_all_contexts() {
        UserTriggerHandlerTest userTriggerHandler = new UserTriggerHandlerTest();
        userTriggerHandler.newRecordList = userList;

        Test.startTest();
        for(System.TriggerOperation operation : System.TriggerOperation.values()) {
            userTriggerHandler.currentOperation = operation;
            userTriggerHandler.execute();
        }
        Test.stopTest();
    }

    @isTest
    static void it_should_execute_before_insert() {
        UserTriggerHandlerTest userTriggerHandler = new UserTriggerHandlerTest();
        userTriggerHandler.currentOperation = System.TriggerOperation.BEFORE_INSERT;
        userTriggerHandler.newRecordList    = userList;

        Test.startTest();

        userTriggerHandler.execute();

        Test.stopTest();
    }

    @isTest
    static void it_should_execute_before_update() {
        UserTriggerHandlerTest userTriggerHandler = new UserTriggerHandlerTest();
        userTriggerHandler.currentOperation = System.TriggerOperation.BEFORE_UPDATE;
        userTriggerHandler.newRecordList    = userList;
        userTriggerHandler.newRecordMap     = new Map<Id, User>(userList);
        userTriggerHandler.oldRecordList    = userList;
        userTriggerHandler.oldRecordMap     = new Map<Id, User>(userList);

        Test.startTest();

        userTriggerHandler.execute();

        Test.stopTest();
    }

}