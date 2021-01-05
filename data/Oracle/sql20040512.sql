INSERT INTO HtmlLabelIndex values(17083,'多角色') 
/
INSERT INTO HtmlLabelInfo VALUES(17083,'多角色',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17083,'Multi-roles',8) 
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 65,17083,'varchar2(4000)','/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp','HrmRoles','RolesName','ID','/hrm/roles/HrmRolesEdit.jsp?id=') 
/
UPDATE license set cversion = '2.64'
/