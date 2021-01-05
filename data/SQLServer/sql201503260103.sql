INSERT INTO hpBaseElement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleen,titlethk,loginview)
VALUES ('contacts','2','通讯录','resource/image/contacts_wev8.gif',-1,'-1','getContactsMore','个人常用通讯信息','1','Contacts','通訊錄',0)
GO
INSERT INTO hpFieldElement (id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitlength,ordernum)
VALUES (103,'contacts','413','name',0,'','*','','id','0',1)
GO
INSERT INTO hpFieldElement (id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitlength,ordernum)
VALUES (104,'contacts','124','department',0,'','170','','id','0',2)
GO
INSERT INTO hpFieldElement (id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitlength,ordernum)
VALUES (105,'contacts','421','tel',0,'','170','','id','0',3)
GO
INSERT INTO hpFieldElement (id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitlength,ordernum)
VALUES (106,'contacts','620','mobile',0,'','170','','id','0',4)
GO
INSERT INTO hpFieldElement (id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitlength,ordernum)
VALUES (107,'contacts','477','email',0,'','200','','id','0',5)
GO

