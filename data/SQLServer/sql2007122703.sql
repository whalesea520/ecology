 ALTER PROCEDURE WF_Prj_ShareInfo_Add 
(@prjid_1		int,            
 @sharelevel_1		int,
 @userid_1		int,
 @usertype_1		int,
 @flag                             integer output,
 @msg                             varchar(80) output )
as
declare @count_1 int
declare @count_2 int
select @count_1=count(*)  from Prj_ProjectInfo where (manager=@userid_1 or creater=@userid_1) and id=@prjid_1
if @count_1=0
	begin
	select @count_2=count(*)  from Prj_ShareInfo where relateditemid=@prjid_1 and sharelevel=@sharelevel_1 and userid= @userid_1
	if @count_2=0
		begin
		if @usertype_1=0
			 begin
			 insert Prj_ShareInfo(relateditemid,sharetype,sharelevel,userid) values(@prjid_1,'1',@sharelevel_1,@userid_1)
			 end
		if @usertype_1=1
			begin
			insert Prj_ShareInfo(relateditemid,sharetype,sharelevel,crmid) values(@prjid_1,'9',@sharelevel_1,@userid_1)
			end
		end
	end

GO