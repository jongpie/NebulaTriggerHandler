/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public abstract class TriggerHandler implements ITriggerHandler {

    public class TriggerHandlerException extends Exception {}

    // Interfaces used by the trigger framework
    public interface ITriggerSObjectHandler {
        void execute();
    }

    public interface ITriggerFilteredSObjectHandler {
        String getFieldName();
        Object getFieldValue();
        void execute();
    }

    public interface ITriggerOperationHandler {
        List<System.TriggerOperation> getTriggerOperations();
        void execute();
    }

    @testVisible
    protected Boolean isTriggerExecuting;
    @testVisible
    protected List<SObject> newRecordList, oldRecordList;
    @testVisible
    protected Map<Id, SObject> newRecordMap, oldRecordMap;

    public TriggerHandler() {
        this.isTriggerExecuting = Trigger.isExecuting;
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
        switch on Trigger.operationType {
            when BEFORE_INSERT  { this.executeBeforeInsert(this.newRecordList); }
            when BEFORE_UPDATE  { this.executeBeforeUpdate(this.newRecordList, this.newRecordMap, this.oldRecordList, this.oldRecordMap); }
            when BEFORE_DELETE  { this.executeBeforeDelete(this.oldRecordList, this.oldRecordMap); }
            when AFTER_INSERT   { this.executeAfterInsert(this.newRecordList, this.newRecordMap); }
            when AFTER_UPDATE   { this.executeAfterUpdate(this.newRecordList, this.newRecordMap, this.oldRecordList, this.oldRecordMap); }
            when AFTER_DELETE   { this.executeAfterDelete(this.oldRecordList, this.oldRecordMap); }
            when AFTER_UNDELETE { this.executeAfterUndelete(this.newRecordList, this.newRecordMap); }
        }
    }

    protected void filterRecordsByFieldValue(Schema.SObjectField field, Object fieldValue) {
        this.filterRecordsByFieldValue(field.getDescribe().getName(), fieldValue);
    }

    protected void filterRecordsByFieldValue(String fieldName, Object fieldValue) {
        this.newRecordList = filterListByFieldValue(this.newRecordList, fieldName, fieldValue);
        this.newRecordMap  = filterMapByFieldValue(this.newRecordMap, fieldName, fieldValue);
        this.oldRecordList = filterListByFieldValue(this.oldRecordList, fieldName, fieldValue);
        this.oldRecordMap  = filterMapByFieldValue(this.oldRecordMap, fieldName, fieldValue);
    }

    private Map<Id, SObject> filterMapByFieldValue(Map<Id, SObject> recordList, Schema.SObjectField field, Object fieldValue) {
        return new Map<Id, SObject>(this.filterMapByFieldValue(recordList, field.getDescribe().getName(), fieldValue));
    }

    private Map<Id, SObject> filterMapByFieldValue(Map<Id, SObject> recordList, String fieldName, Object fieldValue) {
        return new Map<Id, SObject>(this.filterMapByFieldValue(recordList, fieldName, fieldValue));
    }

    private List<SObject> filterListByFieldValue(List<SObject> recordList, Schema.SObjectField field, Object fieldValue) {
        return filterListByFieldValue(recordList, field.getDescribe().getName(), fieldValue);
    }

    private List<SObject> filterListByFieldValue(List<SObject> recordList, String fieldName, Object fieldValue) {
        if(recordList == null) return null;

        List<SObject> filteredRecords = new List<SObject>();
        for(SObject record : recordList) {
            if(record.get(fieldName) == fieldValue) filteredRecords.add(record);
        }

        return filteredRecords;
    }

}