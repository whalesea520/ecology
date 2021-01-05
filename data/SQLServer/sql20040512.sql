INSERT INTO HtmlLabelIndex values(17083,'多角色') 
GO
INSERT INTO HtmlLabelInfo VALUES(17083,'多角色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17083,'Multi-roles',8) 
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 65,17083,'text','/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp','HrmRoles','RolesName','ID','/hrm/roles/HrmRolesEdit.jsp?id=') 
GO
UPDATE license set cversion = '2.64' 
GO