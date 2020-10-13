/******************************************************************************************************
* This file is part of the Nebula Trigger Handler project, released under the MIT License.            *
* See LICENSE file or go to https://github.com/jongpie/NebulaTriggerHandler for full license details. *
******************************************************************************************************/
public abstract class TriggerFilteredSObjectHandler extends TriggerSObjectHandler implements TriggerHandler.ITriggerFilteredSObjectHandler {

    public abstract Schema.SObjectField getField();
    public abstract Object getFieldValue();

    public void filterRecords() {
        this.newRecordList = filterListByFieldValue(this.newRecordList, this.getField(), this.getFieldValue());
        this.newRecordMap  = filterMapByFieldValue(this.newRecordMap, this.getField(), this.getFieldValue());
        this.oldRecordList = filterListByFieldValue(this.oldRecordList, this.getField(), this.getFieldValue());
        this.oldRecordMap  = filterMapByFieldValue(this.oldRecordMap, this.getField(), this.getFieldValue());
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