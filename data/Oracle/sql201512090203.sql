ALTER TABLE workflow_selectitem ADD pubid INTEGER
/

UPDATE workflow_selectitem  SET pubid=selectvalue WHERE EXISTS (SELECT b.id FROM workflow_billfield b WHERE b.selectItemType IN ('1','2') AND workflow_selectitem.fieldid=b.id)
/