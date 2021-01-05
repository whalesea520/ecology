INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 164,141,'int','/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp','Hrmsubcompany','subcompanyname','id','/hrm/company/HrmSubCompanyDsp.jsp?id=')
/

create or replace PROCEDURE HrmResource_SelectAll
(flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
AS
begin
open thecursor for
select 
	id,
	loginid,  
	lastname,
	sex,
	resourcetype,
	email,
	locationid,
	workroom, 
	departmentid,
	subcompanyid1,
	costcenterid,
	jobtitle,
	managerid,
	assistantid ,
	seclevel,
	joblevel,
	status,
	account,
	mobile,
	password,
	systemLanguage,
	telephone
from HrmResource ;
end;
/
