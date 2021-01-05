declare @subid int
set @subid=1
select top 1 @subid=id   from HrmSubCompany order by  supsubcomid,showorder
update hpinfo set subcompanyid=@subid,creatortype=3,creatorid=@subid where id=1 or id=2
update hplayout set usertype=3,userid=@subid where  hpid in (1,2) and usertype=3 and userid=1
GO