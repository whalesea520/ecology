
INSERT INTO workflow_browserurl(id,labelid,fielddbtype,tablename,columname,keycolumname,browserurl,linkurl) values (266,81764,'int','hrmcitytwo','cityname','id','/systeminfo/BrowserMain.jsp?url=/hrm/city/CityTwoBrowser.jsp','/hrm/city/CityTwoBrowser.jsp')
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('district',81764,'INT','3','266','0','7','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('district',81764,'INT','3','266','0','7','CRM_CustomerAddress',1,'n',0,8)
/
UPDATE CRM_CustomerDefinField SET isopen = 0 WHERE usetable = 'CRM_CustomerInfo' AND fieldname = 'county'
/
UPDATE CRM_CustomerDefinField SET isopen = 0 WHERE usetable = 'CRM_CustomerAddress' AND fieldname = 'county'
/
ALTER TABLE CRM_CustomerInfo ADD district INT 
/
ALTER TABLE CRM_CustomerAddress ADD district INT 
/
update CRM_CustomerDefinField set dsporder = 31 where usetable = 'CRM_CustomerInfo' AND fieldname = 'firstname'
/
update CRM_CustomerDefinField set dsporder = 32 where usetable = 'CRM_CustomerInfo' AND fieldname = 'title'
/