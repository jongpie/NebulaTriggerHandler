/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public abstract class TriggerRecordTypeHandler extends TriggerFilteredSObjectHandler implements TriggerHandler.ITriggerFilteredSObjectHandler {

    private static final String RECORD_TYPE_ID_FIELD_NAME = 'RecordTypeId';

    private Id recordTypeId;

    public TriggerRecordTypeHandler(String recordTypeDeveloperName) {
        super();

        this.recordTypeId = this.getSObjectType()
            .getDescribe()
            .getRecordTypeInfosByDeveloperName()
            .get(recordTypeDeveloperName)
            .getRecordTypeId();
    }

    public override Schema.SObjectField getField() {
        return this.getSObjectType()
            .getDescribe()
            .fields
            .getMap()
            .get(RECORD_TYPE_ID_FIELD_NAME);
    }

    public override Object getFieldValue() {
        return this.recordTypeId;
    }

}