INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (74,'ApproveID',16409,'integer',3,8,2,0,'')
/

CREATE PROCEDURE workflow_74_init
AS
wfid integer;
nodeid integer;
fieldid integer;
begin
	 select id into fieldid from workflow_billfield where billid=74 and fieldname='ApproveID';
	 for wf_cursor in (select id from workflow_base where formid=74)
	 loop
	 	 wfid:=wf_cursor.id;
		 for node_cursor in (select distinct(nodeid) from workflow_flownode where workflowid=wfid)
		 loop
		 	 nodeid:=node_cursor.nodeid;
			 insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory,orderid) values(nodeid,fieldid,1,0,0,0);
		 end loop;
	 end loop;
end;
/
CALL workflow_74_init()
/
DROP PROCEDURE workflow_74_init
/
