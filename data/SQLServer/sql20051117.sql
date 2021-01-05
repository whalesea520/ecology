alter table CRM_SellChance add departmentId int
GO
alter table CRM_SellChance add subCompanyId int
GO

Alter PROCEDURE CRM_SellChance_Update
(
	@creater_1 int ,
	@subject_1 varchar (50) ,
	@customerid_1 int ,
	@comefromid_1 int ,
	@sellstatusid_1 int ,
	@endtatusid_1 char(1) ,
	@predate_1 char(10) ,
	@preyield_1 decimal(18,2) ,
	@currencyid_1 int ,
	@probability_1 decimal(8,2) ,
	@content_1 text ,
	@id_1 int,
	@sufactor_1 int,
	@defactor_1 int,
	@departmentId_1 int,
	@subCompanyId_1 int,
	@flag	int	output,
	@msg	varchar(80)	output)
as
update CRM_SellChance set

	creater = @creater_1,
	subject = @subject_1,
	customerid =@customerid_1,
	comefromid =@comefromid_1,
	sellstatusid=@sellstatusid_1 ,
	endtatusid =@endtatusid_1,
	predate=@predate_1 ,
	preyield =@preyield_1,
	currencyid =@currencyid_1,
	probability =@probability_1,
	content= @content_1,
	sufactor = @sufactor_1,
	defactor = @defactor_1,
	departmentId = @departmentId_1,
	subCompanyId = @subCompanyId_1
WHERE id=@id_1


GO

Alter PROCEDURE CRM_SellChance_insert
(
	@creater_1 int ,
	@subject_1 varchar (50) ,
	@customerid_1 int ,
	@comefromid_1 int ,
	@sellstatusid_1 int ,
	@endtatusid_1 char(1) ,
	@predate_1 char(10) ,
	@preyield_1 decimal(18,2) ,
	@currencyid_1 int ,
	@probability_1 decimal(8,2) ,
	@createdate_1 char(10) ,
	@createtime_1 char(8) ,
	@content_1 text ,
	@sufactor_1 int,
	@defactor_1 int,
	@departmentId_1 int,
	@subCompanyId_1 int,
	@flag	int	output,
	@msg	varchar(80)	output)
as
insert INTO CRM_SellChance
(
	creater ,
	subject ,
	customerid ,
	comefromid ,
	sellstatusid ,
	endtatusid ,
	predate ,
	preyield ,
	currencyid ,
	probability ,
	createdate ,
	createtime ,
	content,
	sufactor,
	defactor,
	departmentId,
	subCompanyId)
	values
	(
	@creater_1  ,
	@subject_1  ,
	@customerid_1  ,
	@comefromid_1  ,
	@sellstatusid_1  ,
	@endtatusid_1  ,
	@predate_1  ,
	@preyield_1  ,
	@currencyid_1  ,
	@probability_1 ,
	@createdate_1  ,
	@createtime_1  ,
	@content_1 ,
	@sufactor_1,
	@defactor_1,
	@departmentId_1,
	@subCompanyId_1)


GO

Create Procedure Init_CRM_SellChance
as
	Declare
	@creater int,
	@departmentId int,
	@subCompanyId int,
	@all_cursor cursor
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select t1.creater,t2.departmentid,t2.subcompanyid1 from CRM_SellChance t1 left join HrmResource t2 on t1.creater=t2.id
	OPEN @all_cursor
	FETCH NEXT FROM @all_cursor INTO @creater,@departmentId,@subCompanyId
	WHILE @@FETCH_STATUS = 0
	begin
		update CRM_SellChance set departmentId=@departmentId,subCompanyId=@subCompanyId where creater = @creater;
		FETCH NEXT FROM @all_cursor INTO  @creater,@departmentId,@subCompanyId
	end
	CLOSE @all_cursor
	DEALLOCATE @all_cursor  	
GO
Init_CRM_SellChance
GO

