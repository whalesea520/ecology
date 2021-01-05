
ALTER TABLE CRM_CustomerAddress ADD  id INT IDENTITY(1,1)
GO

delete from CRM_CustomerDefinField where usetable = 'CRM_CustomerAddress' and groupid = 8
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('address1',110,'varchar(250)','1','1','0','1','CRM_CustomerAddress',1,'n',1,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('city',493,'INT','3','58','0','2','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('zipcode',479,'varchar(10)','1','1','0','3','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('county',644,'varchar(50)','1','1','0','4','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('phone',421,'varchar(50)','1','1','0','5','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('fax',494,'varchar(50)','1','1','0','6','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('email',477,'varchar(150)','1','1','0','7','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('contacter',572,'INT','3','1','0','8','CRM_CustomerAddress',1,'n',0,8)
GO

update CRM_CustomerDefinField set fieldlabel = 494  where usetable = 'CRM_CustomerContacter' and fieldname = 'fax'
GO

update CRM_CustomerDefinField set type = 2  where usetable = 'CRM_CustomerContacter' and fieldname = 'birthdaynotifydays'
GO