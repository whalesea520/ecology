alter PROCEDURE IDirAccessControlDetailP as
declare  @id_1         integer;
declare  @dirid_1         integer;
declare  @dirtype_1      integer;
declare  @seclevel_1     integer
declare  @departmentid_1      integer;
declare  @subcompanyid_1      integer;
declare  @userid_1            integer;
declare  @usertype_1        integer;
declare  @sharelevel_1       integer;
declare  @roleid_1            integer;
declare  @rolelevel_1         integer;
declare  @permissiontype_1  integer;
declare  @operationcode_1 integer;
declare  @docSecCategoryTemplateId_1 integer;
declare @sourceid_1           integer;
declare  @type_1		    integer;
declare  @content_1		    integer;
declare  @sourcetype_1        integer;
declare  @srcfrom_1        integer;
begin
	DELETE from DirAccessControlDetail ;
	declare share_cursor cursor for   	
	select mainid,dirid, dirtype, seclevel, userid, subcompanyid, departmentid, usertype, roleid, rolelevel, operationcode,permissiontype, DocSecCategoryTemplateId 
	from DirAccessControlList
	where dirtype >0 and dirid >0
	open share_cursor fetch next from share_cursor into @id_1,@dirid_1,@dirtype_1,@seclevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@usertype_1,@roleid_1,@rolelevel_1,@operationcode_1,@permissiontype_1,@DocSecCategoryTemplateId_1
	while @@fetch_status=0 
		begin
			set	@srcfrom_1 = @id_1;
			set	@sourceid_1= @dirid_1;
			set	@sourcetype_1= @dirtype_1;
			set	@type_1= @permissiontype_1;
			set	@sharelevel_1 = @operationcode_1;
			if @type_1=1         
				set @content_1 = @departmentid_1;
			else if @type_1=2   
				set @content_1 =  convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),@rolelevel_1)));
				
			else if @type_1=3   
				begin
					set @seclevel_1 = @seclevel_1;
					set @content_1 = 0;
				end
			else if @type_1=4    
				set  @content_1 = @usertype_1;
			else if @type_1=5    
				begin
					set  @content_1 = @userid_1;
					set  @seclevel_1 = 0; 
				end
			else if @type_1=6    
				set @content_1 = @subcompanyid_1;
				 insert into DirAccessControlDetail
				(
					sourceid,
					type,
					content,
					seclevel,
					sharelevel,
					sourcetype,
					srcfrom
				 )values(
					@sourceid_1,
					@type_1,
					@content_1,
					@seclevel_1,
					@sharelevel_1,
					@sourcetype_1,
					@srcfrom_1
				 )
				 if @rolelevel_1 = 0 
				   begin
				       set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),1)));
				        insert into DirAccessControlDetail
						(
							sourceid,
							type,
							content,
							seclevel,
							sharelevel,
							sourcetype,
							srcfrom
						 )values(
							@sourceid_1,
							@type_1,
							@content_1,
							@seclevel_1,
							@sharelevel_1,
							@sourcetype_1,
							@srcfrom_1
						 )
						set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),2)));
				        insert into DirAccessControlDetail
						(
							sourceid,
							type,
							content,
							seclevel,
							sharelevel,
							sourcetype,
							srcfrom
						 )values(
							@sourceid_1,
							@type_1,
							@content_1,
							@seclevel_1,
							@sharelevel_1,
							@sourcetype_1,
							@srcfrom_1
						 )
				   end
				else if @rolelevel_1=1 
				   begin
						set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),2)));
				        insert into DirAccessControlDetail
						(
							sourceid,
							type,
							content,
							seclevel,
							sharelevel,
							sourcetype,
							srcfrom
						 )values(
							@sourceid_1,
							@type_1,
							@content_1,
							@seclevel_1,
							@sharelevel_1,
							@sourcetype_1,
							@srcfrom_1
						 )
				   end
				fetch next from share_cursor into @id_1, @dirid_1,@dirtype_1,@seclevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@usertype_1,@roleid_1,@rolelevel_1,@operationcode_1,@permissiontype_1,@DocSecCategoryTemplateId_1;
	end
	close share_cursor deallocate share_cursor	
