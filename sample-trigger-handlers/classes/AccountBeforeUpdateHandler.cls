/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public with sharing class AccountBeforeUpdateHandler extends TriggerOperationHandler.BeforeUpdateHandler {

    public override Schema.SObjectType getSObjectType() {
        return Schema.Account.SObjectType;
    }

    // public override System.TriggerOperation getTriggerOperation() {
    //     return System.TriggerOperation.BEFORE_Update;
    // }

    public override void executeBeforeUpdate(List<SObject> updatedRecordList, Map<Id, SObject> updatedRecordMap, List<SObject> oldRecordList, Map<Id, SObject> oldRecordMap) {
        System.debug('running in a before Update context for account');
        System.debug('updatedRecordList = ' + updatedRecordList);
    }

}