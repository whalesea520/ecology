CREATE TABLE departmentDefineField(
	id             int IDENTITY(1,1) NOT NULL,
	billid         int,
	fieldname      varchar(60) NULL,
	fieldlabel     int NULL,
	fielddbtype    varchar(40) NULL,
	fieldhtmltype  char(1) NULL,
	type           int NULL,
	viewtype       int NULL,
	detailtable    varchar(50) NULL,
	fromUser       char(1) NULL,
	textheight     int NULL,
	dsporder       decimal(15, 2) NULL,
	childfieldid   int NULL,
	imgheight      int NULL,
	imgwidth       int NULL,
  isopen         char(1)
)
GO

CREATE TABLE subcompanyDefineField(
	id             int IDENTITY(1,1) NOT NULL,
	billid         int,
	fieldname      varchar(60) NULL,
	fieldlabel     int NULL,
	fielddbtype    varchar(40) NULL,
	fieldhtmltype  char(1) NULL,
	type           int NULL,
	viewtype       int NULL,
	detailtable    varchar(50) NULL,
	fromUser       char(1) NULL,
	textheight     int NULL,
	dsporder       decimal(15, 2) NULL,
	childfieldid   int NULL,
	imgheight      int NULL,
	imgwidth       int NULL,
  isopen         char(1)
)
GO

ALTER TABLE workflow_groupdetail ADD deptField varchar(200)
GO


ALTER TABLE workflow_groupdetail ADD subcompanyField varchar(200)
GO



create PROCEDURE create_HrmDepartment_field 
AS 
DECLARE
  @zzjgbmfzr_temp   int,
  @zzjgbmfgld_temp  int,
  @jzglbmfzr_temp   int,
  @jzglbmfgld_temp  int,
  @bmfzr_temp       int,
  @bmfgld_temp      int,
  @rscount      int,
  @isOpen1      varchar(2),
  @isOpen2      varchar(2),
  @isOpen3      varchar(2),
  @isOpen4      varchar(2),
  @isOpen5      varchar(2),
  @isOpen6      varchar(2),
  @sql varchar(1000)
  
  set @zzjgbmfzr_temp=0
  set @zzjgbmfgld_temp  =0
  set @jzglbmfzr_temp   =0
  set @jzglbmfgld_temp  =0
  set @bmfzr_temp       =0
  set @bmfgld_temp      =0
  set @rscount      =0
  set @isOpen1      ='1'
  set @isOpen2      ='1'
  set @isOpen3      ='1'
  set @isOpen4      ='1'
  set @isOpen5      ='1'
  set @isOpen6      ='1'
  
  

select @bmfzr_temp=count(t2.name) 
from SysObjects t1
join SysColumns t2 on t1.id=t2.id
join SysTypes t3 on t2.xtype = t3.xtype
where t1.xtype in ('u','v') and t3.name <>'sysname' and t1.name='HrmDepartment' 
  and t2.name ='bmfzr'
  
if @bmfzr_temp<1
begin
      set @isOpen5      ='0'
			set @sql='ALTER TABLE HRMDEPARTMENT ADD bmfzr text '
			exec (@sql)
end

select @rscount=count(1) from departmentDefineField where fieldname='bmfzr'
if @rscount<1
begin

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'bmfzr',
         26592,
         'text',
         3,
         17,
         -2,
         0,
         '',
         0,
         0,
         0,
         0,
         @isOpen5
         ) 

end

select @bmfgld_temp=count(t2.name) 
from SysObjects t1
join SysColumns t2 on t1.id=t2.id
join SysTypes t3 on t2.xtype = t3.xtype
where t1.xtype in ('u','v') and t3.name <>'sysname' and t1.name='HrmDepartment' 
  and t2.name ='bmfgld'
  
if @bmfgld_temp<1
begin
      set @isOpen6      ='0'
			set @sql='ALTER TABLE HRMDEPARTMENT ADD bmfgld text '
			exec (@sql)
end

