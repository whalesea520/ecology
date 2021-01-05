
CREATE or replace  PROCEDURE WFDocShareInfo_Select 
(requestId_1	integer,
userid_2    integer, 
flag	out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for
select * from Workflow_DocShareInfo where requestId=requestId_1 and userid=userid_2;
end;
/

CREATE or replace PROCEDURE WF_DocShare_AddSharesource 
		(docid_1	integer, 
		sharelevel_1	integer, 
		userid_1	integer, 
		usertype_1	integer,
		sharesource_1 integer, 
		flag	out integer,
		msg out varchar2, 
		thecursor IN OUT cursor_define.weavercursor)
as

	count_1 integer;
		count_2 integer;
BEGIN 
	
    select count(*) into  count_1 from docdetail where usertype=usertype_1 and (ownerid=userid_1 or doccreaterid=userid_1);
		if count_1=0 then
				select count(*) into count_2 from DocShare where docid=docid_1 and sharelevel=sharelevel_1 and userid= userid_1;
				if count_2=0 then
						if usertype_1=0 then insert into DocShare(docid,sharetype,sharelevel,userid,sharesource) values(docid_1,'1',sharelevel_1,userid_1,sharesource_1); 
						END if;
						if usertype_1=1 then
								insert into DocShare(docid,sharetype,sharelevel,crmid) values(docid_1,'9',sharelevel_1,userid_1); 
						END if;
				END if;
		END if;
END;
/