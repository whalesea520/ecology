alter table HrmUserSetting add constraint belongtoshow_df default(1) for belongtoshow 
go
insert into HrmUserSetting (resourceid,rtxOnload,isCoworkHead)
select id,0,1 from hrmresource a where not exists (select 1 from HrmUserSetting b where a.id=b.resourceid)
go
