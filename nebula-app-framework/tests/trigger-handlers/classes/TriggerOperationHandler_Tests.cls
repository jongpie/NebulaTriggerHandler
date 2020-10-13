/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
@isTest
private class TriggerOperationHandler_Tests {

    public class AccountBeforeInsertHandler extends SObjectTriggerOperationHandler.SObjectBeforeInsertHandler {

        public override Schema.SObjectType getSObjectType() {
            return Schema.Account.SObjectType;
        }

        public override void execute() {
            System.debug('running in a before insert context for account');
        }

    }

    @isTest
    static void i_should_write_tests() {
        System.assert(false, 'Write some tests!!');
    }

}