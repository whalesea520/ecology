
ALTER table  hpsetting_wfcenter  ADD typeids_1 clob
/
update    hpsetting_wfcenter set typeids_1 = typeids
/
ALTER table  hpsetting_wfcenter  drop column typeids
/
ALTER TABLE hpsetting_wfcenter RENAME COLUMN typeids_1 TO typeids
/



ALTER table  hpsetting_wfcenter  ADD flowids_1 clob
/
update    hpsetting_wfcenter set flowids_1 = flowids
/
ALTER table  hpsetting_wfcenter  drop column flowids
/
ALTER TABLE hpsetting_wfcenter RENAME COLUMN flowids_1 TO flowids
/



ALTER table  hpsetting_wfcenter  ADD nodeids_1 clob
/
update    hpsetting_wfcenter set nodeids_1 = nodeids
/
ALTER table  hpsetting_wfcenter  drop column nodeids
/
ALTER TABLE hpsetting_wfcenter RENAME COLUMN nodeids_1 TO nodeids
/