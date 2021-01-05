insert into SystemRights (id,rightdesc,righttype) values (464,'离职处理','3') 
Go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (464,7,'离职处理','离职处理') 
Go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (464,8,'','') 
go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3156,'hrm人员离职处理','Resign:Main',464)
go
insert into SystemRightToGroup (groupid,rightid) values (3,464)
go
insert into SystemRightRoles (rightid,roleid,rolelevel) values (464,4,'2')
go
INSERT INTO HtmlLabelIndex values(17568,'离职事宜') 
go
INSERT INTO HtmlLabelInfo VALUES(17568,'离职事宜',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17568,'',8) 
go
INSERT INTO HtmlLabelIndex values(17569,'未处理流程') 
go
INSERT INTO HtmlLabelInfo VALUES(17569,'未处理流程',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17569,'',8) 
go
INSERT INTO HtmlLabelIndex values(17570,'未处理文档') 
go
INSERT INTO HtmlLabelInfo VALUES(17570,'未处理文档',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17570,'',8) 
go
INSERT INTO HtmlLabelIndex values(17571,'未处理客户') 
go
INSERT INTO HtmlLabelInfo VALUES(17571,'未处理客户',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17571,'',8) 
go
INSERT INTO HtmlLabelIndex values(17572,'未处理项目') 
go
INSERT INTO HtmlLabelInfo VALUES(17572,'未处理项目',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17572,'',8) 
go
INSERT INTO HtmlLabelIndex values(17573,'未处理欠款') 
go
INSERT INTO HtmlLabelInfo VALUES(17573,'未处理欠款',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17573,'',8) 
go
INSERT INTO HtmlLabelIndex values(17574,'未处理资产') 
go
INSERT INTO HtmlLabelInfo VALUES(17574,'未处理资产',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17574,'',8) 
go
INSERT INTO HtmlLabelIndex values(17575,'未处理角色') 
go
INSERT INTO HtmlLabelInfo VALUES(17575,'未处理角色',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17575,'',8) 
go
INSERT INTO HtmlLabelIndex values(17576,'人员离职处理') 
go
INSERT INTO HtmlLabelInfo VALUES(17576,'人员离职处理',7) 
go
INSERT INTO HtmlLabelInfo VALUES(17576,'',8) 
go
