INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (158,'organizationtype',22136,'integer',5,0,1,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (156,'organizationtype',22137,'integer',5,0,1,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (159,'organizationtype',15371,'integer',5,0,1,1)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (157,'organizationtype',22138,'integer',5,0,1,1)
/
delete from workflow_nodeform where fieldid in(select id from workflow_billfield where billid in(156,157,158,159) and fieldname='organizationtype')
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) select nodeid,(select id as fieldid from workflow_billfield where billid=156 and fieldname='organizationtype') as fieldid,isview,isedit,ismandatory from workflow_nodeform where fieldid=(select id from workflow_billfield where billid=156 and fieldname='organizationid')
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) select nodeid,(select id as fieldid from workflow_billfield where billid=157 and fieldname='organizationtype') as fieldid,isview,isedit,ismandatory from workflow_nodeform where fieldid=(select id from workflow_billfield where billid=157 and fieldname='organizationid')
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) select nodeid,(select id as fieldid from workflow_billfield where billid=158 and fieldname='organizationtype') as fieldid,isview,isedit,ismandatory from workflow_nodeform where fieldid=(select id from workflow_billfield where billid=158 and fieldname='organizationid')
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) select nodeid,(select id as fieldid from workflow_billfield where billid=159 and fieldname='organizationtype') as fieldid,isview,isedit,ismandatory from workflow_nodeform where fieldid=(select id from workflow_billfield where billid=159 and fieldname='organizationid')
/
call Bill_SelectList_Insert (156,'organizationtype',3,'个人',0,'y')
/
call Bill_SelectList_Insert (156,'organizationtype',2,'部门',1,'n')
/
call Bill_SelectList_Insert (156,'organizationtype',1,'分部',2,'n')
/
call Bill_SelectList_Insert (157,'organizationtype',3,'个人',0,'y')
/
call Bill_SelectList_Insert (157,'organizationtype',2,'部门',1,'n')
/
call Bill_SelectList_Insert (157,'organizationtype',1,'分部',2,'n')
/
call Bill_SelectList_Insert (158,'organizationtype',3,'个人',0,'y')
/
call Bill_SelectList_Insert (158,'organizationtype',2,'部门',1,'n')
/
call Bill_SelectList_Insert (158,'organizationtype',1,'分部',2,'n')
/
call Bill_SelectList_Insert (159,'organizationtype',3,'个人',0,'y')
/
call Bill_SelectList_Insert (159,'organizationtype',2,'部门',1,'n')
/
call Bill_SelectList_Insert (159,'organizationtype',1,'分部',2,'n')
/
