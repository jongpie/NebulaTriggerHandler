public abstract class TriggerHandler {

    public TriggerContext context; // the current context of the trigger
    public enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE, AFTER_UNDELETE
    }

    private Integer hashCode; // the hash code for the current records
    private Boolean isTriggerExecuting; // the current context of the trigger

    protected TriggerHandler() {
        this.setTriggerContext();
        this.validateTriggerContext();
    }

    public void run() {
		if(this.context == TriggerContext.BEFORE_INSERT) this.beforeInsert(Trigger.new);
        else if(this.context == TriggerContext.BEFORE_UPDATE) this.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        else if(this.context == TriggerContext.BEFORE_DELETE) this.beforeDelete(Trigger.old, Trigger.oldMap);
        else if(this.context == TriggerContext.AFTER_INSERT) this.afterInsert(Trigger.new, Trigger.newMap);
        else if(this.context == TriggerContext.AFTER_UPDATE) this.afterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        else if(this.context == TriggerContext.AFTER_DELETE) this.afterDelete(Trigger.old, Trigger.oldMap);
        else if(this.context == TriggerContext.AFTER_UNDELETE) this.afterUndelete(Trigger.new, Trigger.newMap);
    }

    protected virtual void beforeInsert(List<SObject> newRecords) {}
    protected virtual void beforeUpdate(List<SObject> updatedRecords, Map<Id, SObject> updatedRecordsMap, List<SObject> oldRecords, Map<Id, SObject> oldRecordsMap) {}
    protected virtual void beforeDelete(List<SObject> deletedRecords, Map<Id, SObject> deletedRecordsMap) {}
    protected virtual void afterInsert(List<SObject> newRecords, Map<Id, SObject> newRecordsMap) {}
    protected virtual void afterUpdate(List<SObject> updatedRecords, Map<Id, SObject> updatedRecordsMap, List<SObject> oldRecords, Map<Id, SObject> oldRecordsMap) {}
    protected virtual void afterDelete(List<SObject> deletedRecords, Map<Id, SObject> deletedRecordsMap) {}
    protected virtual void afterUndelete(List<SObject> undeletedRecords, Map<Id, SObject> undeletedRecordsMap) {}

    private void setTriggerContext() {
        this.isTriggerExecuting = Trigger.isExecuting;

        if(!this.isTriggerExecuting) return;
        else if(Trigger.isBefore && Trigger.isInsert) this.context = TriggerContext.BEFORE_INSERT;
        else if(Trigger.isBefore && Trigger.isUpdate) this.context = TriggerContext.BEFORE_UPDATE;
        else if(Trigger.isBefore && Trigger.isDelete) this.context = TriggerContext.BEFORE_DELETE;
        else if(Trigger.isAfter && Trigger.isInsert) this.context = TriggerContext.AFTER_INSERT;
        else if(Trigger.isAfter && Trigger.isUpdate) this.context = TriggerContext.AFTER_UPDATE;
        else if(Trigger.isAfter && Trigger.isDelete) this.context = TriggerContext.AFTER_DELETE;
        else if(Trigger.isAfter && Trigger.isUndelete) this.context = TriggerContext.AFTER_UNDELETE;
    }

    private void validateTriggerContext() {
        String errorMessage = 'Trigger handler called outside of trigger execution';
        if(!this.isTriggerExecuting || this.context == null) throw new Exceptions.TriggerHandlerException(errorMessage);
    }

}