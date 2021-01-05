create table cpt_browdef( 
fieldid int,
fieldkind int,
iscondition int,
iscondition_type int,
istitle int,
istitle_type int,
userid int,
displayorder decimal(10,2)
)
GO


SET IDENTITY_INSERT cptDefineField ON
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-36,0,'departmentid',21030,'int','3',4,0,'','',0,'-88',0,0,0,'1','1','1','1','1',2)
SET IDENTITY_INSERT cptDefineField OFF
GO

delete cpt_browdef
GO
INSERT INTO cpt_browdef( fieldid,displayorder,iscondition_type,istitle_type,iscondition,istitle ) values(-1,1,1,1,1,1)
GO
INSERT INTO cpt_browdef( fieldid,displayorder,iscondition_type,istitle_type,iscondition,istitle ) values(-2,2,1,0,1,1)
GO
INSERT INTO cpt_browdef( fieldid,displayorder,iscondition_type,istitle_type,iscondition,istitle ) values(-11,3,1,0,1,1)
GO
INSERT INTO cpt_browdef( fieldid,displayorder,iscondition_type,istitle_type,iscondition,istitle ) values(-36,4,1,0,1,0)
GO
INSERT INTO cpt_browdef( fieldid,displayorder,iscondition_type,istitle_type,iscondition,istitle ) values(-5,5,1,0,1,1)
GO
INSERT INTO cpt_browdef( fieldid,displayorder,iscondition_type,istitle_type,iscondition,istitle ) values(-15,6,0,0,0,1)
GO
INSERT INTO cpt_browdef( fieldid,displayorder,iscondition_type,istitle_type,iscondition,istitle ) values(-12,7,0,0,0,1)
GO
INSERT INTO cpt_browdef( fieldid,displayorder,iscondition_type,istitle_type,iscondition,istitle ) values(-17,8,0,0,0,1)
GO