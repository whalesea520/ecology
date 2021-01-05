delete from CRM_CustomerDefinField
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield1',dff01name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff01use,'n' from Base_FreeField where tablename='c1' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield1 <>'' and datefield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield2',dff02name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff02use,'n' from Base_FreeField where tablename='c1' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield2 <>'' and datefield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield3',dff03name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff03use,'n' from Base_FreeField where tablename='c1' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield3 <>'' and datefield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield4',dff04name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff04use,'n' from Base_FreeField where tablename='c1' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield4 <>'' and datefield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield5',dff05name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff05use,'n' from Base_FreeField where tablename='c1' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield5 <>'' and datefield5 is not null) >0))
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield1',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff01use,'n' from Base_FreeField where tablename='c1' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield1 <>'' and numberfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield2',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff02use,'n' from Base_FreeField where tablename='c1' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield2 <>'' and numberfield2 is not null) >0))
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield3',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff03use,'n' from Base_FreeField where tablename='c1' 
and (nff03use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield3 <>'' and numberfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield4',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff04use,'n' from Base_FreeField where tablename='c1' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield4 <>'' and numberfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield5',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff05use,'n' from Base_FreeField where tablename='c1' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield5 <>'' and numberfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield1',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff01use,'n' from Base_FreeField where tablename='c1' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield1 <>'' and textfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield2',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff02use,'n' from Base_FreeField where tablename='c1' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield2 <>'' and textfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield3',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff03use,'n' from Base_FreeField where tablename='c1' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield3 <>'' and textfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield4',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff04use,'n' from Base_FreeField where tablename='c1' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield4 <>'' and textfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield5',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff05use,'n' from Base_FreeField where tablename='c1' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield5 <>'' and textfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield1',bff01name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff01use,'n' from Base_FreeField where tablename='c1' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield2',bff02name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff02use,'n' from Base_FreeField where tablename='c1' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield3',bff03name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff03use,'n' from Base_FreeField where tablename='c1' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield4',bff04name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff04use,'n' from Base_FreeField where tablename='c1' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield5',bff05name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff05use,'n' from Base_FreeField where tablename='c1' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield1',dff01name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff01use,'n' from Base_FreeField where tablename='c2' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield1 <>'' and datefield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield2',dff02name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff02use,'n' from Base_FreeField where tablename='c2' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield2 <>'' and datefield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield3',dff03name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff03use,'n' from Base_FreeField where tablename='c2' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield3 <>'' and datefield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield4',dff04name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff04use,'n' from Base_FreeField where tablename='c2' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield4 <>'' and datefield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield5',dff05name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff05use,'n' from Base_FreeField where tablename='c2' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield5 <>'' and datefield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield1',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff01use,'n' from Base_FreeField where tablename='c2' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield1 <>'' and numberfield1 is not null) >0))
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield2',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff02use,'n' from Base_FreeField where tablename='c2' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield2 <>'' and numberfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield3',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff03use,'n' from Base_FreeField where tablename='c2' 
and (nff03use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield3 <>'' and numberfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield4',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff04use,'n' from Base_FreeField where tablename='c2' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield4 <>'' and numberfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield5',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff05use,'n' from Base_FreeField where tablename='c2' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield5 <>'' and numberfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield1',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff01use,'n' from Base_FreeField where tablename='c2' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield1 <>'' and textfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield2',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff02use,'n' from Base_FreeField where tablename='c2' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield2 <>'' and textfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield3',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff03use,'n' from Base_FreeField where tablename='c2' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield3 <>'' and textfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield4',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff04use,'n' from Base_FreeField where tablename='c2' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield4 <>'' and textfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield5',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff05use,'n' from Base_FreeField where tablename='c2' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield5 <>'' and textfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield1',bff01name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff01use,'n' from Base_FreeField where tablename='c2' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield2',bff02name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff02use,'n' from Base_FreeField where tablename='c2' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield3',bff03name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff03use,'n' from Base_FreeField where tablename='c2' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield4',bff04name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff04use,'n' from Base_FreeField where tablename='c2' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield5',bff05name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff05use,'n' from Base_FreeField where tablename='c2' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield1',dff01name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff01use,'n' from Base_FreeField where tablename='c3' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield1 <>'' and datefield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield2',dff02name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff02use,'n' from Base_FreeField where tablename='c3' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield2 <>'' and datefield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield3',dff03name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff03use,'n' from Base_FreeField where tablename='c3' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield3 <>'' and datefield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield4',dff04name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff04use,'n' from Base_FreeField where tablename='c3' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield4 <>'' and datefield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield5',dff05name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff05use,'n' from Base_FreeField where tablename='c3' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield5 <>'' and datefield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield1',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff01use,'n' from Base_FreeField where tablename='c3' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield1 <>'' and numberfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield2',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff02use,'n' from Base_FreeField where tablename='c3' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield2 <>'' and numberfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield3',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff03use,'n' from Base_FreeField where tablename='c3' 
and (nff03use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield3 <>'' and numberfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield4',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff04use,'n' from Base_FreeField where tablename='c3' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield4 <>'' and numberfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield5',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff05use,'n' from Base_FreeField where tablename='c3' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield5 <>'' and numberfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield1',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff01use,'n' from Base_FreeField where tablename='c3' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield1 <>'' and textfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield2',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff02use,'n' from Base_FreeField where tablename='c3' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield2 <>'' and textfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield3',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff03use,'n' from Base_FreeField where tablename='c3' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield3 <>'' and textfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield4',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff04use,'n' from Base_FreeField where tablename='c3' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield4 <>'' and textfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield5',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff05use,'n' from Base_FreeField where tablename='c3' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield5 <>'' and textfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield1',bff01name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff01use,'n' from Base_FreeField where tablename='c3' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield2',bff02name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff02use,'n' from Base_FreeField where tablename='c3' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield3',bff03name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff03use,'n' from Base_FreeField where tablename='c3' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield4',bff04name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff04use,'n' from Base_FreeField where tablename='c3' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield5',bff05name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff05use,'n' from Base_FreeField where tablename='c3' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
GO

update LeftMenuInfo set iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/CPT_58.png' where id=58
GO
