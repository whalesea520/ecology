CREATE OR REPLACE PROCEDURE workflow_formFieldRt_S 
(formid_1        integer, nodeid_1        integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
begin 
	  open thecursor for 
		select a.fieldid,a.fieldorder,a.isdetail,b.isedit 
		from workflow_formfield a, workflow_nodeform b 
		where formid=formid_1 and (isdetail<>'1' or isdetail is null) 
		and a.fieldid=b.fieldid and b.nodeid=nodeid_1 
		order by a.fieldid; 
end;
/
CREATE OR REPLACE PROCEDURE workflow_billFieldRt_S 
(formid_1        integer, nodeid_1        integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
begin 
	  open thecursor for 
		select a.* ,b.isedit 
		from workflow_billfield a, workflow_nodeform b 
		where a.billid=formid_1 and a.id=b.fieldid and b.nodeid=nodeid_1 
		order by dsporder;
end;
/