alter table DataCenterUserSetting add meetting varchar(20) 
/
alter table DataCenterUserSetting add meettingcolor varchar(20) 
/
alter table DataCenterUserSetting add workplan varchar(20) 
/
alter table DataCenterUserSetting add workplancolor varchar(20) 
/
update DataCenterUserSetting set meetting ='0',meettingcolor='#6871E3',workplan = '0', workplancolor='#CB61FE'
/
