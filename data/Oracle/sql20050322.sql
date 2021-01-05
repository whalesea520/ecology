/* 工资参数表 */
CREATE TABLE CarDriverBasicinfo(
    basicsalary     number(10,2),
    overtimepara    number(10,2),
    receptionpara   number(10,2),
    basicKM         number(10,2),
    basicKMpara     number(10,2),
    basictime       number(10,2),
    basictimepara   number(10,2),
    basicout        integer,
    basicoutpara    number(10,2),
    publicpara      number(10,2)
)
/

/* 评估参数表 */
CREATE TABLE CarParameter(
    id  integer NOT NULL ,
    name    varchar2(50),
    description varchar2(250),
    paravalue   number(10,2)
)
/
create sequence  CarParameter_id
	start with 1
	increment by 1
	nomaxvalue
	nocycle 
/
create or replace trigger CarParameter_trigger
	before insert on CarParameter
	for each row
	begin
	select CarParameter_id.nextval into :new.id from dual;
	end ;
/

/* 车辆类型表 */
CREATE TABLE CarType(
	id  integer NOT NULL ,
	name		varchar2(50),
	description	varchar2(250),
    usefee  number(10,2)
)
/
create sequence  CarType_id
	start with 1
	increment by 1
	nomaxvalue
	nocycle
/
create or replace trigger CarType_trigger
	before insert on CarType
	for each row
	begin
	select CarType_id.nextval into :new.id from dual;
	end;
/


/* 出车记录表 */
CREATE TABLE CarDriverData(
    id  integer NOT NULL ,
    driverid     integer,
    cartypeid   integer,
    isreception integer,
    startdate   char(10),
    starttime   char(8),
    backdate    char(10),
    backtime    char(8),
    startkm     number(10,2),
    backkm      number(10,2),
    runKM       number(10,2),
    runtime     number(10,2),
    normalkm    number(10,2),
    overtimekm  number(10,2),
    normaltime  number(10,2),
    overtime    number(10,2),
    realkm      number(10,2),
    realtime    number(10,2),
    useperson   varchar2(255),
    usedepartment   varchar2(255),
    iscarout    integer,
    remark      Varchar2(4000),
    isholiday   char(1)
)
/
create sequence  CarDriverData_id
	start with 1
	increment by 1
	nomaxvalue
	nocycle
/
create or replace trigger CarDriverData_trigger
	before insert on CarDriverData
	for each row
	begin
	select CarDriverData_id.nextval into :new.id from dual;
	end ;
/


/*出车记录参数表*/
CREATE TABLE CarDriverDataPara(
    driverdataid integer,
    paraid  integer
)
/
