ALTER TABLE HrmSubCompanyVirtual
ADD virtualtypeid int
GO
ALTER TABLE HrmSubCompanyVirtual
ADD ecology_pinyin_search VARCHAR(1000)
GO
ALTER TABLE hrmdepartmentvirtual
ADD ecology_pinyin_search VARCHAR(1000)
GO
CREATE TRIGGER hrmdepartmentvirtual_getpinyin ON HrmDepartmentvirtual
    FOR INSERT, UPDATE
AS
    DECLARE @pinyinlastname VARCHAR(4000)
    DECLARE @id_1 INT
    BEGIN
        IF ( UPDATE(departmentname) ) 
            BEGIN
                SELECT  @id_1 = id ,
                        @pinyinlastname = LOWER([dbo].[getPinYin](departmentname))
                FROM    inserted
                UPDATE  hrmdepartmentvirtual
                SET     ecology_pinyin_search = @pinyinlastname
                WHERE   id = @id_1
            END
    END
GO
CREATE TRIGGER hrmsubcompanyvirtual_getpinyin ON HrmSubCompanyvirtual
    FOR INSERT, UPDATE
AS
    DECLARE @pinyinlastname VARCHAR(4000)
    DECLARE @id_1 INT
    BEGIN
        IF ( UPDATE(subcompanyname) ) 
            BEGIN
                SELECT  @id_1 = id ,
                        @pinyinlastname = LOWER([dbo].[getPinYin](subcompanyname))
                FROM    inserted
                UPDATE  hrmsubcompanyvirtual
                SET     ecology_pinyin_search = @pinyinlastname
                WHERE   id = @id_1
            END
    END
GO
UPDATE HrmSubCompanyvirtual SET ecology_pinyin_search=LOWER([dbo].[getPinYin](subcompanyname))
GO
UPDATE Hrmdepartmentvirtual SET ecology_pinyin_search=LOWER([dbo].[getPinYin](departmentname))
GO
CREATE VIEW HrmDepartmentAllView
AS
SELECT id,departmentname,departmentmark,departmentcode,supdepid,allsupdepid,canceled,subcompanyid1,showorder,tlevel,ecology_pinyin_search FROM HrmDepartment 
UNION
SELECT id,departmentname,departmentmark,departmentcode,supdepid,allsupdepid,canceled,subcompanyid1,showorder,tlevel,ecology_pinyin_search FROM HrmDepartmentvirtual
GO
CREATE VIEW HrmSubCompanyAllView
AS
SELECT id,subcompanyname,subcompanycode,subcompanydesc,supsubcomid,companyid,canceled,showorder,tlevel,companyid AS virtualtypeid,ecology_pinyin_search FROM HrmSubCompany
UNION
SELECT id,subcompanyname,subcompanycode,subcompanydesc,supsubcomid,companyid,canceled,showorder,tlevel,virtualtypeid,ecology_pinyin_search FROM HrmSubCompanyVirtual
GO
CREATE VIEW HrmResourceVirtualView
AS
    SELECT  a.id AS virtualresourceid,
    				b.id ,
            a.managerid ,
            a.subcompanyid AS subcompanyid1 ,
            a.departmentid ,
            a.managerstr ,
            loginid ,
            password ,
            lastname ,
            sex ,
            birthday ,
            nationality ,
            systemlanguage ,
            maritalstatus ,
            telephone ,
            mobile ,
            mobilecall ,
            email ,
            locationid ,
            workroom ,
            homeaddress ,
            resourcetype ,
            startdate ,
            enddate ,
            jobtitle ,
            jobactivitydesc ,
            joblevel ,
            seclevel ,
            costcenterid ,
            assistantid ,
            bankid1 ,
            accountid1 ,
            resourceimageid ,
            createrid ,
            createdate ,
            lastmodid ,
            lastmoddate ,
            lastlogindate ,
            datefield1 ,
            datefield2 ,
            datefield3 ,
            datefield4 ,
            datefield5 ,
            numberfield1 ,
            numberfield2 ,
            numberfield3 ,
            numberfield4 ,
            numberfield5 ,
            textfield1 ,
            textfield2 ,
            textfield3 ,
            textfield4 ,
            textfield5 ,
            tinyintfield1 ,
            tinyintfield2 ,
            tinyintfield3 ,
            tinyintfield4 ,
            tinyintfield5 ,
            certificatenum ,
            nativeplace ,
            educationlevel ,
            bememberdate ,
            bepartydate ,
            workcode ,
            regresidentplace ,
            healthinfo ,
            residentplace ,
            policy ,
            degree ,
            height ,
            usekind ,
            jobcall ,
            accumfundaccount ,
            birthplace ,
            folk ,
            residentphone ,
            residentpostcode ,
            extphone ,
            status ,
            fax ,
            islabouunion ,
            weight ,
            tempresidentnumber ,
            probationenddate ,
            countryid ,
            passwdchgdate ,
            needusb ,
            serial ,
            account ,
            lloginid ,
            needdynapass ,
            dsporder ,
            passwordstate ,
            accounttype ,
            belongto ,
            dactylogram ,
            assistantdactylogram ,
            passwordlock ,
            sumpasswordwrong ,
            oldpassword1 ,
            oldpassword2 ,
            msgStyle ,
            messagerurl ,
            pinyinlastname ,
            tokenkey ,
            userUsbType ,
            adsjgs ,
            adgs ,
            adbm ,
            outkey ,
            mobileshowtype ,
            usbstate ,
            totalSpace ,
            occupySpace ,
            ecology_pinyin_search ,
            isADAccount
    FROM    HrmResourceVirtual a ,
            HrmResource b
    WHERE   a.resourceid = b.id
