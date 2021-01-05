ALTER TABLE DocFrontpage ADD checkOutStatus int 
GO

ALTER TABLE DocFrontpage ADD checkOutUserId int 
GO

Alter PROCEDURE DocFrontpage_Update
(@id_1 	int,
@frontpagename_2 	varchar(200),
@frontpagedesc_3 	varchar(200),
@isactive_4 	char(1),
@departmentid_5 	int,
@hasdocsubject_7 	char(1),
@hasfrontpagelist_8 	char(1),
@newsperpage_9 	tinyint,
@titlesperpage_10 	tinyint,
@defnewspicid_11 	int,
@backgroundpicid_12 	int,
@importdocid_13 	varchar(200),
@headerdocid_14 	int,
@footerdocid_15 	int,
@secopt_16 	varchar(2),
@seclevelopt_17 	tinyint,
@departmentopt_18 	int,
@dateopt_19 	int,
@languageopt_20 	int,
@clauseopt_21 	text,
@newsclause_22 	text,
@languageid_23 	int,
@publishtype_24 	int ,
@newstypeid_25  int,
@typeordernum_26  int,
@checkOutStatus_27  int,
@checkOutUserId_28  int,
@flag	int	output,
@msg	varchar(80)	output)
AS UPDATE DocFrontpage  SET  frontpagename	 = @frontpagename_2,
frontpagedesc	 = @frontpagedesc_3, 
isactive	 = @isactive_4,
departmentid	 = @departmentid_5,
hasdocsubject	 = @hasdocsubject_7,
hasfrontpagelist	 = @hasfrontpagelist_8,
newsperpage	 = @newsperpage_9,
titlesperpage	 = @titlesperpage_10,
defnewspicid	 = @defnewspicid_11,
backgroundpicid	 = @backgroundpicid_12,
importdocid	 = @importdocid_13,
headerdocid	 = @headerdocid_14,
footerdocid	 = @footerdocid_15,
secopt	 = @secopt_16,
seclevelopt	 = @seclevelopt_17,
departmentopt	 = @departmentopt_18,
dateopt	 = @dateopt_19,
languageopt	 = @languageopt_20,
clauseopt	 = @clauseopt_21,
newsclause	 = @newsclause_22,
languageid	 = @languageid_23,
publishtype	 = @publishtype_24,
newstypeid=@newstypeid_25,
typeordernum=@typeordernum_26, 
checkOutStatus=@checkOutStatus_27,
checkOutUserId=@checkOutUserId_28

WHERE ( id = @id_1)

GO