select @rscount=count(1) from departmentDefineField where fieldname='bmfgld'
if @rscount<1
begin

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'bmfgld',
         28442,
         'text',
         3,
         17,
         -1,
         0,
         '',
         0,
         0,
         0,
         0,
         @isOpen6
         )   

end


if @bmfzr_temp<1 and @bmfgld_temp<1
begin
  set @isOpen1      ='0'
  set @isOpen2      ='0'
  set @isOpen3      ='0'
  set @isOpen4      ='0'
end
  
select @zzjgbmfzr_temp=count(t2.name) 
from SysObjects t1
join SysColumns t2 on t1.id=t2.id
join SysTypes t3 on t2.xtype = t3.xtype
where t1.xtype in ('u','v') and t3.name <>'sysname' and t1.name='HrmDepartment' 
  and t2.name ='zzjgbmfzr'
  
if @zzjgbmfzr_temp<1
begin
			set @sql='ALTER TABLE HRMDEPARTMENT ADD zzjgbmfzr text '
			exec (@sql)
    
end
select @rscount=count(1) from departmentDefineField where fieldname='zzjgbmfzr'
if @rscount<1
begin
      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'zzjgbmfzr',
         27107,
         'text',
         3,
         17,
         -6,
         0,
         '',
         0,
         0,
         0,
         0,
         @isOpen1
         )  
end


select @zzjgbmfgld_temp=count(t2.name) 
from SysObjects t1
join SysColumns t2 on t1.id=t2.id
join SysTypes t3 on t2.xtype = t3.xtype
where t1.xtype in ('u','v') and t3.name <>'sysname' and t1.name='HrmDepartment' 
  and t2.name ='zzjgbmfgld'
  
if @zzjgbmfgld_temp<1
begin
			set @sql='ALTER TABLE HRMDEPARTMENT ADD zzjgbmfgld text '
			exec (@sql)       
end
select @rscount=count(1) from departmentDefineField where fieldname='zzjgbmfgld'
if @rscount<1
begin

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'zzjgbmfgld',
         27108,
         'text',
         3,
         17,
         -5,
         0,
         '',
         0,
         0,
         0,
         0,
         @isOpen2
         ) 

end


select @jzglbmfzr_temp=count(t2.name) 
from SysObjects t1
join SysColumns t2 on t1.id=t2.id
join SysTypes t3 on t2.xtype = t3.xtype
where t1.xtype in ('u','v') and t3.name <>'sysname' and t1.name='HrmDepartment' 
  and t2.name ='jzglbmfzr'
  
if @jzglbmfzr_temp<1
begin
			set @sql='ALTER TABLE HRMDEPARTMENT ADD jzglbmfzr text '
			exec (@sql)       
end
select @rscount=count(1) from departmentDefineField where fieldname='jzglbmfzr'
if @rscount<1
begin

       
      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'jzglbmfzr',
         27109,
         'text',
         3,
         17,
         -4,
         0,
         '',
         0,
         0,
         0,
         0,
         @isOpen3
         ) 

end


select @jzglbmfgld_temp=count(t2.name) 
from SysObjects t1
join SysColumns t2 on t1.id=t2.id
join SysTypes t3 on t2.xtype = t3.xtype
where t1.xtype in ('u','v') and t3.name <>'sysname' and t1.name='HrmDepartment' 
  and t2.name ='jzglbmfgld'
  
if @jzglbmfgld_temp<1
begin
			set @sql='ALTER TABLE HRMDEPARTMENT ADD jzglbmfgld text '
			exec (@sql)
end

select @rscount=count(1) from departmentDefineField where fieldname='jzglbmfgld'
if @rscount<1
begin

INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'jzglbmfgld',
         27110,
         'text',
         3,
         17,
         -3,
         0,
         '',
         0,
         0,
         0,
         0,
         @isOpen4
         ) 


end

GO


EXEC create_HrmDepartment_field
go      

 
drop PROCEDURE create_HrmDepartment_field 
go
