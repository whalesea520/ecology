delete from HtmlLabelIndex where id=22353 
GO
delete from HtmlLabelInfo where indexid=22353 
GO
INSERT INTO HtmlLabelIndex values(22353,'大众保险招聘岗位') 
GO
INSERT INTO HtmlLabelInfo VALUES(22353,'大众保险招聘岗位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22353,'General insurance recruitment posts',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22353,'大眾保險招聘崗位',9) 
GO

delete from HtmlLabelIndex where id=22324 
GO
delete from HtmlLabelInfo where indexid=22324 
GO
INSERT INTO HtmlLabelIndex values(22324,'招聘单位') 
GO
INSERT INTO HtmlLabelInfo VALUES(22324,'招聘单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22324,'Recruitment units',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22324,'招聘單位',9) 
GO

delete from HtmlLabelIndex where id=22327 
GO
delete from HtmlLabelInfo where indexid=22327 
GO
INSERT INTO HtmlLabelIndex values(22327,'招聘人数') 
GO
INSERT INTO HtmlLabelInfo VALUES(22327,'招聘人数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22327,'recruitmentcounts',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22327,'招聘人數',9) 
GO

delete from HtmlLabelIndex where id=22325 
GO
delete from HtmlLabelInfo where indexid=22325 
GO
INSERT INTO HtmlLabelIndex values(22325,'招聘职位') 
GO
INSERT INTO HtmlLabelInfo VALUES(22325,'招聘职位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22325,'Recruitment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22325,'招聘職位',9) 
GO


delete from HtmlLabelIndex where id=22326 
GO
delete from HtmlLabelInfo where indexid=22326 
GO
INSERT INTO HtmlLabelIndex values(22326,'截止日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(22326,'截止日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22326,'Deadline',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22326,'截止日期',9) 
GO


delete from HtmlLabelIndex where id=17883 
GO
delete from HtmlLabelInfo where indexid=17883 
GO
INSERT INTO HtmlLabelIndex values(17883,'发布日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(17883,'发布日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17883,'PublishDate',8) 
GO

delete from HtmlLabelIndex where id=22328 
GO
delete from HtmlLabelInfo where indexid=22328 
GO
INSERT INTO HtmlLabelIndex values(22328,'应聘资格') 
GO
INSERT INTO HtmlLabelInfo VALUES(22328,'应聘资格',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22328,'Qualified candidates',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22328,'應聘資格',9) 
GO

delete from HtmlLabelIndex where id=22329 
GO
delete from HtmlLabelInfo where indexid=22329 
GO
INSERT INTO HtmlLabelIndex values(22329,'招聘类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(22329,'招聘类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22329,'Recruitment of the type of',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22329,'招聘類型',9) 
GO

delete from HtmlLabelIndex where id=22330 
GO
delete from HtmlLabelInfo where indexid=22330 
GO
INSERT INTO HtmlLabelIndex values(22330,'总部招聘') 
GO
INSERT INTO HtmlLabelInfo VALUES(22330,'总部招聘',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22330,'Headquarters recruitment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22330,'總部招聘',9) 
GO

delete from HtmlLabelIndex where id=22331 
GO
delete from HtmlLabelInfo where indexid=22331 
GO
INSERT INTO HtmlLabelIndex values(22331,'分公司招聘') 
GO
INSERT INTO HtmlLabelInfo VALUES(22331,'分公司招聘',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22331,'Branch Recruitment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22331,'分公司招聘',9) 
GO

delete from HtmlLabelIndex where id=22332 
GO
delete from HtmlLabelInfo where indexid=22332 
GO
INSERT INTO HtmlLabelIndex values(22332,'校园招聘') 
GO
INSERT INTO HtmlLabelInfo VALUES(22332,'校园招聘',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22332,'Campus Recruitment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22332,'校園招聘',9) 
GO

delete from HtmlLabelIndex where id=22346 
GO
delete from HtmlLabelInfo where indexid=22346 
GO
INSERT INTO HtmlLabelIndex values(22346,'请选择要删除的信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(22346,'请选择要删除的信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22346,'Please select the information you want to delete',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22346,'請選擇要刪除的資訊',9) 
GO

delete from SystemRights where id = 814
GO
delete from SystemRightsLanguage where id = 814
GO
delete from SystemRightDetail where id = 4325
GO

insert into SystemRights (id,rightdesc,righttype) values (814,'招聘岗位','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (814,9,'招聘?位','招聘?位') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (814,7,'招聘岗位','招聘岗位') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (814,8,'Recruitment job','Recruitment job') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4325,'招聘岗位_编辑','ResourcesInformationSystem:ALL',814) 
GO