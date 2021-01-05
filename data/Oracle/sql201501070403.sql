DELETE FROM workflow_browserurl WHERE id =261
/
DELETE FROM workflow_browserurl WHERE id =262
/
DELETE FROM workflow_browserurl WHERE id =264
/
DELETE FROM workflow_browserurl WHERE id =265
/
DELETE FROM workflow_browserurl WHERE id =266
/
DELETE FROM workflow_browserurl WHERE id =258
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 258,377,'int','/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp','HrmCountry','countryname','id','')
/
DELETE FROM workflow_browserurl WHERE id =259
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) VALUES ( 259,231,'int','/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp','syslanguage','language','id','',5,1,57)
/
DELETE FROM workflow_browserurl WHERE id =260
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) VALUES ( 260,806,'int','/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp?selectedids=','HrmJobCall','name','id','',9,1,59)
/
DELETE FROM workflow_browserurl WHERE id =261
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) VALUES ( 261,34101,'varchar(60)','/systeminfo/BrowserMain.jsp?url=/hrm/companyvirtual/MutiDepartmentBrowser.jsp?selectedids=','hrmdepartmentvirtual','departmentname','id','',2,1,47)
/
DELETE FROM workflow_browserurl WHERE id =262
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) VALUES ( 262,15712,'int','/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp','HrmLocations','locationname','id','',2,1,48)
/
DELETE FROM workflow_browserurl WHERE id =263
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) VALUES ( 263,81764,'int','/systeminfo/BrowserMain.jsp?url=/hrm/city/CityTwoBrowser.jsp','hrmcitytwo','cityname','id','/hrm/city/CityTwoBrowser.jsp',13,1,73) 
/
UPDATE hrm_formfield SET type=259  WHERE fieldhtmltype = 3 AND type= 261
/
UPDATE hrm_formfield SET type=260  WHERE fieldhtmltype = 3 AND type= 262
/
UPDATE hrm_formfield SET type=261  WHERE fieldhtmltype = 3 AND type= 264
/
UPDATE hrm_formfield SET type=262  WHERE fieldhtmltype = 3 AND type= 265
/
UPDATE hrm_formfield SET type=263  WHERE fieldhtmltype = 3 AND type= 266
/