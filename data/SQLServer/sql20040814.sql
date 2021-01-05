
/* TD577 */
CREATE TABLE [CptBorrowBuffer] (
[id] [int] IDENTITY (1, 1) NOT NULL,
[cptId] [int] NULL,
[useDate] [char] (10) NULL,
[deptId] [int] NULL,
[userId] [int] NULL,
[depositary] [varchar] (200) NULL,
[remark] [text] NULL,
PRIMARY KEY([id])
)
GO

CREATE PROCEDURE CptBorrowBuffer_Insert (
@cptId_1 int, @useDate_1 char(10), @deptId_1 int, @userId_1 int, @depositary_1 varchar(200), 
@remark_1 text, @flag integer output , @msg varchar(80) output)
AS
IF EXISTS(SELECT cptId FROM CptBorrowBuffer WHERE cptId = @cptId_1)
BEGIN
SELECT -1 RETURN
END
INSERT INTO CptBorrowBuffer (
cptId, useDate, deptId, userId, depositary, remark) VALUES (
@cptId_1, @useDate_1, @deptId_1, @userId_1, @depositary_1, @remark_1)
GO

insert into ErrorMsgIndex (id,indexdesc) values (36,'该资产已被申请借用！') 
GO

insert into ErrorMsgInfo (indexid,msgname,languageid) values (36, '该资产已被申请借用！', 7) 
GO
insert into ErrorMsgInfo (indexid,msgname,languageid) values (36, 'This capital has been applied to borrow!', 8) 
GO

CREATE PROCEDURE CptBorrowBuffer_Check (
@currDate char(10), @flag integer output , @msg varchar(80) output)
AS
DECLARE @m_recId int
DECLARE @m_cptId int
DECLARE @m_useDate char(10)
DECLARE @m_deptId int
DECLARE @m_userId int
DECLARE @m_depositary varchar(200)
DECLARE @m_remark varchar(4000)
DECLARE all_cursor CURSOR FOR
SELECT id, cptId, useDate, deptId, userId, depositary, remark FROM CptBorrowBuffer
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_recId, @m_cptId, @m_useDate, @m_deptId, @m_userId, @m_depositary, @m_remark
WHILE (@@FETCH_STATUS = 0) BEGIN
	IF (@currDate = @m_useDate) BEGIN
		EXEC CptUseLogLend_Insert @m_cptId, @m_useDate, @m_deptId, @m_userId, 1, @m_depositary, 0, '', 0, '3', @m_remark, 0, '', ''
		DELETE CptBorrowBuffer WHERE id = @m_recId
	END

	FETCH NEXT FROM all_cursor INTO @m_recId, @m_cptId, @m_useDate, @m_deptId, @m_userId, @m_depositary, @m_remark
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

UPDATE HtmlLabelIndex SET indexdesc = '借用' WHERE id = 1379
GO
UPDATE HtmlLabelInfo SET labelname = '借用' WHERE indexid = 1379 AND languageid = 7
GO

UPDATE HtmlLabelIndex SET indexdesc = '借用日期' WHERE id = 1404
GO
UPDATE HtmlLabelInfo SET labelname = '借用日期' WHERE indexid = 1404 AND languageid = 7
GO

/*FOR BUG 579 需求：不能提交减损日期大于当日日期的资产减损流程 by 路鹏*/
insert into HtmlNoteIndex (id,indexdesc) values (57,'减损日期必须小于当前日期！') 
GO

insert into HtmlNoteInfo (indexid,notename,languageid) values (57, '减损日期必须小于当前日期！', 7) 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (57, 'The selected date should be earlier than current.', 8) 
GO

/*TD 589 */
insert into HtmlNoteIndex (id,indexdesc) values (60,'维修日期必须小于当前日期！') 
GO

insert into HtmlNoteInfo (indexid,notename,languageid) values (60, '维修日期必须小于当前日期！', 7) 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (60, 'The repair date should be not later than current date!', 8) 
GO

/*  FOR BUG 670 浏览按钮表现形式的‘ 资产种类’类型名称修改为‘产品种类’*/

