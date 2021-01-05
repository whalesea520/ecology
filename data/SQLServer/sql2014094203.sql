alter table CptCapitalShareInfo add isdefault int
go

alter table Prj_ShareInfo add isdefault int
go

CREATE TABLE prj_members(id int IDENTITY (1, 1) not null,relateditemid int null,userid int null)
GO

create trigger trg_prjmembers_update
on Prj_ProjectInfo
after insert,update,delete
as
	declare @prjid int;
	declare @members varchar(4000);
	declare @isblock int;
	declare @idx int;
	declare @userid int;
	
	begin
	    select @members=members+',',@prjid=id,@isblock=isblock from inserted;
	    delete from prj_members where relateditemid=@prjid;
	   	
	   	if @isblock!=1 return;
	   	if @members='' return;
	   	if @members is null return;
	   	
	   	set @idx=CHARINDEX(',',@members)
		while @idx>0
		begin
			set @userid=convert(int, SUBSTRING(@members,0,@idx));
		 	insert into prj_members(relateditemid,userid) values(@prjid,@userid);
		 	set @members=SUBSTRING(@members,@idx+1,LEN(@members));
		 	set @idx=CHARINDEX(',',@members);
		end
		
	end
go


create function getchilds
(
    @id int 
) returns  @childtabes TABLE (id int ) 
as 
begin
declare @hrmid int,@childs   nvarchar(4000) 
 
set  @childs='0'
 
declare childid_cursor cursor for   
 WITH allhrm(id,lastname,managerid) as (SELECT id,lastname ,managerid FROM hrmresource where id=@id
 UNION ALL SELECT a.id,a.lastname,a.managerid FROM hrmresource a,allhrm b where a.managerid = b.id and a.managerid !=a.id and a.status in (0,1,2,3) and a.loginid is not null and a.loginid<>''
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


create function getparents
(
    @id int 
) returns  @childtabes TABLE (id int ) 
as 
begin
declare @hrmid int,@childs   nvarchar(4000) 
 
set  @childs='0'
 
declare childid_cursor cursor for   
 WITH allhrm(id,lastname,managerid) as (SELECT id,lastname ,managerid FROM hrmresource where id=@id
 UNION ALL SELECT a.id,a.lastname,a.managerid FROM hrmresource a,allhrm b where a.id = b.managerid and a.managerid !=a.id and a.status in (0,1,2,3) and a.loginid is not null and a.loginid<>''
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


CREATE PROCEDURE [CptAstShareInfo_Insert_dft] 
(@relateditemid_1 [int], @sharetype_2 [tinyint], @seclevel_3 [tinyint], @rolelevel_4 [tinyint], @sharelevel_5 [tinyint], @userid_6 [int], @departmentid_7 [int], @roleid_8 [int], @foralluser_9 [tinyint], @sharefrom_10 int ,@subcompanyid_11 int , @flag integer output, @msg varchar(80) output)  
AS 
INSERT INTO [CptCapitalShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser], sharefrom,[subcompanyid],isdefault)  VALUES ( @relateditemid_1, @sharetype_2, @seclevel_3, @rolelevel_4, @sharelevel_5, @userid_6, @departmentid_7, @roleid_8, @foralluser_9, @sharefrom_10,@subcompanyid_11,1);

go


CREATE PROCEDURE CptShareInfo_Insert_dft (@relateditemid_1 [int], @sharetype_2 [tinyint], @seclevel_3 [tinyint], @rolelevel_4 [tinyint], @sharelevel_5 [tinyint], @userid_6 [int], @departmentid_7 [int], @roleid_8 [int], @foralluser_9 [tinyint],@subcompanyid_10 [int], @flag integer output, @msg varchar(80) output)  
AS 
INSERT INTO [CptCapitalShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser],[subcompanyid],[isdefault])  VALUES ( @relateditemid_1, @sharetype_2, @seclevel_3, @rolelevel_4, @sharelevel_5, @userid_6, @departmentid_7, @roleid_8, @foralluser_9,@subcompanyid_10,1)  select max(id)  id from CptCapitalShareInfo 
go





create trigger trg_cptshr6_upd
on cptcapital
after update
as
	if update(resourceid)
	declare @new_resourceid int;
	declare @old_resourceid int;
	declare @isdata int;
	declare @newid int;
	
	begin
	    select @new_resourceid=resourceid,@isdata=isdata,@newid=id from inserted;
	    select @old_resourceid=resourceid from deleted;
	   	if @isdata=1 return;
	   	if @isdata is null return;
	   	if @new_resourceid=@old_resourceid return;
	   	
		if @new_resourceid>0
		begin
			DELETE FROM CptCapitalShareInfo WHERE relateditemid=@newid AND sharetype=6 ;
		 	INSERT INTO [CptCapitalShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser],[subcompanyid],[isdefault])  
		 	VALUES ( @newid, 6, 0, null, 2, @new_resourceid, null, null, null,null,1);
		end
	end
go


drop procedure Prj_ShareInfo_Update
GO
CREATE PROCEDURE Prj_ShareInfo_Update 
( @typeid_1 int , @prjid_1 int, @flag integer output , @msg varchar(80) output ) 
as 
declare @theid_1 int, @all_cursor cursor, @relateditemid_1 int  , @sharetype_1 tinyint , @seclevel_1 tinyint  , @rolelevel_1 tinyint  , @sharelevel_1 tinyint  , @userid_1 int  , @departmentid_1 int  , @roleid_1 int  , @foralluser_1 tinyint  , @crmid_1 int  
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select id from Prj_T_ShareInfo WHERE relateditemid = @typeid_1 OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @theid_1 WHILE @@FETCH_STATUS = 0 begin  select   @sharetype_1 =sharetype, @seclevel_1 =seclevel , @rolelevel_1= rolelevel, @sharelevel_1 =sharelevel,@userid_1 =userid,@departmentid_1 =departmentid, @roleid_1 =roleid,@foralluser_1 =foralluser,@crmid_1 =crmid from Prj_T_ShareInfo WHERE id = @theid_1 
insert INTO  Prj_ShareInfo (relateditemid ,	sharetype  ,seclevel ,rolelevel  ,sharelevel,userid ,departmentid ,	roleid,	foralluser ,crmid,isdefault ) 			values(@prjid_1,@sharetype_1,@seclevel_1,@rolelevel_1,@sharelevel_1,@userid_1,@departmentid_1,			@roleid_1,@foralluser_1,@crmid_1,1) FETCH NEXT FROM @all_cursor INTO @theid_1 end CLOSE @all_cursor DEALLOCATE @all_cursor
go




















