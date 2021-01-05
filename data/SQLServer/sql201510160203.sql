alter function getchilds
(
    @id int 
) returns  @childtabes TABLE (id int ) 
as 
begin
declare @hrmid int,@childs   nvarchar(4000) 
 
set  @childs='0'
 
declare childid_cursor cursor for   
 WITH allhrm(id,lastname,managerid) as (SELECT id,lastname ,managerid FROM hrmresource where id=@id
 UNION ALL SELECT a.id,a.lastname,a.managerid FROM hrmresource a,allhrm b where a.managerid = b.id and a.managerid !=a.id and a.id!=@id and a.status in (0,1,2,3) and a.loginid is not null and a.loginid<>''
) select id from allhrm 
 
    open childid_cursor fetch next from childid_cursor into @hrmid
 
     while @@fetch_status=0 
      begin 
       insert  @childtabes values(@hrmid)
      fetch next from childid_cursor into  @hrmid
      
      end 
      close childid_cursor
      return 
end

go

alter function getchilds_v
(
    @id int 
) returns  @childtabes TABLE (id int ) 
as 
begin
declare @hrmid int,@childs   nvarchar(4000) 
 
set  @childs='0'
 
declare childid_cursor cursor for   
 WITH allhrm(id,managerid,virtualtype) as (SELECT resourceid ,managerid,virtualtype FROM hrmresourcevirtual where resourceid=@id
 UNION ALL SELECT a.resourceid,a.managerid,a.virtualtype FROM hrmresourcevirtual a join hrmresource c on ( c.id=a.resourceid and c.status in (0,1,2,3) and c.loginid is not null and c.loginid<>'') ,allhrm b where  a.managerid = b.id and a.managerid !=a.resourceid and a.resourceid!=@id and a.virtualtype=b.virtualtype
) select distinct id from allhrm
 
    open childid_cursor fetch next from childid_cursor into @hrmid
 
     while @@fetch_status=0 
      begin 
       insert  @childtabes values(@hrmid)
      fetch next from childid_cursor into  @hrmid
      
      end 
      close childid_cursor
      return 
end

go

alter function getparents
(
    @id int 
) returns  @childtabes TABLE (id int ) 
as 
begin
declare @hrmid int,@childs   nvarchar(4000) 
 
set  @childs='0'
 
declare childid_cursor cursor for   
 WITH allhrm(id,lastname,managerid) as (SELECT id,lastname ,managerid FROM hrmresource where id=@id
 UNION ALL SELECT a.id,a.lastname,a.managerid FROM hrmresource a,allhrm b where a.id = b.managerid and a.managerid !=a.id and a.id!=@id and a.status in (0,1,2,3) and a.loginid is not null and a.loginid<>''
) select id from allhrm
 
    open childid_cursor fetch next from childid_cursor into @hrmid
 
     while @@fetch_status=0 
      begin 
       insert  @childtabes values(@hrmid)
      fetch next from childid_cursor into  @hrmid
      
      end 
      close childid_cursor
      return 
end

go

alter function getparents_v
(
    @id int 
) returns  @childtabes TABLE (id int ) 
as 
begin
declare @hrmid int,@childs   nvarchar(4000) 
 
set  @childs='0'
 
declare childid_cursor cursor for   
 WITH allhrm(id,managerid,virtualtype) as (SELECT resourceid,managerid,virtualtype FROM hrmresourcevirtual where resourceid=@id
 UNION ALL SELECT a.resourceid,a.managerid,a.virtualtype FROM hrmresourcevirtual a join hrmresource c on ( c.id=a.resourceid and c.status in (0,1,2,3) and c.loginid is not null and c.loginid<>'') ,allhrm b where a.resourceid = b.managerid and a.managerid !=a.resourceid and a.resourceid!=@id and a.virtualtype=b.virtualtype
) select distinct id from allhrm
 
    open childid_cursor fetch next from childid_cursor into @hrmid
 
     while @@fetch_status=0 
      begin 
       insert  @childtabes values(@hrmid)
      fetch next from childid_cursor into  @hrmid
      
      end 
      close childid_cursor
      return 
end
go
