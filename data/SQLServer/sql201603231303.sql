ALTER trigger Tri_I_DirAccessControlList on DirAccessControlList for insert
as
declare  @id_1         integer;
declare  @dirid_1         integer;
declare  @dirtype_1      integer;
declare  @seclevel_1     integer;
declare  @seclevelmax_1     integer;
declare  @includesub_1     integer;
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
declare  @sourceid_1           integer;
declare  @type_1		    integer;
declare  @content_1		    integer;
declare  @sourcetype_1        integer;
declare  @srcfrom_1        integer;

declare @joblevel int;
declare @jobdepartment int;
declare @jobsubcompany int;
declare @jobids int;

declare  @detail_insert_cursor cursor;
if EXISTS(SELECT 1 FROM inserted)  
begin
    set @detail_insert_cursor = cursor FORWARD_ONLY static for select mainid, dirid,dirtype,seclevel,seclevelmax,includesub,userid,subcompanyid,departmentid,usertype,roleid,rolelevel,operationcode,permissiontype,DocSecCategoryTemplateId,joblevel,jobdepartment,jobsubcompany,jobids  from inserted
    OPEN @detail_insert_cursor 
    fetch next from @detail_insert_cursor INTO @id_1 , @dirid_1,@dirtype_1,@seclevel_1,@seclevelmax_1,@includesub_1,@userid_1,@subcompanyid_1,@departmentid_1,@usertype_1,@roleid_1,@rolelevel_1,@operationcode_1,@permissiontype_1,@docSecCategoryTemplateId_1,@joblevel,@jobdepartment,@jobsubcompany,@jobids
    while @@FETCH_STATUS = 0 
    begin 
        begin
            set	@srcfrom_1 = @id_1;
            set	@sourceid_1= @dirid_1;
            set	@sourcetype_1= @dirtype_1;
            set	@type_1= @permissiontype_1;
            set	@sharelevel_1 = @operationcode_1;

	    if @type_1=10         /*部门+安全级别*/
	        begin
            	  set @content_1 = @jobids;
		  set  @seclevel_1 = 0; 
            	  set  @seclevelmax_1 = 255;
		end

            else if @type_1=1         /*部门+安全级别*/
	          begin
            	  set @content_1 = @departmentid_1;
		          set @includesub_1 = @includesub_1;
		      end
            else if @type_1=2   /*角色+安全级别+级别*/
            	set @content_1 =  convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),@rolelevel_1)));
            else if @type_1=3   /*安全级别*/
            	begin
            		set @seclevel_1 = @seclevel_1;
            		set @seclevelmax_1 = @seclevelmax_1;
            		set @content_1 = 0;
            	end
            else if @type_1=4    /*用户类型+安全级别*/
            	set  @content_1 = @usertype_1;
            else if @type_1=5    /*人力资源*/
            	begin
            		set  @content_1 = @userid_1;
            		set  @seclevel_1 = 0; 
            		set  @seclevelmax_1 = 255;
            	end
            else if @type_1=6    /*分部+安全级别*/
	          begin
            	 set @content_1 = @subcompanyid_1;
		         set @includesub_1 = @includesub_1;
	          end
            /*插入数据*/
             insert into DirAccessControlDetail
            (
            	sourceid,
            	type,
            	content,
            	seclevel,
            	seclevelmax,
            	sharelevel,
            	sourcetype,
            	srcfrom,
		includesub,
		joblevel,
		jobdepartment,
		jobsubcompany	
             )values(
            	@sourceid_1,
            	@type_1,
            	@content_1,
            	@seclevel_1,
            	@seclevelmax_1,
            	@sharelevel_1,
            	@sourcetype_1,
            	@srcfrom_1,
		        @includesub_1,
			@joblevel,
			@jobdepartment,
			@jobsubcompany
             )
             /*修正角色共享时，角色级别数据*/
             if @rolelevel_1 = 0 /*部门级别*/
               begin
                   /*增加分部级别数据*/
                   set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),1)));
                    insert into DirAccessControlDetail
            		(
            			sourceid,
            			type,
            			content,
            			seclevel,
            			seclevelmax,
            			sharelevel,
            			sourcetype,
            			srcfrom
            		 )values(
            			@sourceid_1,
            			@type_1,
            			@content_1,
            			@seclevel_1,
            			@seclevelmax_1,
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
            			seclevelmax,
            			sharelevel,
            			sourcetype,
            			srcfrom
            		 )values(
            			@sourceid_1,
            			@type_1,
            			@content_1,
            			@seclevel_1,
            			@seclevelmax_1,
            			@sharelevel_1,
            			@sourcetype_1,
            			@srcfrom_1
            		 )
               end
            else if @rolelevel_1>0  /*分部级别*/
               begin
            /*增加总部级别数据*/
            		set @content_1=convert( integer,( convert(varchar(10),@roleid_1) + convert(varchar(10),2)));
                    insert into DirAccessControlDetail
            		(
            			sourceid,
            			type,
            			content,
            			seclevel,
            			seclevelmax,
            			sharelevel,
            			sourcetype,
            			srcfrom
            		 )values(
            			@sourceid_1,
            			@type_1,
            			@content_1,
            			@seclevel_1,
            			@seclevelmax_1,
            			@sharelevel_1,
            			@sourcetype_1,
            			@srcfrom_1
            		 )
               end
		end
		FETCH NEXT FROM @detail_insert_cursor INTO @id_1 , @dirid_1,@dirtype_1,@seclevel_1,@seclevelmax_1,@includesub_1,@userid_1,@subcompanyid_1,@departmentid_1,@usertype_1,@roleid_1,@rolelevel_1,@operationcode_1,@permissiontype_1,@docSecCategoryTemplateId_1,@joblevel,@jobdepartment,@jobsubcompany,@jobids
	end 
	CLOSE @detail_insert_cursor 
	DEALLOCATE @detail_insert_cursor
end
GO