/* 工资参数表 */
CREATE TABLE CarDriverBasicinfo(
    basicsalary     decimal(10,2),
    overtimepara    decimal(10,2),
    receptionpara   decimal(10,2),
    basicKM         decimal(10,2),
    basicKMpara     decimal(10,2),
    basictime       decimal(10,2),
    basictimepara   decimal(10,2),
    basicout        int,
    basicoutpara    decimal(10,2),
    publicpara      decimal(10,2)
)
GO

/* 评估参数表 */
CREATE TABLE CarParameter(
    id  int NOT NULL IDENTITY (1, 1),
    name    varchar(50),
    description varchar(250),
    paravalue   decimal(10,2)
)
GO

/* 车辆类型表 */
CREATE TABLE CarType(
	id  int NOT NULL IDENTITY (1, 1),
	name		varchar(50),
	description	varchar(250),
    usefee  decimal(10,2)
)
GO

/* 出车记录表 */
CREATE TABLE CarDriverData(
    id  int NOT NULL IDENTITY (1, 1),
    driverid     int,
    cartypeid   int,
    isreception int,
    startdate   char(10),
    starttime   char(8),
    backdate    char(10),
    backtime    char(8),
    startkm     decimal(10,2),
    backkm      decimal(10,2),
    runKM       decimal(10,2),
    runtime     decimal(10,2),
    normalkm    decimal(10,2),
    overtimekm  decimal(10,2),
    normaltime  decimal(10,2),
    overtime    decimal(10,2),
    realkm      decimal(10,2),
    realtime    decimal(10,2),
    useperson   varchar(255),
    usedepartment   varchar(255),
    iscarout    int,
    remark      text,
    isholiday   char(1)
)
GO

/*出车记录参数表*/
CREATE TABLE CarDriverDataPara(
    driverdataid int,
    paraid  int
)
GO
