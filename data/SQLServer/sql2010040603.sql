alter PROCEDURE DocShare_IFromDocSecCategoryDL (
@docid          int, 
@sharetype	int, 
@seclevel	tinyint, 
@rolelevel	tinyint,
@sharelevel	tinyint,
@userid	int,
@subcompanyid	int, 
@departmentid	int, 
@roleid	int, 
@foralluser	tinyint,
@crmid	int, 
@orgGroupId	int,
@downloadlevel int,
@flag	int output, 
@msg	varchar(80)	output
) 
as 
insert into 
   DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,orgGroupId,downloadlevel)
values
   (@docid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser,@crmid,@orgGroupId,@downloadlevel)   

select @@IDENTITY
GO
