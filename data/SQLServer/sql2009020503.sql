alter table workflow_nodebase add IsFreeNode char(1)
GO
alter table workflow_nodebase add floworder int
GO
alter table workflow_nodebase add Signtype char(1)
GO
alter table workflow_nodebase add operators varchar(500)
GO
alter table workflow_nodebase add requestid int
GO
alter table workflow_nodebase add startnodeid int
GO
alter table workflow_flownode add IsFreeWorkflow char(1)
GO
alter table workflow_flownode add freewfsetcurnamecn varchar(20)
GO
alter table workflow_flownode add freewfsetcurnameen varchar(20)
GO

alter PROCEDURE workflow_NodeLink_Select @nodeid	int, @isreject	char(1),@requestid int, @flag integer output , @msg varchar(80) output AS if @isreject<>'1'  set @isreject='' select * from workflow_nodelink where nodeid=@nodeid and isreject=@isreject and EXISTS (select 1 from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and b.requestid=@requestid and b.IsFreeNode='1') union select * from workflow_nodelink where nodeid=@nodeid and isreject=@isreject and EXISTS (select 1 from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and (b.IsFreeNode is null or b.IsFreeNode!='1')) order by nodepasstime ,id
GO
