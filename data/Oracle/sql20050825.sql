alter table CRM_CustomerInfo modify bankName varchar(200)
/
alter table CRM_CustomerInfo modify accounts varchar(200)
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 69,705,'integer','/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp','LgcAssetUnit','unitname','id','/lgc/maintenance/LgcAssetUnitEdit.jsp?id=')
/