/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public without sharing class AccountHandler extends TriggerSObjectHandler {

    public AccountHandler() {
        // When this class is executed, it will run 4 levels
        // 1. Any logic implemented directly in AccountHandler runs first
        // 2. Any trigger operation handlers then run
        // 3. Any filtered SObject handlers then run
        // 4. After run each filtered SObject handler, any nested trigger operation handlers run

        this.addTriggerOperationHandler(new AccountInsertHandler());
        this.addTriggerOperationHandler(new AccountBeforeInsertHandler());
        this.addTriggerOperationHandler(new AccountBeforeUpdateHandler());

        this.addFilteredSObjectHandler(new BusinessAccountHandler());
    }

    public override Schema.SObjectType getSObjectType() {
        return Schema.Account.SObjectType;
    }

}