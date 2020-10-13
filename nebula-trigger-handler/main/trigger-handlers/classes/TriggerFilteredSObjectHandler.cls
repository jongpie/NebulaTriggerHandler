/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
public abstract class TriggerFilteredSObjectHandler extends TriggerSObjectHandler implements TriggerHandler.ITriggerFilteredSObjectHandler {

    public abstract Schema.SObjectField getField();
    public abstract Object getFieldValue();

    public void filterRecords() {
        super.newRecordList = filterListByFieldValue(super.newRecordList, this.getField(), this.getFieldValue());
        super.newRecordMap  = filterMapByFieldValue(super.newRecordMap, this.getField(), this.getFieldValue());
        super.oldRecordList = filterListByFieldValue(super.oldRecordList, this.getField(), this.getFieldValue());
        super.oldRecordMap  = filterMapByFieldValue(super.oldRecordMap, this.getField(), this.getFieldValue());
    }

    private Map<Id, SObject> filterMapByFieldValue(Map<Id, SObject> recordMap, Schema.SObjectField field, Object fieldValue) {
        return new Map<Id, SObject>(this.filterListByFieldValue(recordMap.values(), field, fieldValue));
    }

    private List<SObject> filterListByFieldValue(List<SObject> recordList, Schema.SObjectField field, Object fieldValue) {
        if(recordList == null) return null;

        List<SObject> filteredRecords = new List<SObject>();
        for(SObject record : recordList) {
            if(record.get(field) == fieldValue) filteredRecords.add(record);
        }

        return filteredRecords;
    }

}