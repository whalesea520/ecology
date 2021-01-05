INSERT INTO hpBaseElement(id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleEN,titleTHK,loginview,isbase) 
VALUES ('processTask','1','我的任务','resource/image/10_wev8.gif',5,'2','getNewTask','任务负责人是自己的所有任务',1,'My processTask','我的任務',0,1)
/
INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (150,'processTask','1353','prjname','0','','200','','id','1',1)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (151,'processTask','1352','subject','0','getPrjTaskNameByStatus','200','/proj/process/PrjTaskTab.jsp?taskid=','id','1',2)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (152,'processTask','22168','begindate','0','','80','','id','',3)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (153,'processTask','22170','enddate','0','','80','','id','',4)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (154,'processTask','847','finish','0','getPrjTaskProgressbar','100','','id','',5)
/