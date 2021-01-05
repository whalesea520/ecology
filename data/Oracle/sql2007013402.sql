delete from workflow_browserurl where id=135
/
delete from workflow_browserurl where id=152
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (135, 18434, 'varchar2(4000)', '/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp', 'Prj_ProjectInfo', 'name', 'id', '/proj/data/ViewProject.jsp?isrequest=1&ProjID=')
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 152,20156,'varchar2(4000)','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp','workflow_requestbase','requestname','requestid','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=')
/