end
GO
exec IDirAccessControlDetailP
GO
alter trigger Tri_I_DirAccessControlList on DirAccessControlList for insert
as
declare  @id_1         integer;
declare  @dirid_1         integer;
declare  @dirtype_1      integer;
declare  @seclevel_1     integer
declare  @departmentid_1      integer;
declare  @subcompanyid_1      integer;
declare  @userid_1            integer;
declare  @usertype_1        integer;
declare  @sharelevel_1       integer;
declare  @roleid_1            integer;
declare  @rolelevel_1         integer;
declare  @permissiontype_1  integer;
declare  @operationcode_1 integer;
declare  @docSecCategoryTemplateId_1 integer;
declare @sourceid_1           integer;
declare  @type_1		    integer;
declare  @content_1		    integer;
declare  @sourcetype_1        integer;
declare  @srcfrom_1        integer;
select @id_1 =mainid, @dirid_1=dirid,@dirtype_1=dirtype,@seclevel_1=seclevel,@userid_1=userid,@subcompanyid_1=subcompanyid,@departmentid_1=departmentid,@usertype_1=usertype,@roleid_1=roleid,@rolelevel_1=rolelevel,@operationcode_1=operationcode,@permissiontype_1=permissiontype,@DocSecCategoryTemplateId_1=DocSecCategoryTemplateId FROM inserted 
set	@srcfrom_1 = @id_1;
set	@sourceid_1= @dirid_1;
set	@sourcetype_1= @dirtype_1;
set	@type_1= @permissiontype_1;
set	@sharelevel_1 = @operationcode_1;
if @type_1=1         
	set @content_1 = @departmentid_1;
else if @type_1=2   
	set @content_1 =  convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),@rolelevel_1)));
else if @type_1=3   
	begin
		set @seclevel_1 = @seclevel_1;
		set @content_1 = 0;
	end
else if @type_1=4   
	set  @content_1 = @usertype_1;
else if @type_1=5   
	begin
		set  @content_1 = @userid_1;
		set  @seclevel_1 = 0; 
	end
else if @type_1=6    
	set @content_1 = @subcompanyid_1;
 insert into DirAccessControlDetail
(
	sourceid,
	type,
	content,
	seclevel,
	sharelevel,
	sourcetype,
	srcfrom
 )values(
	@sourceid_1,
	@type_1,
	@content_1,
	@seclevel_1,
	@sharelevel_1,
	@sourcetype_1,
	@srcfrom_1
 )
 if @rolelevel_1 = 0 
   begin
       set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),1)));
        insert into DirAccessControlDetail
		(
			sourceid,
			type,
			content,
			seclevel,
			sharelevel,
			sourcetype,
			srcfrom
		 )values(
			@sourceid_1,
			@type_1,
			@content_1,
			@seclevel_1,
			@sharelevel_1,
			@sourcetype_1,
			@srcfrom_1
		 )
		set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),2)));
        insert into DirAccessControlDetail
		(
			sourceid,
			type,
			content,
			seclevel,
			sharelevel,
			sourcetype,
			srcfrom
		 )values(
			@sourceid_1,
			@type_1,
			@content_1,
			@seclevel_1,
			@sharelevel_1,
			@sourcetype_1,
			@srcfrom_1
		 )
   end
else if @rolelevel_1>0  
   begin
		set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),2)));
        insert into DirAccessControlDetail
		(
			sourceid,
			type,
			content,
			seclevel,
			sharelevel,
			sourcetype,
			srcfrom
		 )values(
			@sourceid_1,
			@type_1,
			@content_1,
			@seclevel_1,
			@sharelevel_1,
			@sourcetype_1,
			@srcfrom_1
		 )
   end
GO