update workflow_browserurl  set labelid=15106 where id=13
go

/*  FOR BUG 675 允许流程表单名称输入50个汉字或字符*/
alter table workflow_formbase alter column formname varchar(100)
go
alter table workflow_formbase alter column formdesc varchar(200)
go

/*  FOR BUG 741  称呼设置新建和编辑页面的‘使用’字段名称修改为‘ 使用方法’*/
INSERT INTO HtmlLabelIndex values(17504,'使用方法') 
GO
INSERT INTO HtmlLabelInfo VALUES(17504,'使用方法',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17504,'Usage',8) 
GO

/*TD 746 */
  ALTER PROCEDURE CRM_AddressType_Delete (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
  AS 
  IF EXISTS(SELECT typeid FROM CRM_CustomerAddress WHERE typeid = @id) BEGIN
SELECT -1 
RETURN
END
  DELETE [CRM_AddressType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'
GO

/*TD 750 */
ALTER PROCEDURE CRM_ContactWay_Delete (
@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
AS 
IF EXISTS(SELECT id FROM CRM_CustomerInfo WHERE source = @id) 
BEGIN
SELECT -1
RETURN
END
DELETE [CRM_ContactWay] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'
GO

/*TD 758 */
INSERT INTO HtmlLabelIndex values(17507,'上级行业') 
GO
INSERT INTO HtmlLabelInfo VALUES(17507,'上级行业',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17507,'The superior trade',8) 
GO

/*TD 760 */
insert into HtmlNoteIndex (id,indexdesc) values (62,'上下级行业不能一样。') 
GO

insert into HtmlNoteInfo (indexid,notename,languageid) values (62, '上下级行业不能一样。', 7) 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (62, 'The parent vacation can not be himself.', 8) 
GO

/*TD 761 */
  ALTER PROCEDURE CRM_SectorInfo_Delete (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
  AS 
  IF EXISTS(SELECT id FROM CRM_SectorInfo WHERE sectors LIKE ('%,' + CONVERT(varchar(4), @id) + ',%'))
  BEGIN
  SELECT -1 
  RETURN
  END
  IF EXISTS(SELECT id FROM CRM_CustomerInfo WHERE sector = @id)
  BEGIN
  SELECT -2
  RETURN
  END
  DELETE [CRM_SectorInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'
GO
/*TD 764 */
  ALTER PROCEDURE CRM_CustomerSize_Delete (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
  AS 
  IF EXISTS(SELECT id FROM CRM_CustomerInfo WHERE size_n = @id)
  BEGIN
  SELECT -1
  RETURN
  END
  DELETE [CRM_CustomerSize] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'
GO

/*TD 771 */
  ALTER PROCEDURE CRM_CustomerType_Delete (@id [int], @flag [int]	output, @msg [varchar](80) output) 
  AS 
  IF EXISTS(SELECT id FROM CRM_CustomerInfo WHERE type = @id)
  BEGIN
  SELECT -1
  RETURN
  END
  DELETE [CRM_CustomerType] WHERE ( [id] = @id) set @flag = 1 set @msg = 'OK!'
GO

/*TD 776 */
  ALTER PROCEDURE CRM_CustomerDesc_Delete (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
  AS 
  IF EXISTS(SELECT id FROM CRM_CustomerInfo WHERE description = @id)
  BEGIN
  SELECT -1
  RETURN
  END
  DELETE [CRM_CustomerDesc] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'
GO
/* TD 780*/

ALTER PROCEDURE CRM_Evaluation_L_Select (
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
SELECT * FROM CRM_Evaluation_Level ORDER BY levelvalue
GO

CREATE PROCEDURE CRM_Evaluation_Init (@flag int output, @msg varchar(80) output)
AS
DECLARE @m_crmId int
DECLARE @m_crmValue decimal(10, 2)
DECLARE @m_evaId int
DECLARE @m_evaValue int
DECLARE @m_flag char(1)
DECLARE all_cursor CURSOR FOR
SELECT id, evaluation FROM CRM_CustomerInfo
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_crmId, @m_crmValue
WHILE (@@FETCH_STATUS = 0)
BEGIN 
    IF @m_crmValue IS NOT NULL
    BEGIN
        SET @m_flag = '0'
        DECLARE m_cursor CURSOR FOR
        SELECT id, levelvalue FROM CRM_Evaluation_Level ORDER BY levelvalue
        OPEN m_cursor
        FETCH NEXT FROM m_cursor INTO @m_evaId, @m_evaValue
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
            IF @m_crmValue <= @m_evaValue 
            BEGIN
                UPDATE CRM_CustomerInfo SET evaluation = @m_evaId WHERE id = @m_crmId
                SET @m_flag = '1'
                BREAK
            END
            FETCH NEXT FROM m_cursor INTO @m_evaId, @m_evaValue
        END
        IF @m_flag = '0'
            UPDATE CRM_CustomerInfo SET evaluation = NULL WHERE id = @m_crmId
            
        CLOSE m_cursor 
        DEALLOCATE m_cursor
    END
    
    FETCH NEXT FROM all_cursor INTO @m_crmId, @m_crmValue
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

EXEC CRM_Evaluation_Init '',''
GO

DROP PROCEDURE CRM_Evaluation_Init
GO

ALTER TABLE CRM_CustomerInfo ALTER COLUMN evaluation int NULL
GO

ALTER PROCEDURE CRM_Evaluation_L_Delete
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS 
IF EXISTS(SELECT id FROM CRM_CustomerInfo WHERE evaluation = @id_1)
BEGIN
SELECT -1
RETURN
END

DELETE CRM_Evaluation_Level WHERE id = @id_1
GO

/*TD 786 */
insert into SystemRights (id,rightdesc,righttype) values (443,'销售机会维护','0') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (443,7,'销售机会维护','销售机会维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (443,8,'Sales Chance Maintenance','Sales Chance Maintenance') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3134,'销售机会维护','CrmSalesChance:Maintenance',443) 
GO
 
insert into SystemRightToGroup (groupid, rightid) values (6, 443)
GO

/*TD 788 */
ALTER PROCEDURE CRM_SellStatus_Delete 
 (@id 	int,
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS 
 IF EXISTS(SELECT id FROM CRM_SellChance WHERE sellstatusid = @id)
 BEGIN
 SELECT -1
 RETURN
 END
 DELETE CRM_SellStatus  WHERE ( id	 = @id) 
 
GO

/*TD 791*/
ALTER PROCEDURE CRM_Successfactor_Delete 
 (@id 	int,
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS 
 IF EXISTS(SELECT id FROM CRM_SellChance WHERE sufactor = @id)
 BEGIN
 SELECT -1
 RETURN
 END
 DELETE CRM_Successfactor  WHERE ( id	 = @id) 
 
GO

/*TD 794*/
ALTER PROCEDURE CRM_Failfactor_Delete 
 (@id 	int,
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS 
 IF EXISTS(SELECT id FROM CRM_SellChance WHERE defactor = @id)
 BEGIN
 SELECT -1
 RETURN
 END
 DELETE CRM_Failfactor  WHERE ( id	 = @id) 
 
GO

/*TD 795*/
ALTER PROCEDURE CRM_ContractType_Delete
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS 
IF EXISTS(SELECT id FROM CRM_Contract WHERE typeId = @id_1)
 BEGIN
 SELECT -1
 RETURN
 END
DELETE [CRM_ContractType] WHERE ( [id]	 = @id_1)
GO

/* TD 828*/
INSERT INTO HtmlLabelIndex values(17539,'使用新地址') 
GO
INSERT INTO HtmlLabelInfo VALUES(17539,'使用新地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17539,'Use New Address',8) 
GO

INSERT INTO HtmlLabelIndex values(17540,'恢复默认地址') 
GO
INSERT INTO HtmlLabelInfo VALUES(17540,'恢复默认地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17540,'Roll Back',8) 
GO 