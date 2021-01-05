alter table hrm_state_proc_action modify field006 number null
/
alter table hrm_state_proc_action add field006_temp number
/
update hrm_state_proc_action set field006_temp=field006,field006=NULL
/
alter table hrm_state_proc_action modify field006 VARCHAR2(1000)
/
update hrm_state_proc_action set field006=to_char(field006_temp),field006_temp=NULL
/
alter table hrm_state_proc_action drop column field006_temp
/