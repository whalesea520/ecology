create or replace  PROCEDURE WorkPlan_Update	
(	id_1 	integer ,		
type_n_1  char   ,	
name_1  varchar2   ,	
resourceid_1  varchar2   ,	
begindate_1  char  ,	
begintime_1  char   ,	
enddate_1  char   ,	
endtime_1  char   ,		
color_1 char  ,
description_1  varchar2    ,	
requestid_1  varchar2    ,	
projectid_1  varchar2   ,	
crmid_1  varchar2   ,	
docid_1  varchar2    ,	
meetingid_1  varchar2   ,	
isremind_1 integer,	
waketime_1 integer   ,		
flag out integer  ,     
msg  out varchar2,    
thecursor IN OUT cursor_define.weavercursor	) 
AS begin  
UPDATE WorkPlan set	 type_n = type_n_1,	 name = name_1 ,	 resourceid = resourceid_1,	 begindate = begindate_1,     begintime = begintime_1,	 enddate = enddate_1 ,	 endtime = endtime_1,	 color = color_1 ,	 description = description_1, 	 requestid = requestid_1 ,	 projectid = projectid_1 ,	 crmid = crmid_1 ,	 docid = docid_1 ,	 meetingid = meetingid_1 ,	 isremind = isremind_1 ,	 waketime = waketime_1  where id = id_1 ;
end;
/


