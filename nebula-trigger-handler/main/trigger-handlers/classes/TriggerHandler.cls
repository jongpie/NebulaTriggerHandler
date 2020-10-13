/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
public abstract class TriggerHandler {

    public class TriggerHandlerException extends Exception {}

    // Interfaces used by the trigger framework
    public interface ITriggerSObjectHandler {
        Schema.SObjectType getSObjectType();
        void execute();
    }

    public interface ITriggerFilteredSObjectHandler {
        Schema.SObjectType getSObjectType();
        Schema.SObjectField getField();
        Object getFieldValue();
        void execute();
    }

    public interface ITriggerOperationHandler {
        Schema.SObjectType getSObjectType();
        List<System.TriggerOperation> getTriggerOperations();
        void execute();
    }

    @testVisible
    protected System.TriggerOperation currentOperation;
    @testVisible
    protected Boolean isTestMode;
    @testVisible
    protected Boolean isTriggerExecuting;
    @testVisible
    protected List<SObject> newRecordList, oldRecordList;
    @testVisible
    protected Map<Id, SObject> newRecordMap, oldRecordMap;

    public TriggerHandler() {
        this.currentOperation   = Trigger.operationType;
        this.isTriggerExecuting = Trigger.isExecuting;
        this.isTestMode         = false;
        this.newRecordList      = Trigger.new;
        this.newRecordMap       = Trigger.newMap;
        this.oldRecordList      = Trigger.old;
        this.oldRecordMap       = Trigger.oldMap;
    }

    public abstract Schema.SObjectType getSObjectType();
    public abstract void execute();

    protected virtual void executeBeforeInsert(List<SObject> newRecordList) {}
    protected virtual void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {}
    protected virtual void executeBeforeDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {}
    protected virtual void executeAfterInsert(List<SObject> newRecordList, Map<Id, SObject> newRecordMap) {}
    protected virtual void executeAfterUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {}
    protected virtual void executeAfterDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {}
    protected virtual void executeAfterUndelete(List<SObject> undeletedRecordList, Map<Id, SObject> undeletedRecordMap) {}

    protected void executeTriggerOperationMethod() {
        // Run the corresonding execute method
        switch on this.currentOperation {
            when BEFORE_INSERT  { this.executeBeforeInsert(this.newRecordList); }
            when BEFORE_UPDATE  { this.executeBeforeUpdate(this.newRecordList, this.newRecordMap, this.oldRecordList, this.oldRecordMap); }
            when BEFORE_DELETE  { this.executeBeforeDelete(this.oldRecordList, this.oldRecordMap); }
            when AFTER_INSERT   { this.executeAfterInsert(this.newRecordList, this.newRecordMap); }
            when AFTER_UPDATE   { this.executeAfterUpdate(this.newRecordList, this.newRecordMap, this.oldRecordList, this.oldRecordMap); }
            when AFTER_DELETE   { this.executeAfterDelete(this.oldRecordList, this.oldRecordMap); }
            when AFTER_UNDELETE { this.executeAfterUndelete(this.newRecordList, this.newRecordMap); }
        }
    }

}