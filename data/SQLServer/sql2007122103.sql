insert into hpfieldelement
(id,elementid,fieldname,fieldcolumn,isDate,transmethod,fieldwidth,linkurl,valuecolumn,isLimitlength,ordernum)
values 
(75,15,740,'begindate',1,'',76,'','id',0,3)
GO
insert into hpfieldelement
(id,elementid,fieldname,fieldcolumn,isDate,transmethod,fieldwidth,linkurl,valuecolumn,isLimitlength,ordernum)
values 
(76,15,742,'begintime',1,'',62,'','id',0,4)
GO
update hpfieldelement set ordernum=5 where id=42
GO
update hpfieldelement set ordernum=6 where id=43
GO