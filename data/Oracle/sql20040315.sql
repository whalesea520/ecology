CREATE TABLE webSite (
	id integer NOT NULL ,
	name varchar2 (200)  NULL ,
	linkKey varchar2 (200)  NULL ,
	newsId integer NULL ,
	type char (1) NULL,
    researchId integer NULL 
) 
/

create sequence webSite_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           


create or replace trigger webSite_Trigger
before insert on webSite
for each row
begin
select webSite_id.nextval into :new.id from dual;
end;
/
CREATE TABLE bill_onlineRegist
(
    id integer NOT NULL  ,
    requestid  integer NULL ,    
    name varchar2(200) NULL ,
    engname varchar2(200) NULL ,
    address1 varchar2(400) NULL ,
    city integer NULL ,
    phone varchar2(100) NULL ,
    email varchar2(100) NULL ,
    website varchar2(100) NULL ,
    contacterTitle integer NULL,
    contacterName  varchar2(100) NULL ,
    contacterJobTitle  varchar2(100) NULL ,    
    type_n integer NULL ,
    description integer NULL ,
    size_n integer NULL ,
    sector integer NULL ,
    journal varchar2(200) null ,
    crmmanager integer NULL ,
    password varchar2(100) NULL 
    
)
/
create sequence bill_onlineRegist_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           

create or replace trigger bill_onlineRegist_Trigger
before insert on bill_onlineRegist
for each row
begin
select bill_onlineRegist_id.nextval into :new.id from dual;
end;
/
CREATE TABLE webMailList (
	id integer NOT NULL ,
	name varchar2 (200)  NULL ,
	mailDesc varchar2 (400)  NULL ,
    userList varchar2 (4000)  NULL 
) 
/
create sequence webMailList_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           

create or replace trigger webMailList_Trigger
before insert on webMailList
for each row
begin
select webMailList_id.nextval into :new.id from dual;
end;
/

CREATE TABLE DocWebComment (
	id integer NOT NULL ,
    docId integer NULL ,
	name varchar2 (100)  NULL ,
	mail_1 varchar2 (30)  NULL ,
    comment_1 varchar2 (2000)  NULL ,
    createDate char (10) NULL ,
    createTime char (8) NULL 
) 
/
create sequence DocWebComment_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           

create or replace trigger DocWebComment_Trigger
before insert on DocWebComment
for each row
begin
select DocWebComment_id.nextval into :new.id from dual;
end;
/

CREATE INDEX DocWebComment_docId ON DocWebComment(docId) 
/

insert into HtmlLabelIndex (id,indexdesc) values (17059	,'在线注册')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17059,'在线注册',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17059,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (17060	,'公司名称(简称)')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17060,'公司名称(简称)',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17060,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (17061	,'联系人称呼')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17061,'联系人称呼',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17061,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (17062	,'联系人名字')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17062,'联系人名字',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17062,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (17063	,'联系人工作头衔')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17063,'联系人工作头衔',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17063,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (17064	,'订阅邮件')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17064,'订阅邮件',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17064,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (17065	,'邮件列表')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17065,'邮件列表',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (17065,'',8)
/


INSERT INTO HtmlLabelIndex values(17066,'网站管理') 
/
INSERT INTO HtmlLabelIndex values(17067,'网站栏目') 
/
INSERT INTO HtmlLabelIndex values(17068,'查看调查') 
/
INSERT INTO HtmlLabelInfo VALUES(17066,'网站管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17066,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17067,'网站栏目',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17067,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17068,'查看调查',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17068,'',8) 
/

INSERT INTO HtmlLabelIndex values(17069,'评论管理') 
/
INSERT INTO HtmlLabelInfo VALUES(17069,'评论管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17069,'',8) 
/



/* 网站维护 */

CREATE or REPLACE PROCEDURE rightUpdateTemp 
As
rightId_1 integer;
begin
for all_cursor in
(select id from SystemRights  where rightdesc = '网站维护')
loop
        rightId_1 := all_cursor.id ;

        delete from SystemRights where id = rightId_1;
        delete from SystemRightsLanguage where id = rightId_1;
        delete from SystemRightDetail where rightid = rightId_1;        

        update SystemRightRoles set rightid = 406 where rightid = rightId_1;
        update SystemRightToGroup set rightid = 406 where rightid = rightId_1;
        
end loop;
end;
/

call rightUpdateTemp()
/
drop PROCEDURE rightUpdateTemp
/

insert into SystemRights(id,rightdesc,righttype) values(406,'网站维护','0')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(406,7,'网站维护','网站维护')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(406,8,'','')
/

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(3095,'网站维护','WebSiteView:View',406)
/


/*与sunyard会冲突--------------------------------------------------------------------*/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 58,493,'integer','/systeminfo/BrowserMain.jsp?url=/web/broswer/CityBrowser.jsp','HrmCity','cityname','id','')
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 59,462,'integer','/systeminfo/BrowserMain.jsp?url=/web/broswer/ContacterTitleBrowser.jsp','CRM_ContacterTitle','fullname','id','')
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 60,1282,'integer','/systeminfo/BrowserMain.jsp?url=/web/broswer/CustomerTypeBrowser.jsp','CRM_ContractType','name','id','')
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 61,1283,'integer','/systeminfo/BrowserMain.jsp?url=/web/broswer/CustomerDescBrowser.jsp','CRM_CustomerDesc','fullname','id','')
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 62,1285,'integer','/systeminfo/BrowserMain.jsp?url=/web/broswer/CustomerSizeBrowser.jsp','CRM_CustomerSize','fullname','id','')
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 63,575,'integer','/systeminfo/BrowserMain.jsp?url=/web/broswer/SectorInfoBrowser.jsp','CRM_SectorInfo','fullname','id','')
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 64,17065,'varchar2(200)','/systeminfo/BrowserMain.jsp?url=/web/mailList/MailListBrowser.jsp','webMailList','name','id','')
/



INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(68,17059,'bill_onlineRegist','BillOnlineRegistAdd.jsp','','','','','BillOnlineRegistOperation.jsp') 
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'name',1976,'varchar2(200)',1,1,1,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'engname',17060,'varchar2(200)',1,1,2,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'address1',110,'varchar2(400)',1,1,3,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'city',493,'integer',3,58,4,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'email',477,'varchar2(100)',1,1,5,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'website',76,'varchar2(100)',1,1,6,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'contacterTitle',17061,'integer',3,59,7,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'contacterName',17062,'varchar2(100)',1,1,8,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'contacterJobTitle',17063,'varchar2(100)',1,1,9,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'type_n',7179,'integer',3,60,10,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'description',433,'integer',3,61,11,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'size_n',576,'integer',3,62,12,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'sector',575,'integer',3,63,13,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'crmmanager',1278,'integer',3,1,15,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'journal',17064,'varchar2(200)',3,64,14,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'password',409,'varchar2(100)',1,1,16,0)
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (68,'phone',421,'varchar2(100)',1,1,5,0) 
/

/*与sunyard会冲突--------------------------------------------------------------------*/