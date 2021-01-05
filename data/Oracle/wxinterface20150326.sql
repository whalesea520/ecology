alter table wx_msgrulesetting rename column flowsordocs to flowsordocs_c
/
alter table wx_msgrulesetting add flowsordocs clob
/
update wx_msgrulesetting set flowsordocs = flowsordocs_c
/
alter table wx_msgrulesetting drop column flowsordocs_c
/

alter table wx_msgrulesetting rename column names to names_c
/
alter table wx_msgrulesetting add names clob
/
update wx_msgrulesetting set names = names_c
/
alter table wx_msgrulesetting drop column names_c
/

alter table wx_msgrulesetting rename column typeids to typeids_c
/
alter table wx_msgrulesetting add typeids clob
/
update wx_msgrulesetting set typeids = typeids_c
/
alter table wx_msgrulesetting drop column typeids_c
/
