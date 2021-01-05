 CREATE or REPLACE PROCEDURE CRM_ContactWay_SelectAll 
 ( flag out	integer	,
 msg out	varchar2,	

	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_ContactWay order by id asc; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_SectorInfo_SelectAll 
 (parentid1	integer, flag out integer,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_SectorInfo WHERE	(parentid = parentid1) order by id asc; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerDesc_SelectAll 
 (                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerDesc order by id asc;
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerSize_SelectAll 
 (                          
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerSize order by id asc;
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerType_SelectAll 
 (                          
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerType order by id asc; 
end;
/
