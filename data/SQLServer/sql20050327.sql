/*****************************procs*****************************/
CREATE PROCEDURE CarType_Insert
	(@name 		varchar(50),
	 @description   varchar(250),
	 @usefee    decimal(10,2),
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	insert into cartype values (@name,@description,@usefee)
go

CREATE PROCEDURE CarType_Update
(   @id int,
    @name   varchar(50),
    @description    varchar(250),
    @usefee    decimal(10,2),
	@flag integer output,
	@msg varchar(80) output)
AS 
	update cartype set name=@name,description=@description,usefee=@usefee where id=@id
go

CREATE PROCEDURE CarType_Select
	(@flag integer output,
	 @msg varchar(80) output)
AS 
	select * from cartype
go

CREATE PROCEDURE CarType_SelectByID
(   @id int,
	@flag integer output,
	@msg varchar(80) output)
AS 
	select * from cartype where id=@id
go

CREATE PROCEDURE CarType_Delete
(   @id int,
	@flag integer output,
	@msg varchar(80) output)
AS 
	delete from cartype where id=@id
go

CREATE PROCEDURE CarParameter_Insert
	(@name 		varchar(50),
	 @paravalue decimal(10,2),
	 @description   varchar(250),
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	insert into CarParameter values (@name,@description,@paravalue)
go

CREATE PROCEDURE CarParameter_Update
(   @id int,
    @name   varchar(50),
    @paravalue  decimal(10,2),
    @description    varchar(250),
	@flag integer output,
	@msg varchar(80) output)
AS 
	update CarParameter set name=@name,description=@description,paravalue=@paravalue where id=@id
go

CREATE PROCEDURE CarParameter_Select
	(@flag integer output,
	 @msg varchar(80) output)
AS 
	select * from CarParameter
go

CREATE PROCEDURE CarParameter_SelectByID
(   @id int,
	@flag integer output,
	@msg varchar(80) output)
AS 
	select * from CarParameter where id=@id
go

CREATE PROCEDURE CarParameter_Delete
(   @id int,
	@flag integer output,
	@msg varchar(80) output)
AS 
	delete from CarParameter where id=@id
go

CREATE PROCEDURE CarDriverBasicinfo_Insert
(   @basicsalary    decimal(10,2),
    @overtimepara   decimal(10,2),
    @receptionpara  decimal(10,2),
    @basicKM        decimal(10,2),
    @basicKMpara    decimal(10,2),
    @basictime      decimal(10,2),
    @basictimepara  decimal(10,2),
    @basicout       int,
    @basicoutpara   decimal(10,2),
    @publicpara     decimal(10,2),
    @flag integer output,
	@msg varchar(80) output)
AS 
    declare @count int
	select @count=count(*) from cardriverbasicinfo
	if @count=0 
	    insert into cardriverbasicinfo values 
	    (@basicsalary,@overtimepara,@receptionpara,@basicKM,@basicKMpara,@basictime,@basictimepara,@basicout,@basicoutpara,@publicpara)
	else
	    update cardriverbasicinfo set basicsalary=@basicsalary,overtimepara=@overtimepara,
	    receptionpara=@receptionpara,basicKM=@basicKM,basicKMpara=@basicKMpara,
	    basictime=@basictime,basictimepara=@basictimepara,basicout=@basicout,basicoutpara=@basicoutpara,publicpara=@publicpara
	
go

CREATE PROCEDURE CarDriverBasicinfo_Select
(   @flag integer output,
	@msg varchar(80) output)
AS 
	select * from cardriverbasicinfo
go

CREATE PROCEDURE CarDriverData_Insert
	(@driverid 		int,
	 @cartypeid   int,
	 @isreception   int,
	 @startdate     char(10),
	 @starttime     char(8),
	 @backdate      char(10),
	 @backtime      char(8),
	 @startkm       decimal(10,2),
	 @backkm        decimal(10,2),
	 @runKM         decimal(10,2),
	 @runtime       decimal(10,2),
	 @normalkm      decimal(10,2),
	 @overtimekm    decimal(10,2),
	 @normaltime    decimal(10,2),
	 @overtime      decimal(10,2),
	 @realkm        decimal(10,2),
	 @realtime      decimal(10,2),
	 @useperson     varchar(255),
	 @usedepartment varchar(255),
	 @iscarout      int,
	 @remark        text,
	 @isholiday     char(1),
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	insert into CarDriverData values (@driverid,@cartypeid,@isreception,@startdate,@starttime,@backdate,@backtime,@startkm,@backkm,
	@runKM,@runtime,@normalkm,@overtimekm,@normaltime,@overtime,@realkm,@realtime,@useperson,@usedepartment,@iscarout,@remark,@isholiday)
	
	select max(id) from cardriverdata
go

CREATE PROCEDURE CarDriverData_Update
	(@id        int,
	 @driverid 		int,
	 @cartypeid   int,
	 @isreception   int,
	 @startdate     char(10),
	 @starttime     char(8),
	 @backdate      char(10),
	 @backtime      char(8),
	 @startkm       decimal(10,2),
	 @backkm        decimal(10,2),
	 @runKM         decimal(10,2),
	 @runtime       decimal(10,2),
	 @normalkm      decimal(10,2),
	 @overtimekm    decimal(10,2),
	 @normaltime    decimal(10,2),
	 @overtime      decimal(10,2),
	 @realkm        decimal(10,2),
	 @realtime      decimal(10,2),
	 @useperson     varchar(255),
	 @usedepartment varchar(255),
	 @iscarout      int,
	 @remark        text,
	 @isholiday     char(1),
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	update CarDriverData set 
	driverid=@driverid,
	cartypeid=@cartypeid,
	isreception=@isreception,
	startdate=@startdate,
	starttime=@starttime,
	backdate=@backdate,
	backtime=@backtime,
	startkm=@startkm,
	backkm=@backkm,
	runKM=@runKM,
	runtime=@runtime,
	normalkm=@normalkm,
	overtimekm=@overtimekm,
	normaltime=@normaltime,
	overtime=@overtime,
	realkm=@realkm,
	realtime=@realtime,
	useperson=@useperson,
	usedepartment=@usedepartment,
	iscarout=@iscarout,
	remark=@remark,
	isholiday=@isholiday
	where id=@id
go

CREATE PROCEDURE CarDriverData_Delete
	(@id        int,
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	delete from CarDriverData where id=@id
go

CREATE PROCEDURE CarDriverDataPara_Insert
	(@driverdataid        int,
	 @paraid        int,
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	insert into CarDriverDataPara values (@driverdataid,@paraid)
go

CREATE PROCEDURE CarDriverDataPara_Delete
	(@driverdataid        int,
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	delete from CarDriverDataPara where driverdataid = @driverdataid
go

