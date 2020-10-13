/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
@isTest
private class TriggerFilteredSObjectHandler_Tests {

    private static final String FIRST_NAME = 'SomeValue';

    private static Boolean handlerExecuted = false;

    public with sharing class FilteredUserHandler extends TriggerFilteredSObjectHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override Schema.SObjectField getField() {
            return Schema.User.FirstName;
        }
        public override Object getFieldValue() {
            return FIRST_NAME;
        }
        public override void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
            handlerExecuted = true;
        }
    }

    @testSetup
    static void setupData() {
        insert TriggerHandlerSettings__c.getInstance();
    }

    @isTest
    static void it_should_execute_when_record_matches_filter_criteria() {
        System.assertEquals(false, handlerExecuted);

        User currentUser = new User(
            FirstName = FIRST_NAME,
            Id        = UserInfo.getUserId()
        );
        System.assertEquals(FIRST_NAME, currentUser.FirstName);

        FilteredUserHandler filteredUserHandler = new FilteredUserHandler();
        filteredUserHandler.isTestMode       = true;
        filteredUserHandler.currentOperation = System.TriggerOperation.BEFORE_UPDATE;
        filteredUserHandler.newRecordList    = new List<User>{currentUser};
        filteredUserHandler.newRecordMap     = new Map<Id, User>{currentUser.Id => currentUser};
        filteredUserHandler.oldRecordList    = new List<User>{currentUser};
        filteredUserHandler.oldRecordMap     = new Map<Id, User>{currentUser.Id => currentUser};

        System.assertEquals(filteredUserHandler.getFieldValue(), currentUser.get(filteredUserHandler.getField()));

        Test.startTest();
        filteredUserHandler.filterRecords();
        filteredUserHandler.execute();
        Test.stopTest();

        System.assertEquals(true, handlerExecuted);
    }

    @isTest
    static void it_should_not_execute_when_record_matches_filter_criteria() {
        System.assertEquals(false, handlerExecuted);

        User currentUser = new User(
            FirstName = FIRST_NAME + 'something',
            Id        = UserInfo.getUserId()
        );
        System.assertNotEquals(FIRST_NAME, currentUser.FirstName);

        FilteredUserHandler filteredUserHandler = new FilteredUserHandler();
        filteredUserHandler.isTestMode       = true;
        filteredUserHandler.currentOperation = System.TriggerOperation.BEFORE_UPDATE;
        filteredUserHandler.newRecordList    = new List<User>();
        filteredUserHandler.newRecordMap     = new Map<Id, User>();
        filteredUserHandler.oldRecordList    = new List<User>();
        filteredUserHandler.oldRecordMap     = new Map<Id, User>();

        Test.startTest();
        filteredUserHandler.filterRecords();
        filteredUserHandler.execute();
        Test.stopTest();

        System.assertEquals(false, handlerExecuted);
    }

}