delete from workflow_browserurl where id = 266 AND tablename = 'hrmcitytwo'
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 264,15078,'int','/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','CRM_CustomerStatus','fullname','id','/CRM/Maint/CustomerStatusBrowser.jsp')
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 265,645,'int','/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp','CRM_ContactWay','fullname','id','/CRM/Maint/ContactWayBrowser.jsp') 
/
UPDATE CRM_CustomerDefinField SET type = 264 WHERE fieldname = 'status' AND usetable = 'CRM_CustomerInfo'
/
UPDATE CRM_CustomerDefinField SET type = 265 WHERE fieldname = 'source' AND usetable = 'CRM_CustomerInfo'
/
UPDATE CRM_CustomerDefinField SET type = 263 WHERE fieldname = 'district' AND usetable = 'CRM_CustomerInfo'
/
UPDATE CRM_CustomerDefinField SET type = 263 WHERE fieldname = 'district' AND usetable = 'CRM_CustomerAddress'
/