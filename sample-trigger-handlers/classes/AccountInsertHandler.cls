/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public without sharing class AccountInsertHandler extends TriggerOperationHandler.InsertHandler {

    public override Schema.SObjectType getSObjectType() {
        return Schema.Account.SObjectType;
    }

    public override void executeBeforeInsert(List<SObject> newRecordList) {
        System.debug('running in a before insert context for account');
    }

    public override void executeAfterInsert(List<SObject> newRecordList, Map<Id,SObject> newRecordMap) {
        System.debug('running in a after insert context for account');
    }

}