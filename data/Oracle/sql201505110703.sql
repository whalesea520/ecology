ALTER TABLE HrmDepartmentVirtual
ADD virtualtype INT
/
ALTER TABLE HrmResourceVirtual
ADD virtualtype INT
/
UPDATE  HrmDepartmentVirtual
SET     virtualtype = ( SELECT  companyid
                        FROM    HrmSubCompanyVirtual
                        WHERE   HrmDepartmentVirtual.subcompanyid1 = HrmSubCompanyVirtual.id
                      )
/                    
UPDATE  HrmResourceVirtual
SET     virtualtype = ( SELECT  companyid
                        FROM    HrmSubCompanyVirtual
                        WHERE   HrmResourceVirtual.subcompanyid = HrmSubCompanyVirtual.id
                      )
/       
CREATE or replace VIEW HrmDepartmentAllView
AS
SELECT id,departmentname,departmentmark,departmentcode,supdepid,allsupdepid,canceled,subcompanyid1,showorder,tlevel,ecology_pinyin_search, 1 AS virtualtype FROM HrmDepartment 
UNION
SELECT id,departmentname,departmentmark,departmentcode,supdepid,allsupdepid,canceled,subcompanyid1,showorder,tlevel,ecology_pinyin_search,virtualtype FROM HrmDepartmentvirtual
/
CREATE OR REPLACE VIEW HRMRESOURCEVIRTUALVIEW AS
SELECT  a.id AS virtualresourceid, b.id , a.managerid , a.subcompanyid AS subcompanyid1 , a.departmentid , a.managerstr , loginid , password , lastname , sex , birthday , nationality , systemlanguage , maritalstatus , telephone , mobile , mobilecall , email , locationid , workroom , homeaddress , resourcetype , startdate , enddate , jobtitle , jobactivitydesc , joblevel , seclevel , costcenterid , assistantid , bankid1 , accountid1 , resourceimageid , createrid , createdate , lastmodid , lastmoddate , lastlogindate , datefield1 , datefield2 , datefield3 , datefield4 , datefield5 , numberfield1 , numberfield2 , numberfield3 , numberfield4 , numberfield5 , textfield1 , textfield2 , textfield3 , textfield4 , textfield5 , tinyintfield1 , tinyintfield2 , tinyintfield3 , tinyintfield4 , tinyintfield5 , certificatenum , nativeplace , educationlevel , bememberdate , bepartydate , workcode , regresidentplace , healthinfo , residentplace , policy , degree , height , usekind , jobcall , accumfundaccount , birthplace , folk , residentphone , residentpostcode , extphone , status , fax , islabouunion , weight , tempresidentnumber , probationenddate , countryid , passwdchgdate , needusb , serial , account , lloginid , needdynapass , dsporder , passwordstate , accounttype , belongto , dactylogram , assistantdactylogram , passwordlock , sumpasswordwrong , oldpassword1 , oldpassword2 , msgStyle , messagerurl , pinyinlastname , tokenkey , userUsbType , adsjgs , adgs , adbm , outkey , mobileshowtype , usbstate , totalSpace , occupySpace , ecology_pinyin_search , isADAccount,virtualtype FROM    HrmResourceVirtual a , HrmResource b WHERE   a.resourceid = b.id
/