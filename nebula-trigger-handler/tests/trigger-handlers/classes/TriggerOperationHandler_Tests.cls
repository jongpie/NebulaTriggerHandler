/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
@isTest
private class TriggerOperationHandler_Tests {

    private static System.TriggerOperation currentTestOperation;

    // Inner classes that extend TriggerOperationHandler - these classes are used by the test methods below

    // Action handlers - 1 handler per DML method
    public class UserInsertHandler extends TriggerOperationHandler.InsertHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeBeforeInsert(List<SObject> newRecordList) {
            currentTestOperation = super.currentOperation;
        }
        public override void executeAfterInsert(List<SObject> newRecordList, Map<Id, SObject> newRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserUpdateHandler extends TriggerOperationHandler.UpdateHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
            currentTestOperation = super.currentOperation;
        }
        public override void executeAfterUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserDeleteHandler extends TriggerOperationHandler.DeleteHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeBeforeDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
        public override void executeAfterDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserUndeleteHandler extends TriggerOperationHandler.UndeleteHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeAfterUndelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    // BEFORE & AFTER handlers - 1 handler for each situation
    public class UserBeforeHandler extends TriggerOperationHandler.BeforeHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeBeforeInsert(List<SObject> newRecordList) {
            currentTestOperation = super.currentOperation;
        }
        public override void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
            currentTestOperation = super.currentOperation;
        }
        public override void executeBeforeDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserAfterHandler extends TriggerOperationHandler.AfterHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeAfterInsert(List<SObject> newRecordList, Map<Id, SObject> newRecordMap) {
            currentTestOperation = super.currentOperation;
        }
        public override void executeAfterUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
            currentTestOperation = super.currentOperation;
        }
        public override void executeAfterDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
        public override void executeAfterUndelete(List<SObject> undeletedRecordList, Map<Id, SObject> undeletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    // Operation type-specific handlers - 1 handler for each instance of System.TriggerOperation
    public class UserBeforeInsertHandler extends TriggerOperationHandler.BeforeInsertHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeBeforeInsert(List<SObject> newRecordList) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserBeforeUpdateHandler extends TriggerOperationHandler.BeforeUpdateHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserBeforeDeleteHandler extends TriggerOperationHandler.BeforeDeleteHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeBeforeDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserAfterInsertHandler extends TriggerOperationHandler.AfterInsertHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeAfterInsert(List<SObject> newRecordList, Map<Id, SObject> newRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserAfterUpdateHandler extends TriggerOperationHandler.AfterUpdateHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeAfterUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserAfterDeleteHandler extends TriggerOperationHandler.AfterDeleteHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeAfterDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }
    public class UserAfterUndeleteHandler extends TriggerOperationHandler.AfterUndeleteHandler {
        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }
        public override void executeAfterUndelete(List<SObject> undeletedRecordList, Map<Id, SObject> undeletedRecordMap) {
            currentTestOperation = super.currentOperation;
        }
    }

    // Start of the actual test methods
    @isTest
    static void it_should_return_insert_trigger_operations_from_insertHandler() {
        UserInsertHandler userInsertHandler = new UserInsertHandler();
        List<System.TriggerOperation> expectedOperations = new List<System.TriggerOperation>{
            System.TriggerOperation.BEFORE_INSERT,
            System.TriggerOperation.AFTER_INSERT
        };

        Test.startTest();
        List<System.TriggerOperation> returnedTriggerOperations = userInsertHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(expectedOperations.size(), returnedTriggerOperations.size());
        System.assertEquals(expectedOperations, returnedTriggerOperations);
    }

    @isTest
    static void it_should_execute_insertHandler_for_before_insert_operation() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserInsertHandler userInsertHandler = new UserInsertHandler();
        userInsertHandler.currentOperation = System.TriggerOperation.BEFORE_INSERT;
        userInsertHandler.setTriggerNew(new List<User>{currentUser}, null);

        Test.startTest();
        userInsertHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.BEFORE_INSERT, currentTestOperation);
    }

    @isTest
    static void it_should_return_update_trigger_operations_from_updateHandler() {
        UserUpdateHandler userUpdateHandler = new UserUpdateHandler();
        List<System.TriggerOperation> expectedOperations = new List<System.TriggerOperation>{
            System.TriggerOperation.BEFORE_UPDATE,
            System.TriggerOperation.AFTER_UPDATE
        };

        Test.startTest();
        List<System.TriggerOperation> returnedTriggerOperations = userUpdateHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(expectedOperations.size(), returnedTriggerOperations.size());
        System.assertEquals(expectedOperations, returnedTriggerOperations);
    }

    @isTest
    static void it_should_execute_updateHandler_for_before_update_operation() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserUpdateHandler userUpdateHandler = new UserUpdateHandler();
        userUpdateHandler.currentOperation = System.TriggerOperation.BEFORE_UPDATE;
        userUpdateHandler.setTriggerNew(new List<User>{currentUser}, null);

        Test.startTest();
        userUpdateHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.BEFORE_UPDATE, currentTestOperation);
    }

    @isTest
    static void it_should_return_delete_trigger_operations_from_deleteHandler() {
        UserDeleteHandler userDeleteHandler = new UserDeleteHandler();
        List<System.TriggerOperation> expectedOperations = new List<System.TriggerOperation>{
            System.TriggerOperation.BEFORE_DELETE,
            System.TriggerOperation.AFTER_DELETE
        };

        Test.startTest();
        List<System.TriggerOperation> returnedTriggerOperations = userDeleteHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(expectedOperations.size(), returnedTriggerOperations.size());
        System.assertEquals(expectedOperations, returnedTriggerOperations);
    }

    @isTest
    static void it_should_execute_deleteHandler_for_before_delete_operation() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserDeleteHandler userDeleteHandler = new UserDeleteHandler();
        userDeleteHandler.currentOperation = System.TriggerOperation.BEFORE_DELETE;
        userDeleteHandler.setTriggerNew(new List<User>{currentUser}, null);

        Test.startTest();
        userDeleteHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.BEFORE_DELETE, currentTestOperation);
    }

    @isTest
    static void it_should_return_undelete_trigger_operations_from_undeleteHandler() {
        UserUndeleteHandler userUndeleteHandler = new UserUndeleteHandler();
        List<System.TriggerOperation> expectedOperations = new List<System.TriggerOperation>{
            System.TriggerOperation.AFTER_UNDELETE
        };

        Test.startTest();
        List<System.TriggerOperation> returnedTriggerOperations = userUndeleteHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(expectedOperations.size(), returnedTriggerOperations.size());
        System.assertEquals(expectedOperations, returnedTriggerOperations);
    }

    @isTest
    static void it_should_execute_undeleteHandler_for_after_undelete_operation() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserUndeleteHandler userUndeleteHandler = new UserUndeleteHandler();
        userUndeleteHandler.currentOperation = System.TriggerOperation.AFTER_UNDELETE;
        userUndeleteHandler.setTriggerNew(new List<User>{currentUser}, null);

        Test.startTest();
        userUndeleteHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.AFTER_UNDELETE, currentTestOperation);
    }

    @isTest
    static void it_should_return_before_trigger_operations_from_beforeHandler() {
        UserBeforeHandler userBeforeHandler = new UserBeforeHandler();
        List<System.TriggerOperation> expectedOperations = new List<System.TriggerOperation>{
            System.TriggerOperation.BEFORE_INSERT,
            System.TriggerOperation.BEFORE_UPDATE,
            System.TriggerOperation.BEFORE_DELETE
        };

        Test.startTest();
        List<System.TriggerOperation> returnedTriggerOperations = userBeforeHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(expectedOperations.size(), returnedTriggerOperations.size());
        System.assertEquals(expectedOperations, returnedTriggerOperations);
    }

    @isTest
    static void it_should_execute_beforeHandler_for_insert_operation() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserBeforeHandler userBeforeHandler = new UserBeforeHandler();
        userBeforeHandler.currentOperation = System.TriggerOperation.BEFORE_INSERT;
        userBeforeHandler.setTriggerNew(new List<User>{currentUser}, null);

        Test.startTest();
        userBeforeHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.BEFORE_INSERT, currentTestOperation);
    }

    @isTest
    static void it_should_return_after_trigger_operations_from_afterHandler() {
        UserAfterHandler userAfterHandler = new UserAfterHandler();
        List<System.TriggerOperation> expectedOperations = new List<System.TriggerOperation>{
            System.TriggerOperation.AFTER_DELETE,
            System.TriggerOperation.AFTER_INSERT,
            System.TriggerOperation.AFTER_UNDELETE,
            System.TriggerOperation.AFTER_UPDATE
        };

        Test.startTest();
        List<System.TriggerOperation> returnedTriggerOperations = userAfterHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(expectedOperations.size(), returnedTriggerOperations.size());
        System.assertEquals(expectedOperations, returnedTriggerOperations);
    }

    @isTest
    static void it_should_execute_afterHandler_for_insert_operation() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserAfterHandler userAfterHandler = new UserAfterHandler();
        userAfterHandler.currentOperation = System.TriggerOperation.AFTER_INSERT;
        userAfterHandler.setTriggerNew(new List<User>{currentUser}, null);

        Test.startTest();
        userAfterHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.AFTER_INSERT, currentTestOperation);
    }

    @isTest
    static void it_should_return_beforeInsert_trigger_operation_from_beforeInsertHandler() {
        UserBeforeInsertHandler userBeforeInsertHandler = new UserBeforeInsertHandler();

        Test.startTest();
        List<System.TriggerOperation> triggerOperations = userBeforeInsertHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(1, triggerOperations.size());

        System.TriggerOperation triggerOperation = triggerOperations.get(0);
        System.assertEquals(System.TriggerOperation.BEFORE_INSERT, triggerOperation);
    }

    @isTest
    static void it_should_execute_beforeInsertHandler() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserBeforeInsertHandler userBeforeInsertHandler = new UserBeforeInsertHandler();
        userBeforeInsertHandler.currentOperation = System.TriggerOperation.BEFORE_INSERT;
        userBeforeInsertHandler.setTriggerNew(new List<User>{currentUser}, null);

        Test.startTest();
        userBeforeInsertHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.BEFORE_INSERT, currentTestOperation);
    }

    @isTest
    static void it_should_return_beforeUpdate_trigger_operation_from_beforeUpdateHandler() {
        UserBeforeUpdateHandler userBeforeUpdateHandler = new UserBeforeUpdateHandler();

        Test.startTest();
        List<System.TriggerOperation> triggerOperations = userBeforeUpdateHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(1, triggerOperations.size());

        System.TriggerOperation triggerOperation = triggerOperations.get(0);
        System.assertEquals(System.TriggerOperation.BEFORE_UPDATE, triggerOperation);
    }

    @isTest
    static void it_should_execute_beforeUpdateHandler() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserBeforeUpdateHandler userBeforeUpdateHandler = new UserBeforeUpdateHandler();
        userBeforeUpdateHandler.currentOperation = System.TriggerOperation.BEFORE_UPDATE;
        userBeforeUpdateHandler.setTriggerNew(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});
        userBeforeUpdateHandler.setTriggerOld(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});

        Test.startTest();
        userBeforeUpdateHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.BEFORE_UPDATE, currentTestOperation);
    }

    @isTest
    static void it_should_return_beforeDelete_trigger_operation_from_beforeDeleteHandler() {
        UserBeforeDeleteHandler userBeforeDeleteHandler = new UserBeforeDeleteHandler();

        Test.startTest();
        List<System.TriggerOperation> triggerOperations = userBeforeDeleteHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(1, triggerOperations.size());

        System.TriggerOperation triggerOperation = triggerOperations.get(0);
        System.assertEquals(System.TriggerOperation.BEFORE_DELETE, triggerOperation);
    }

    @isTest
    static void it_should_execute_beforeDeleteHandler() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserBeforeDeleteHandler userBeforeDeleteHandler = new UserBeforeDeleteHandler();
        userBeforeDeleteHandler.currentOperation = System.TriggerOperation.BEFORE_DELETE;
        userBeforeDeleteHandler.setTriggerNew(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});
        userBeforeDeleteHandler.setTriggerOld(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});

        Test.startTest();
        userBeforeDeleteHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.BEFORE_DELETE, currentTestOperation);
    }

    @isTest
    static void it_should_return_afterInsert_trigger_operation_from_afterInsertHandler() {
        UserAfterInsertHandler userAfterInsertHandler = new UserAfterInsertHandler();

        Test.startTest();
        List<System.TriggerOperation> triggerOperations = userAfterInsertHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(1, triggerOperations.size());

        System.TriggerOperation triggerOperation = triggerOperations.get(0);
        System.assertEquals(System.TriggerOperation.AFTER_INSERT, triggerOperation);
    }

    @isTest
    static void it_should_execute_afterInsertHandler() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserAfterInsertHandler userAfterInsertHandler = new UserAfterInsertHandler();
        userAfterInsertHandler.currentOperation = System.TriggerOperation.AFTER_INSERT;
        userAfterInsertHandler.setTriggerNew(new List<User>{currentUser}, null);

        Test.startTest();
        userAfterInsertHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.AFTER_INSERT, currentTestOperation);
    }

    @isTest
    static void it_should_return_afterUpdate_trigger_operation_from_afterUpdateHandler() {
        UserAfterUpdateHandler userAfterUpdateHandler = new UserAfterUpdateHandler();

        Test.startTest();
        List<System.TriggerOperation> triggerOperations = userAfterUpdateHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(1, triggerOperations.size());

        System.TriggerOperation triggerOperation = triggerOperations.get(0);
        System.assertEquals(System.TriggerOperation.AFTER_UPDATE, triggerOperation);
    }

    @isTest
    static void it_should_execute_afterUpdateHandler() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserAfterUpdateHandler userAfterUpdateHandler = new UserAfterUpdateHandler();
        userAfterUpdateHandler.currentOperation = System.TriggerOperation.AFTER_UPDATE;
        userAfterUpdateHandler.setTriggerNew(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});
        userAfterUpdateHandler.setTriggerOld(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});

        Test.startTest();
        userAfterUpdateHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.AFTER_UPDATE, currentTestOperation);
    }

    @isTest
    static void it_should_return_afterDelete_trigger_operation_from_afterDeleteHandler() {
        UserAfterDeleteHandler userAfterDeleteHandler = new UserAfterDeleteHandler();

        Test.startTest();
        List<System.TriggerOperation> triggerOperations = userAfterDeleteHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(1, triggerOperations.size());

        System.TriggerOperation triggerOperation = triggerOperations.get(0);
        System.assertEquals(System.TriggerOperation.AFTER_DELETE, triggerOperation);
    }

    @isTest
    static void it_should_execute_afterDeleteHandler() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserAfterDeleteHandler userAfterDeleteHandler = new UserAfterDeleteHandler();
        userAfterDeleteHandler.currentOperation = System.TriggerOperation.AFTER_DELETE;
        userAfterDeleteHandler.setTriggerNew(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});
        userAfterDeleteHandler.setTriggerOld(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});

        Test.startTest();
        userAfterDeleteHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.AFTER_DELETE, currentTestOperation);
    }

    @isTest
    static void it_should_return_afterUndelete_trigger_operation_from_afterUndeleteHandler() {
        UserAfterUndeleteHandler userAfterUndeleteHandler = new UserAfterUndeleteHandler();

        Test.startTest();
        List<System.TriggerOperation> triggerOperations = userAfterUndeleteHandler.getTriggerOperations();
        Test.stopTest();

        System.assertEquals(1, triggerOperations.size());

        System.TriggerOperation triggerOperation = triggerOperations.get(0);
        System.assertEquals(System.TriggerOperation.AFTER_UNDELETE, triggerOperation);
    }

    @isTest
    static void it_should_execute_afterUndeleteHandler() {
        User currentUser = new User(Id = UserInfo.getUserId());
        System.assertEquals(null, currentTestOperation);

        UserAfterUndeleteHandler userAfterUndeleteHandler = new UserAfterUndeleteHandler();
        userAfterUndeleteHandler.currentOperation = System.TriggerOperation.AFTER_UNDELETE;
        userAfterUndeleteHandler.setTriggerNew(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});
        userAfterUndeleteHandler.setTriggerOld(new List<User>{currentUser}, new Map<Id, User>{currentUser.Id => currentUser});

        Test.startTest();
        userAfterUndeleteHandler.execute();
        Test.stopTest();

        System.assertEquals(System.TriggerOperation.AFTER_UNDELETE, currentTestOperation);
    }

}