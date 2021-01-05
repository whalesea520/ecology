delete from HtmlLabelIndex where id=21723 
GO
delete from HtmlLabelInfo where indexid=21723 
GO
INSERT INTO HtmlLabelIndex values(21723,'投票后不可查看结果') 
GO
INSERT INTO HtmlLabelInfo VALUES(21723,'投票后不可查看结果',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21723,'After the voting results can not be read',8) 
GO
delete from HtmlLabelIndex where id=21724 
GO
delete from HtmlLabelInfo where indexid=21724 
GO
INSERT INTO HtmlLabelIndex values(21724,'投票已成功，谢谢参与！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21724,'投票已成功，谢谢参与！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21724,'Vote has been successful, thank you participate!',8) 
GO
delete from HtmlLabelIndex where id=21725 
GO
delete from HtmlLabelInfo where indexid=21725 
GO
INSERT INTO HtmlLabelIndex values(21725,'可选项数') 
GO
INSERT INTO HtmlLabelInfo VALUES(21725,'可选项数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21725,'Can be few options',8) 
GO
delete from HtmlLabelIndex where id=21726 
GO
delete from HtmlLabelInfo where indexid=21726 
GO
INSERT INTO HtmlLabelIndex values(21726,'可选取项超过规定,请重新选取') 
GO
INSERT INTO HtmlLabelInfo VALUES(21726,'可选取项超过规定,请重新选取',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21726,'You can select the items over, please re-select',8) 
GO
delete from HtmlLabelIndex where id=21727 
GO
delete from HtmlLabelInfo where indexid=21727 
GO
INSERT INTO HtmlLabelIndex values(21727,'已投票人') 
GO
INSERT INTO HtmlLabelInfo VALUES(21727,'已投票人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21727,'Voters have',8) 
GO
delete from HtmlLabelIndex where id=21728 
GO
delete from HtmlLabelInfo where indexid=21728 
GO
INSERT INTO HtmlLabelIndex values(21728,'未投票人') 
GO
INSERT INTO HtmlLabelInfo VALUES(21728,'未投票人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21728,'People did not vote',8) 
GO

delete from SystemRights where id=792
go
insert into SystemRights (id,rightdesc,righttype) values (792,'调查删除权限','1') 
GO
delete from SystemRightsLanguage where id=792
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (792,7,'调查删除权限','调查删除权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (792,8,'votingDelete','votingDelete') 
GO
delete from SystemRightDetail where id=4302
go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4302,'调查删除权限','voting:delete',792) 
GO
delete from SystemRights where id=793
GO
insert into SystemRights (id,rightdesc,righttype) values (793,'调查详细信息查看权限','1') 
GO
delete from SystemRightsLanguage where id=793
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (793,7,'调查详细信息查看权限','调查详细信息查看权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (793,8,'votingParticular','votingParticular') 
GO
delete from SystemRightDetail where id=4303
go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4303,'调查详细信息查看权限','voting:particular',793) 
GO

delete from HtmlLabelIndex where id=21765 
GO
delete from HtmlLabelInfo where indexid=21765 
GO
INSERT INTO HtmlLabelIndex values(21765,'请输入大于0的数字!') 
GO
INSERT INTO HtmlLabelInfo VALUES(21765,'请输入大于0的数字!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21765,'Please enter the number greater than 0!',8) 
GO