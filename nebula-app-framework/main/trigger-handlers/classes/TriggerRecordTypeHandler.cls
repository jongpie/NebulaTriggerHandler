/*************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.       *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public abstract class TriggerRecordTypeHandler extends TriggerSObjectHandler implements TriggerHandler.ITriggerFilteredSObjectHandler {

    private static final String RECORD_TYPE_ID_FIELD_NAME = 'RecordTypeId';

    private Id recordTypeId;

    public TriggerRecordTypeHandler(Id recordTypeId) {
        super();

        this.recordTypeId = recordTypeId;

        this.filterRecordsByFieldValue(RECORD_TYPE_ID_FIELD_NAME, recordTypeId);
    }

    public TriggerRecordTypeHandler(String recordTypeDeveloperName) {
        super();

        this.recordTypeId = this.getSObjectType()
            .getDescribe()
            .getRecordTypeInfosByDeveloperName()
            .get(recordTypeDeveloperName)
            .getRecordTypeId();

        this.filterRecordsByFieldValue(RECORD_TYPE_ID_FIELD_NAME, this.recordTypeId);
    }

    public String getFieldName() {
        return RECORD_TYPE_ID_FIELD_NAME;
    }

    public String getFieldValue() {
        return this.recordTypeId;
    }

}