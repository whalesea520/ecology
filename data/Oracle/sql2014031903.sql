alter table workflow_billfield add textheight_2 varchar(50)
/
alter table workflow_formdict add textheight_2 varchar(50)
/
alter table workflow_formdictdetail add textheight_2 varchar(50)
/

update workflow_billfield set textheight_2 = textheight WHERE TYPE IN (165,166,167,168,169,170)
/
update workflow_formdict set textheight_2 = textheight WHERE TYPE IN (165,166,167,168,169,170)
/
update workflow_formdictdetail set textheight_2 = textheight WHERE TYPE IN (165,166,167,168,169,170)
/