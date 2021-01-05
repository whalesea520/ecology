INSERT INTO HtmlLabelIndex values(17626,'客户类型已存在,请重新定义类型名称') 
/
INSERT INTO HtmlLabelInfo VALUES(17626,'客户类型已存在,请重新定义类型名称',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17626,'customer type has exist',8) 
/
insert into CRM_CustomerType (fullname,description,candelete,canedit,workflowid)values('个人用户','个人用户','n','n',null)
/

INSERT INTO HtmlLabelIndex values(17706,'个人用户') 
/
INSERT INTO HtmlLabelInfo VALUES(17706,'个人用户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17706,'personal customer',8) 
/

ALTER TABLE CRM_CustomerInfo ADD  Sex  smallint  DEFAULT (0)
/
ALTER TABLE CRM_CustomerInfo ADD IDCardNo  varchar2(50) NULL
/

/*td:1548*/
insert into ErrorMsgIndex values (49,'该行业已经关联客户,不能删除')
/
insert into ErrorMsgInfo values (49,'该行业已经关联客户,不能删除!',7)
/
insert into ErrorMsgInfo values (49,'associated with one client,can''t delete',8)
/
insert into ErrorMsgIndex values (50,'该行业有子行业,不能删除')
/
insert into ErrorMsgInfo values (50,'该行业有子行业,不能删除',7)
/
insert into ErrorMsgInfo values (50,'It has the subordinate profession, can''t delete',8)
/