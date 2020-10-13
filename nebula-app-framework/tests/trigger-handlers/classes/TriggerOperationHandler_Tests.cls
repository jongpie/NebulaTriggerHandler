/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
@isTest
private class TriggerOperationHandler_Tests {

    public class UserBeforeInsertHandler extends TriggerOperationHandler.BeforeInsertHandler {

        public override Schema.SObjectType getSObjectType() {
            return Schema.User.SObjectType;
        }

        public override void executeBeforeInsert(List<SObject> newRecords) {
            System.debug('running in a before insert context for account');
            System.debug('newRecords = ' + newRecords);
        }

    }

    @isTest
    static void i_should_write_tests() {
        System.assert(false, 'Write some tests!!');
    }

}