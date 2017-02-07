public abstract class TriggerHandler {

    private static Map<Integer, Set<TriggerContext>> hashCodesForProcessedRecords = new Map<Integer, Set<TriggerContext>>();

    public enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE, AFTER_UNDELETE
    }
    public TriggerContext context; // The current context of the trigger

    private Integer hashCode; // The hash code for the current records
    private Boolean isTriggerExecuting; // Checks if the code was called by a trigger

    protected TriggerHandler() {
        this.setTriggerContext();
        this.validateTriggerContext();
        this.setHashCode();
    }

    public void execute() {
        // Check the custom setting. If it's disabled, stop everything, show's over
        // You don't have to go home but you can't stay here
        if(!shouldExecuteTriggers()) return;

        String sobjectType = Trigger.new == null ? Trigger.old.getSObjectType() : Trigger.new.getSObjectType();
        System.debug('Starting execute method for: ' + sobjectType);
        System.debug('Hash codes already processed: ' + TriggerHandler.hashCodesForProcessedRecords);
        System.debug('Hash code for current records: ' + this.hashCode);
        System.debug('Trigger context for current records: ' + this.context);
        System.debug('Number of current records: ' + Trigger.size);

        if(this.haveRecordsAlreadyBeenProcessed()) {
            System.debug('Records already processed for this context, skipping');
            return;
        } else System.debug('Records have not been processed for this context, continuing');

        if(this.context == TriggerContext.BEFORE_INSERT) this.beforeInsert(Trigger.new);
        else if(this.context == TriggerContext.BEFORE_UPDATE) this.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        else if(this.context == TriggerContext.BEFORE_DELETE) this.beforeDelete(Trigger.old, Trigger.oldMap);
        else if(this.context == TriggerContext.AFTER_INSERT) this.afterInsert(Trigger.new, Trigger.newMap);
        else if(this.context == TriggerContext.AFTER_UPDATE) this.afterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        else if(this.context == TriggerContext.AFTER_DELETE) this.afterDelete(Trigger.old, Trigger.oldMap);
        else if(this.context == TriggerContext.AFTER_UNDELETE) this.afterUndelete(Trigger.new, Trigger.newMap);

        this.runDmlForRelatedRecords();
    }

    protected virtual void beforeInsert(List<SObject> newRecordList) {}
    protected virtual void beforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {}
    protected virtual void beforeDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {}
    protected virtual void afterInsert(List<SObject> newRecordList, Map<Id, SObject> newRecordMap) {}
    protected virtual void afterUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {}
    protected virtual void afterDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {}
    protected virtual void afterUndelete(List<SObject> undeletedRecordList, Map<Id, SObject> undeletedRecordMap) {}

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

    private Boolean shouldExecuteTriggers() {
        TriggerSettings__c triggerSettings = TriggerSettings__c.getInstance();

        if(triggerSettings.Id == null) {
            // If there's no ID, then there are settings setup for the current user at the user, profile or org level
            // Upsert the org defaults - the default field values will be used
            upsert TriggerSettings__c.getOrgDefaults();
            // Call getInstance() again to get the settings with the field defaults
            triggerSettings = TriggerSettings__c.getInstance();
        }

        return triggerSettings.ExecuteTriggers__c;
    }

    private void setHashCode() {
        List<SObject> recordList = Trigger.new != null ? Trigger.new : Trigger.old;
        List<String> parsedRecordsJson = new List<String>();
        for(SObject record : recordList) {
            // Some fields can cause the hash code to change even when the record itself has not
            // To get a consistent hash code, we deserialize into JSON, remove the problematic fields, then get the hash code
            Map<String, Object> parsedRecordMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(record));
            parsedRecordMap.remove('CompareName');
            parsedRecordMap.remove('CreatedById');
            parsedRecordMap.remove('CreatedDate');
            parsedRecordMap.remove('LastModifiedById');
            parsedRecordMap.remove('LastModifiedDate');
            parsedRecordMap.remove('SystemModstamp');

            // Since we're using an untyped object (map) & JSON string to generate the hash code, we need to sort the fields
            // Maps & sets aren't sortable, so we have to sort it ourselves
            Map<String, Object> sortedRecordMap = new Map<String, Object>();
            List<String> sortedKeyList = new List<String>(parsedRecordMap.keySet());
            sortedKeyList.sort();
            for(String key : sortedKeyList) sortedRecordMap.put(key, parsedRecordMap.get(key));

            parsedRecordsJson.add(JSON.serialize(sortedRecordMap));
        }
        this.hashCode = parsedRecordsJson.hashCode();
    }

    private Boolean haveRecordsAlreadyBeenProcessed() {
        // This method is a safeguard that checks to see if we have recursion problems and stops if we do
        // It allows each context to occur once for a given hash code
        if(this.context == TriggerContext.BEFORE_INSERT) {
            // BEFORE_INSERT doesn't have record IDs yet, so the hash here will never match the other hashes
            // Since Salesforce makes it impossible to recursively run "insert record", we can let the platform handle it
            return false;
        } else if(!TriggerHandler.hashCodesForProcessedRecords.containsKey(this.hashCode)) {
            TriggerHandler.hashCodesForProcessedRecords.put(this.hashCode, new Set<TriggerContext>{this.context});
            return false;
        } else if(!TriggerHandler.hashCodesForProcessedRecords.get(this.hashCode).contains(this.context)) {
            TriggerHandler.hashCodesForProcessedRecords.get(this.hashCode).add(this.context);
            return false;
        } else {
            return true;
        }
    }

}