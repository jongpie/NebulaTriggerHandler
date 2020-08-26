/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public abstract class TriggerSObjectHandler extends TriggerHandler {

    // Static variables
    private static Map<Integer, Set<System.TriggerOperation>> hashCodesForProcessedRecords = new Map<Integer, Set<System.TriggerOperation>>();

    // Member variables
    private Integer hashCode; // The hash code for the current records
    private Map<String, List<TriggerOperationHandler>> triggerOperationHandlersByScenario          = new Map<String, List<TriggerOperationHandler>>();
    private List<TriggerRecordTypeHandler> triggerRecordTypeHandlers                               = new List<TriggerRecordTypeHandler>();
    private List<TriggerHandler.ITriggerFilteredSObjectHandler> triggerFilteredSObjectHandlers = new List<TriggerHandler.ITriggerFilteredSObjectHandler>();

    // Public methods
    public override abstract Schema.SObjectType getSObjectType();

    public override void execute() {
        System.debug('Execute method called');

        this.validateTriggerContext();

        // Check the custom setting. If it's disabled, stop everything
        if(!shouldExecuteTriggers()) {
            System.debug('Skipping execution of class');
            return;
        }

        System.debug('Handler is enabled, proceeding with execution');

        //this.setTriggerRecords();
        this.setHashCode();

        System.debug('Starting execute method for: ' + this.getSObjectType());
        System.debug('Hash codes already processed: ' + hashCodesForProcessedRecords);
        System.debug('Hash code for current records: ' + this.hashCode);
        //System.debug('Trigger context for current records: ' + this.currentTriggerOperation);
        System.debug('Number of current records: ' + Trigger.size);

        if(this.haveRecordsAlreadyBeenProcessed()) {
            System.debug('Records already processed for this context, skipping');
            return;
        } else {
            System.debug('Records have not been processed for this context, continuing');
        }

        this.executeTriggerOperationMethod();

        // Run any additional trigger operation handlers & record type handlers
        this.executeTriggerOperationHandlers();
        this.executeFilteredSObjectHandlers();

        // if(Trigger.isAfter) Logger.saveLogs();
    }

    // Protected methods
    protected void addTriggerOperationHandler(TriggerOperationHandler triggerOperationHandler) {
        for(System.TriggerOperation triggerOperation : triggerOperationHandler.getTriggerOperations()) {
            String triggerScenarioName = this.getTriggerScenarioName(this.getSObjectType(), triggerOperation);

            List<TriggerOperationHandler> triggerOperationHandlers = triggerOperationHandlersByScenario.get(triggerScenarioName);
            if(triggerOperationHandlers == null) triggerOperationHandlers = new List<TriggerOperationHandler>();
            triggerOperationHandlers.add(triggerOperationHandler);

            this.triggerOperationHandlersByScenario.put(triggerScenarioName, triggerOperationHandlers);
        }
    }

    // protected void addTriggerRecordTypeHandler(TriggerRecordTypeHandler triggerRecordTypeHandler) {
    //     this.triggerFilteredSObjectHandlers.add(triggerRecordTypeHandler);
    // }

    protected void addFilteredSObjectHandler(ITriggerFilteredSObjectHandler filteredSObjectHandler) {
        this.triggerFilteredSObjectHandlers.add(filteredSObjectHandler);
    }

    protected override virtual void executeBeforeInsert(List<SObject> newRecordList) {}
    protected override virtual void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {}
    protected override virtual void executeBeforeDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {}
    protected override virtual void executeAfterInsert(List<SObject> newRecordList, Map<Id, SObject> newRecordMap) {}
    protected override virtual void executeAfterUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {}
    protected override virtual void executeAfterDelete(List<SObject> deletedRecordList, Map<Id, SObject> deletedRecordMap) {}
    protected override virtual void executeAfterUndelete(List<SObject> undeletedRecordList, Map<Id, SObject> undeletedRecordMap) {}

    // Private methods
    private String getHandlerName() {
        return String.valueOf(this).split(':')[0];
    }

    private List<TriggerOperationHandler> getTriggerOperationHandlers(System.TriggerOperation triggerOperation) {
        String triggerScenarioName = this.getTriggerScenarioName(this.getSObjectType(), triggerOperation);
        return triggerOperationHandlersByScenario.get(triggerScenarioName);
    }

    private String getTriggerScenarioName(Schema.SObjectType sobjectType, System.TriggerOperation triggerOperation) {
        return sobjectType + '.' + triggerOperation.name();
    }

    private void validateTriggerContext() {
        //if(this.isTestMode) return;

        String errorMessage = 'Trigger handler called outside of trigger execution ' + this.isTriggerExecuting;
        if(!this.isTriggerExecuting) throw new TriggerHandler.TriggerHandlerException(errorMessage);
    }

    // private void setTriggerRecords() {
    //     this.recordList    = this.isTestMode ? this.recordList : Trigger.new;
    //     this.recordMap     = this.isTestMode ? this.recordMap : Trigger.newMap;
    //     this.oldRecordList = this.isTestMode ? this.oldRecordList : Trigger.old;
    //     this.oldRecordMap  = this.isTestMode ? this.oldRecordMap : Trigger.oldMap;
    // }

    private Boolean shouldExecuteTriggers() {
        System.debug('TriggerHandlerSettings__c.getInstance().ExecuteTriggers__c=' + TriggerHandlerSettings__c.getInstance().ExecuteTriggers__c);

        String handlerClassesToSkipString = TriggerHandlerSettings__c.getInstance().HandlerClassesToSkip__c;
        if(handlerClassesToSkipString == null) handlerClassesToSkipString = '';
        Set<String> handlerClassesToSkip = new Set<String>(handlerClassesToSkipString.toLowerCase().split('\n'));
        System.debug('TriggerHandlerSettings__c.getInstance().HandlerClassesToSkip__c=' + TriggerHandlerSettings__c.getInstance().HandlerClassesToSkip__c);

        // If ExecuteTriggers == true and the current class isn't in the list of handlers to skip, then execute
        return TriggerHandlerSettings__c.getInstance().ExecuteTriggers__c && !handlerClassesToSkip.contains(this.getHandlerName().toLowerCase());
    }

    private void executeTriggerOperationHandlers() {
        // Run any additional trigger operation handlers
        List<TriggerOperationHandler> triggerOperationHandlers = getTriggerOperationHandlers(Trigger.operationType);
        if(triggerOperationHandlers != null) {
            for(TriggerOperationHandler triggerOperationHandler : triggerOperationHandlers) {
                triggerOperationHandler.setTriggerNew(this.newRecordList, this.newRecordMap);
                triggerOperationHandler.setTriggerOld(this.oldRecordList, this.oldRecordMap);

                triggerOperationHandler.execute();
            }
        }
    }

    private void executeFilteredSObjectHandlers() {
        // Run any record type handlers
        for(TriggerHandler.ITriggerFilteredSObjectHandler triggerFilteredSObjectHandler : this.triggerFilteredSObjectHandlers) {
            triggerFilteredSObjectHandler.execute();
        }
    }

    private void setHashCode() {
        List<SObject> recordToParseList = Trigger.new != null ? Trigger.new : Trigger.old;

       // if(this.isTestMode) recordToParseList = this.recordList;

        this.hashCode = System.hashCode(recordToParseList);
    }

    private Boolean haveRecordsAlreadyBeenProcessed() {
        if(!TriggerHandlerSettings__c.getInstance().PreventRecursion__c) return false;

        // This method is a safeguard that checks to see if we have recursion problems and stops if we do
        // It allows each context to occur once for a given hash code

        if(Trigger.operationType == System.TriggerOperation.BEFORE_INSERT) {
            // BEFORE_INSERT doesn't have record IDs yet, so the hash here will never match the other hashes
            // Since Salesforce makes it impossible to recursively run "insert record", we can let the platform handle it
            return false;
        } else if(!hashCodesForProcessedRecords.containsKey(this.hashCode)) {
            hashCodesForProcessedRecords.put(this.hashCode, new Set<System.TriggerOperation>{Trigger.operationType});
            return false;
        } else if(!hashCodesForProcessedRecords.get(this.hashCode).contains(Trigger.operationType)) {
            hashCodesForProcessedRecords.get(this.hashCode).add(Trigger.operationType);
            return false;
        } else {
            return true;
        }
    }

}