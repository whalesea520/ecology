alter table workflow_formdict add description varchar(100)
/
alter table workflow_formdictdetail add description varchar(100)
/


alter table workflow_SelectItem add listorder numeric(10,2)
/
alter table workflow_SelectItem add isdefault char(1)
/



update workflow_SelectItem set isdefault = 'n'
/
update workflow_SelectItem set listorder = 0
/


alter table workflow_formdict add textheight integer
/
alter table workflow_formdictdetail add textheight integer
/
update workflow_formdict set textheight = 4
/
update workflow_formdictdetail set textheight = 4
/

 CREATE OR REPLACE PROCEDURE workflow_FieldID_Select 
 (formid_1		integer,
 flag out integer ,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin open thecursor for select fieldid,fieldorder,isdetail from workflow_formfield where formid=formid_1 and (isdetail<>'1' or isdetail is null) order by fieldid; end;
/

CREATE OR REPLACE PROCEDURE workflow_selectitem_insert (fieldid2 INTEGER,
isbill2 		INTEGER, selectvalue2 	INTEGER, selectname2 	VARCHAR2, listorder2 numeric,
isdefault2 char,flag OUT INTEGER,msg OUT VARCHAR2, thecursor IN OUT cursor_define.weavercursor) 
AS
BEGIN
   INSERT INTO workflow_selectitem(fieldid, isbill, selectvalue, selectname,listorder,isdefault) 
   
   VALUES(fieldid2, isbill2, selectvalue2, selectname2,listorder2,isdefault2);
END;

/

 CREATE OR REPLACE PROCEDURE workflow_SelectItemSelectByid 
 (id_1 varchar2, isbill_1 varchar2, flag out integer, msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor) 
 AS begin open thecursor for select * from workflow_SelectItem where fieldid = id_1 
 and isbill = isbill_1 order by listorder; end;
/


