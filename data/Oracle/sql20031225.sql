CREATE or REPLACE PROCEDURE WorkFlow_BrowserUrl_Insert
	(id_1 	integer,
	 labelid_2 	integer,
	 fielddbtype_3 	varchar2,
	 browserurl_4 	varchar2,
	 tablename_5 	varchar2,
	 columname_6 	varchar2,
	 keycolumname_7 	varchar2,
	 linkurl_8 	varchar2,
     flag out integer,msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
INSERT INTO workflow_browserurl 
	 ( id,
	 labelid,
	 fielddbtype,
	 browserurl,
	 tablename,
	 columname,
	 keycolumname,
	 linkurl) 
 
VALUES 
	(id_1, 
	labelid_2,
	 fielddbtype_3,
	 browserurl_4,
	 tablename_5,
	 columname_6,
	 keycolumname_7,
	 linkurl_8);
end;
/

drop trigger workflow_browserurl_Trigger  
/


