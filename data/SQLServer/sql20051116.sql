alter table workflow_formdict add description varchar(100)
GO
alter table workflow_formdictdetail add description varchar(100)
GO

alter table workflow_SelectItem add listorder numeric(10,2)
GO
alter table workflow_SelectItem add isdefault char(1)
GO

update workflow_SelectItem set isdefault = 'n'
GO
update workflow_SelectItem set listorder = 0
GO


alter table workflow_formdict add textheight int
GO
alter table workflow_formdictdetail add textheight int
GO
update workflow_formdict set textheight = 4
GO
update workflow_formdictdetail set textheight = 4
GO


alter PROCEDURE workflow_FieldID_Select 

@formid		int,
@flag integer output , 
@msg varchar(80) output 
AS 
select fieldid,fieldorder,isdetail from workflow_formfield where formid=@formid and (isdetail<>'1' or isdetail is null) order by fieldid  

GO

alter PROCEDURE workflow_SelectItem_Insert (@fieldid 		int, @isbill 		int, @selectvalue 	int, @selectname 	varchar(250),@listorder numeric(10,2),@isdefault char(1), @flag integer output, @msg varchar(80) output)
AS insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname,listorder,isdefault)
values(@fieldid,@isbill,@selectvalue,@selectname,@listorder,@isdefault)

go


ALTER PROCEDURE workflow_SelectItemSelectByid @id varchar(100) , 
@isbill varchar(100) , @flag integer output , @msg varchar(80) output 
AS
select * from workflow_SelectItem where fieldid = @id and isbill = @isbill 
order by listorder set  @flag = 0 set  @msg = ''

GO



