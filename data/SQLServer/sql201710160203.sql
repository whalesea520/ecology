delete from hrm_transfer_set where code_name in ('Temail001','Temail002') and type=0 
go
insert into hrm_transfer_set(type,name,code_name,link_address,class_name) values (0,'内部邮件（收件箱）','Temail001','/email/transfer/EmailTab.jsp?_fromURL=Temail001&folderid=0','weaver.hrm.authority.manager.EmailManager')
go
insert into hrm_transfer_set(type,name,code_name,link_address,class_name) values (0,'内部邮件（已发送）','Temail002','/email/transfer/EmailTab.jsp?_fromURL=Temail002&folderid=-1','weaver.hrm.authority.manager.EmailManager')
go