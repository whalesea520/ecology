delete from AppFormUI where id in (select a.id from AppFormUI a left join mobileAppBaseInfo b on a.appid=b.id where b.id is null)
go
delete from AppFieldUI where id in (select a.id from AppFieldUI a left join AppFormUI b on a.formuiid=b.id where b.id is null)
go
delete from AppHomepage where id in (select a.id from AppHomepage a left join mobileAppBaseInfo b on a.appid=b.id where b.id is null)
go
delete from MobileExtendComponent where id in (select a.id from MobileExtendComponent a left join AppHomepage b on a.objid=b.id where b.id is null)
go
delete from mobileAppModelInfo where id in (select a.id from mobileAppModelInfo a left join mobileAppBaseInfo b on a.appId=b.id where b.id is null)
go