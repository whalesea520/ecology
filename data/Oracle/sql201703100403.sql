alter table blog_sysSetting add makeUpTime varchar2(5)
/

update blog_sysSetting set makeUpTime = '3'
/

alter table blog_sysSetting add canEditTime varchar2(5)
/

update blog_sysSetting set canEditTime = '5'
/

alter table blog_share add canViewMinTime char(10) default '-1'
/

alter table blog_specifiedShare add canViewMinTime char(10) default '-1'
/

update blog_share set canViewMinTime = -1
/

update blog_specifiedShare set canViewMinTime = -1
/