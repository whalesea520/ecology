alter table HrmUserSetting modify belongtoshow integer default 1
/
insert into HrmUserSetting (resourceid,rtxOnload,isCoworkHead)
select id,0,1 from hrmresource a where not exists (select 1 from HrmUserSetting b where a.id=b.resourceid)
/