
delete from HtmlLabelIndex where id=20773
/
delete from HtmlLabelInfo where indexid=20773
/
INSERT INTO HtmlLabelIndex values(20773,'自定义查询') 
/
INSERT INTO HtmlLabelInfo VALUES(20773,'自定义查询',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20773,'custom query',8) 
/

delete from HtmlLabelIndex where id=20785
/
delete from HtmlLabelInfo where indexid=20785
/
INSERT INTO HtmlLabelIndex values(20785,'自定义查询设置') 
/
INSERT INTO HtmlLabelInfo VALUES(20785,'自定义查询设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20785,'set custom query',8) 
/

delete from HtmlLabelIndex where id=20778
/
delete from HtmlLabelInfo where indexid=20778
/
INSERT INTO HtmlLabelIndex values(20778,'是否作为查询条件') 
/
INSERT INTO HtmlLabelInfo VALUES(20778,'是否作为查询条件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20778,'query condition',8) 
/

delete from HtmlLabelIndex where id=20779
/
delete from HtmlLabelInfo where indexid=20779
/

INSERT INTO HtmlLabelIndex values(20779,'是否作为列表标题') 
/
INSERT INTO HtmlLabelInfo VALUES(20779,'是否作为列表标题',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20779,'head or table',8) 
/

delete from HtmlLabelIndex where id=20780
/
delete from HtmlLabelInfo where indexid=20780
/

INSERT INTO HtmlLabelIndex values(20780,'是否使用该字段作为查询条件或列表标题') 
/
INSERT INTO HtmlLabelInfo VALUES(20780,'是否使用该字段作为查询条件或列表标题',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20780,'used',8) 
/

delete from SystemRightsLanguage where id=719
/
delete from SystemRightDetail where id=4227
/
delete from SystemRights where id=719
/
insert into SystemRights (id,rightdesc,righttype) values (719,'自定义查询','5') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (719,8,'custom query','custom query') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (719,7,'自定义查询','自定义查询') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4227,'流程自定义查询权限','WorkflowCustomManage:All',719) 
/