create table workflowcentersettingdetail (
      id int IDENTITY (1, 1) NOT NULL ,  
      eid int not null ,                                   
      tabid int not null,      
      type varchar(100) not null,                        
      content varchar(100) not null,  
      srcfrom int not null,                 
      CONSTRAINT PK_workflowcentersettingdetail PRIMARY KEY NONCLUSTERED (id ASC) 
);
GO
create clustered index  workflowcentersettingdetail_index ON workflowcentersettingdetail(eid,tabid,type, content) with fillfactor=30
GO

create PROCEDURE IWorkflowCenterSettingDetailP as
declare  @id_1          integer;
declare  @eid_1         integer;
declare  @typeids_1     varchar(4000);
declare  @flowids_1     varchar(4000);
declare  @nodeids_1     varchar(4000);
declare  @tabid_1       integer;

declare  @content_1		varchar(100);

declare  @srcfrom_1     integer;
declare  @type_1        varchar(100);
declare  @i integer;
begin

	DELETE from workflowcentersettingdetail ; 
	declare share_cursor cursor for   	
	select id,eid, typeids, flowids, nodeids, tabid from hpsetting_wfcenter
	
	open share_cursor fetch next from share_cursor into @id_1,@eid_1,@typeids_1,@flowids_1,@nodeids_1,@tabid_1
	while @@fetch_status=0 
		begin
			set	@srcfrom_1 = @id_1;
			if(@typeids_1!='')
			 begin
					set @type_1='typeid';
					set @i=charindex(',',@typeids_1);
				
					while @i>0
						begin
							
							
							set @content_1 = LEFT(@typeids_1,@i-1);
							
							 insert into workflowcentersettingdetail
						(
							
							eid,
							tabid,
							type,
							content,
							srcfrom
						 )values(
						
							@eid_1,
							@tabid_1,
							@type_1,
							@content_1,
							@srcfrom_1
						 );
						 set @typeids_1 = RIGHT(@typeids_1,LEN(@typeids_1)-@i);
						 set @i=charindex(',',@typeids_1);
						end
						set @content_1 = @typeids_1;
						 insert into workflowcentersettingdetail
						(
							
							eid,
							tabid,
							type,
							content,
							srcfrom
						 )values(
						
							@eid_1,
							@tabid_1,
							@type_1,
							@content_1,
							@srcfrom_1
						 );
				 end
				if(@flowids_1!='')
			 begin
					set @type_1='flowid';
					set @i=charindex(',',@flowids_1);
				
					while @i>0
						begin
							
							
							set @content_1 = LEFT(@flowids_1,@i-1);
							
							 insert into workflowcentersettingdetail
						(
							
							eid,
							tabid,
							type,
							content,
							srcfrom
						 )values(
						
							@eid_1,
							@tabid_1,
							@type_1,
							@content_1,
							@srcfrom_1
						 );
						 set @flowids_1 = RIGHT(@flowids_1,LEN(@flowids_1)-@i);
						 set @i=charindex(',',@flowids_1);
						end
						set @content_1 = @flowids_1;
						 insert into workflowcentersettingdetail
						(
							
							eid,
							tabid,
							type,
							content,
							srcfrom
						 )values(
						
							@eid_1,
							@tabid_1,
							@type_1,
							@content_1,
							@srcfrom_1
						 );
				 end
				 if(@nodeids_1!='')
			 begin
					set @type_1='nodeid';
					set @i=charindex(',',@nodeids_1);
				
					while @i>0
						begin
							
							set @content_1 = LEFT(@nodeids_1,@i-1);
							
							 insert into workflowcentersettingdetail
						(
							
							eid,
							tabid,
							type,
							content,
							srcfrom
						 )values(
						
							@eid_1,
							@tabid_1,
							@type_1,
							@content_1,
							@srcfrom_1
						 );
						 set @nodeids_1 = RIGHT(@nodeids_1,LEN(@nodeids_1)-@i);
						 set @i=charindex(',',@nodeids_1);
						end
						set @content_1 = @nodeids_1;
						 insert into workflowcentersettingdetail
						(
							
							eid,
							tabid,
							type,
							content,
							srcfrom
						 )values(
						
							@eid_1,
							@tabid_1,
							@type_1,
							@content_1,
							@srcfrom_1
						 );
				 end
				 
				 
			
				fetch next from share_cursor into @id_1,@eid_1,@typeids_1,@flowids_1,@nodeids_1,@tabid_1
	end
	close share_cursor deallocate share_cursor	
end
GO
exec IWorkflowCenterSettingDetailP;
GO