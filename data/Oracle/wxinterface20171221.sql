alter table wx_msgrulesetting rename column resourceids to resourceids_c
/
alter table wx_msgrulesetting add resourceids varchar2(4000)
/
update wx_msgrulesetting set resourceids = resourceids_c
/
alter table wx_msgrulesetting drop column resourceids_c
/