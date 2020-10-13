/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
public abstract class TriggerOperationHandler extends TriggerHandler implements TriggerHandler.ITriggerOperationHandler {

    // Abstract methods
    public override abstract Schema.SObjectType getSObjectType();
    public abstract List<System.TriggerOperation> getTriggerOperations();

    public override void execute() {
        this.executeTriggerOperationMethod();
    }

    public void setTriggerNew(List<SObject> newRecordList, Map<Id, SObject> newRecordMap) {
        this.newRecordList = newRecordList;
        this.newRecordMap  = newRecordMap;
    }

    public void setTriggerOld(List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
        this.oldRecordList = oldRecordList;
        this.oldRecordMap  = oldRecordMap;
    }

    public interface IBeforeInsert {
        void executeBeforeInsert(List<SObject> newRecordList);
    }

    public interface IBeforeUpdate {
        void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap);
    }

    public interface IBeforeDelete {
        void executeBeforeDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap);
    }

    public interface IAfterInsert {
        void executeAfterInsert(List<SObject> newRecordList, Map<Id, SObject> newRecordMap);
    }

    public interface IAfterUpdate {
        void executeAfterUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap);
    }

    public interface IAfterDelete {
        void executeAfterDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap);
    }

    public interface IAfterUndelete {
        void executeAfterUndelete(List<SObject> undeletedRecordList, Map<Id, SObject> undeletedRecordMap);
    }

    // Action handlers - 1 handler per DML method
    public abstract class InsertHandler extends TriggerOperationHandler implements IBeforeInsert, IAfterInsert {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{
                System.TriggerOperation.BEFORE_INSERT,
                System.TriggerOperation.AFTER_INSERT
            };
        }
    }

    public abstract class UpdateHandler extends TriggerOperationHandler implements IBeforeUpdate, IAfterUpdate {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{
                System.TriggerOperation.BEFORE_UPDATE,
                System.TriggerOperation.AFTER_UPDATE
            };
        }
    }

    public abstract class DeleteHandler extends TriggerOperationHandler implements IBeforeDelete, IAfterDelete {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{
                System.TriggerOperation.BEFORE_DELETE,
                System.TriggerOperation.AFTER_DELETE
            };
        }
    }

    public abstract class UndeleteHandler extends TriggerOperationHandler implements IAfterUndelete {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{System.TriggerOperation.AFTER_UNDELETE};
        }
    }

    // BEFORE & AFTER handlers - 1 handler for each situation
    public abstract class BeforeHandler extends TriggerOperationHandler implements IBeforeInsert, IBeforeUpdate, IBeforeDelete {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{
                System.TriggerOperation.BEFORE_INSERT,
                System.TriggerOperation.BEFORE_UPDATE,
                System.TriggerOperation.BEFORE_DELETE
            };
        }
    }

    public abstract class AfterHandler extends TriggerOperationHandler implements IAfterInsert, IAfterUpdate, IAfterDelete, IAfterUndelete {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{
                System.TriggerOperation.AFTER_DELETE,
                System.TriggerOperation.AFTER_INSERT,
                System.TriggerOperation.AFTER_UNDELETE,
                System.TriggerOperation.AFTER_UPDATE
            };
        }
    }

    // Operation type-specific handlers - 1 handler for each instance of System.TriggerOperation
    public abstract class BeforeInsertHandler extends TriggerOperationHandler implements IBeforeInsert {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{System.TriggerOperation.BEFORE_INSERT};
        }
    }

    public abstract class BeforeUpdateHandler extends TriggerOperationHandler implements IBeforeUpdate {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{System.TriggerOperation.BEFORE_UPDATE};
        }
    }

    public abstract class BeforeDeleteHandler extends TriggerOperationHandler implements IBeforeDelete {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{System.TriggerOperation.BEFORE_DELETE};
        }
    }

    public abstract class AfterInsertHandler extends TriggerOperationHandler implements IAfterInsert {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{System.TriggerOperation.AFTER_INSERT};
        }
    }

    public abstract class AfterUpdateHandler extends TriggerOperationHandler implements IAfterUpdate {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{System.TriggerOperation.AFTER_UPDATE};
        }
    }

    public abstract class AfterDeleteHandler extends TriggerOperationHandler implements IAfterDelete {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{System.TriggerOperation.AFTER_DELETE};
        }
    }

    public abstract class AfterUndeleteHandler extends TriggerOperationHandler implements IAfterUndelete {
        public override List<System.TriggerOperation> getTriggerOperations() {
            return new List<System.TriggerOperation>{System.TriggerOperation.AFTER_UNDELETE};
        }
    }

}