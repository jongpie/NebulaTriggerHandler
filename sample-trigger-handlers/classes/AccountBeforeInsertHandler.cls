/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public with sharing class AccountBeforeInsertHandler extends TriggerOperationHandler.BeforeInsertHandler {

    public override Schema.SObjectType getSObjectType() {
        return Schema.Account.SObjectType;
    }

    public override void executeBeforeInsert(List<SObject> newRecords) {
        System.debug('running in a before insert context for account');
        System.debug('newRecords = ' + newRecords);
    }

}