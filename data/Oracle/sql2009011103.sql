insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(32,2,'计划任务','/images/homepage/element/10.gif',5,2,'getWorkTaskMore','查看计划任务')
/

insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (32,32,'getWorktaskSettingStr','')
/


INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 88,32,'22317','WorktaskContent','0','','*','','','1',1)
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 89,32,'22323 ','taskprincipal','0','','60','','','0',2)
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 90,32,'22168','begindate','0','','76','','','0',3)
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 91,32,'22169','begintime','0','','62','','','0',4)
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 92,32,'19550','enddate','0','','76','','','0',5)
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 93,32,'19551','endtime','0','','62','','','0',6)
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 94,32,'21947','WorktaskStatus','0','','60','','','0',7)
/

insert into hpextelement(id,extsettinge,extopreate,extshow,description)
values(32,'','','Worktask.jsp','显示计划任务')
/
