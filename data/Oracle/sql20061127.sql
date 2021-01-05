INSERT INTO HtmlLabelIndex values(19947,'默认导出文档目录') 
/
INSERT INTO HtmlLabelIndex values(19948,'客户联系附件存放目录') 
/
INSERT INTO HtmlLabelInfo VALUES(19947,'默认导出文档目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19947,'Default Document Cate/ry',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19948,'客户联系附件存放目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19948,'CRM Contact Cate/ry',8) 
/
INSERT INTO HtmlLabelIndex values(19949,'正在导出客户联系，请稍候') 
/
INSERT INTO HtmlLabelInfo VALUES(19949,'正在导出客户联系，请稍候',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19949,'Exporting to CRM contract, please wait',8) 
/
INSERT INTO HtmlLabelIndex values(19950,'正在导出文档，请稍候') 
/
INSERT INTO HtmlLabelInfo VALUES(19950,'正在导出文档，请稍候',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19950,'Exporting to document, please wait',8) 
/
INSERT INTO HtmlLabelIndex values(19951,'确定彻底删除所选的邮件吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19951,'确定彻底删除所选的邮件吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19951,'if confirm delete mails in the folder?',8) 
/


alter table MailSetting add crmSecId integer
/


create or replace procedure Mail2CRMContact(
userid_1 integer,
crmid_2 integer,
mailid_3 integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
begin

INSERT INTO WorkPlan (type_n,begindate,begintime,resourceid,description,name,status,urgentLevel,createrid,createrType,crmid)
SELECT '3',substr(senddate,0,10),substr(senddate,10,8),userid_1,content,subject,'2','1',userid_1,'1',crmid_2 FROM MailResource WHERE id=mailid_3;
open thecursor for
select max(id) from WorkPlan;


end;
/