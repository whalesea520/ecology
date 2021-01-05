/*将 用工需求权限 加入到 人力资源维护组的默认权限 BUG 227 ,Created BY Huang Yu*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=374
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,374)
GO
DELETE FROM SystemRightRoles WHERE RightID = 374 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (374,4,1)
GO

/*将 招聘计划权限 加入到 人力资源维护组的默认权限 BUG 233,Created By Huang Yu*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=375
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,375)
GO
DELETE FROM SystemRightRoles WHERE RightID = 375 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (375,4,1)
GO

/*修改"其他消息"为"其它消息" BUG 230  Created BY Huang Yu*/
DELETE FROM HtmlLabelIndex WHERE ID = 1847
GO
DELETE FROM HtmlLabelInfo WHERE IndexID = 1847
GO
INSERT INTO HtmlLabelIndex values(1847,'其它要求') 
GO
INSERT INTO HtmlLabelInfo VALUES(1847,'其它要求',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(1847,'Other Request',8) 
GO

/*将该招聘计划页面的‘新建’菜单，修改为‘新建招聘信息 BUG 238  Created BY Huang Yu*/
INSERT INTO HtmlLabelIndex values(17153,'新建招聘信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(17153,'新建招聘信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17153,'New Invitation Info',8) 
GO

Create Table HrmCareerPlanInform(
       ID int identity(1,1) not null primary key,
       CareerPlanID int not null,
       ResourceID int not null,	
       Type int not null default 0,
       StepID int not null
)
GO

/*FOR BUG 260,将salarynow,salaryneed字段的类型改为decimal*/

ALTER TABLE HrmCareerApplyOtherInfo
	ALTER COLUMN salarynow decimal(38,2) 
GO            
ALTER TABLE HrmCareerApplyOtherInfo 
	ALTER COLUMN salaryneed decimal(38,2)
GO

/*For Bug 266*/
ALTER  PROCEDURE [HrmInterviewResult_Insert]
	(@resourceid_1 	[int],
	 @stepid_2 	[int],
	 @result_3 	int,
	 @remark_4 	text,
	 @userid_5 	int,
	 @testdate_6 	char(10),
	 @flag int output, @msg varchar(60) output)
AS INSERT INTO [HrmInterviewResult] 
	 ([resourceid],
	 [stepid],
	 [result],
	 [remark],
	 [tester],
	 [testdate])
VALUES 
	(@resourceid_1,
	 @stepid_2,
	 @result_3,
	 @remark_4,
	 @userid_5,
	 @testdate_6)

update HrmInterview set 
  status = 1 WHERE ResourceID=@resourceid_1 and StepID = @stepid_2

GO