GO

INSERT INTO HrmCompanyVirtual (companyname,companycode,companydesc,canceled,showorder,virtualType,virtualtypedesc)
select companyname,companycode,companydesc,canceled,showorder,virtualType,virtualtypedesc FROM HrmCompanyVirtual 
WHERE id=-1
GO
UPDATE hrmsubcompanyvirtual SET companyid=(SELECT MIN(id) FROM HrmCompanyVirtual) WHERE companyid=-1
GO
UPDATE hrmsubcompanyvirtual SET virtualtypeid=(SELECT MIN(id) FROM HrmCompanyVirtual) WHERE companyid=-1
GO
INSERT INTO HrmSubCompanyVirtual (subcompanyname,subcompanycode,subcompanydesc,supsubcomid,companyid,canceled,showorder,tlevel,virtualtypeid,ecology_pinyin_search)
select subcompanyname,subcompanycode,subcompanydesc,supsubcomid,companyid,canceled,showorder,tlevel,virtualtypeid,ecology_pinyin_search FROM HrmSubCompanyVirtual 
WHERE id=-1
GO
UPDATE HrmDepartmentVirtual SET subcompanyid1=(SELECT MIN(id) FROM HrmSubCompanyVirtual) WHERE subcompanyid1=-1
GO
UPDATE HrmResourceVirtual SET subcompanyid=(SELECT MIN(id) FROM HrmSubCompanyVirtual) WHERE subcompanyid=-1
GO
INSERT INTO HrmDepartmentVirtual (departmentname,departmentcode,departmentmark,supdepid,allsupdepid,subcompanyid1,canceled,showorder,tlevel,ecology_pinyin_search)
select departmentname,departmentcode,departmentmark,supdepid,allsupdepid,subcompanyid1,canceled,showorder,tlevel,ecology_pinyin_search FROM HrmDepartmentVirtual 
WHERE id=-1
GO
UPDATE HrmResourceVirtual SET departmentid=(SELECT MIN(id) FROM HrmDepartmentVirtual) WHERE departmentid=-1
GO
DELETE FROM HrmCompanyVirtual WHERE id=-1
GO
DELETE FROM HrmSubCompanyVirtual WHERE id =-1
GO
DELETE FROM HrmDepartmentVirtual WHERE id =-1
GO