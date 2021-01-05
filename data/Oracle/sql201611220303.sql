alter table SOCIAL_IMCONVERSATION add msgcontent_bk nvarchar2(2000)
/
update SOCIAL_IMCONVERSATION set msgcontent_bk = msgcontent
/
alter table SOCIAL_IMCONVERSATION drop column msgcontent
/
alter table SOCIAL_IMCONVERSATION rename column msgcontent_bk to msgcontent
/