alter table CRM_CustomerInfo alter column bankName varchar(200)
go
alter table CRM_CustomerInfo alter column accounts varchar(200)
go
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 69,705,'int','/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp','LgcAssetUnit','unitname','id','/lgc/maintenance/LgcAssetUnitEdit.jsp?id=')
go