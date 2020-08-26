/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public without sharing class BusinessAccountHandler extends TriggerRecordTypeHandler {

    public BusinessAccountHandler() {
        super('BUSINESS_ACCOUNT');
    }

    public override Schema.SObjectType getSObjectType() {
        return Schema.Account.SObjectType;
    }

}