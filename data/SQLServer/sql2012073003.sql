CREATE  PROCEDURE DocShare_FromDocSecCatI_DL (
@docid  int, 
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
@sharesource int, 
@downloadlevel int, 
@flag	int output, 
@msg	varchar(80)	output
) as 

declare @count_1 int 

select @count_1=count(*)  
from DocShare 
where docid=@docid and sharetype=@sharetype and seclevel=@seclevel and rolelevel=@rolelevel and sharelevel<=@sharelevel 
and userid=@userid and subcompanyid=@subcompanyid and departmentid=@departmentid and roleid=@roleid and foralluser=@foralluser 
and crmid=@crmid and sharesource=@sharesource

if @count_1=0 begin 
	insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,sharesource,downloadlevel) 
	values(@docid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser,@crmid,@sharesource,@downloadlevel)   
end else begin
	update DocShare 
	set docid=@docid , sharetype=@sharetype , seclevel=@seclevel , rolelevel=@rolelevel , 
	sharelevel=@sharelevel , userid=@userid , subcompanyid=@subcompanyid , departmentid=@departmentid 
	, roleid=@roleid , foralluser=@foralluser , crmid=@crmid , sharesource=@sharesource, downloadlevel=@downloadlevel
	where docid=@docid and sharetype=@sharetype and seclevel=@seclevel and rolelevel=@rolelevel and 
	sharelevel<@sharelevel and userid=@userid and subcompanyid=@subcompanyid and departmentid=@departmentid 
	and roleid=@roleid and foralluser=@foralluser and crmid=@crmid and sharesource=@sharesource
end

GO