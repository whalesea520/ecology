insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(34,1,'知识订阅','/images/homepage/element/docss.gif',5,2,'getDocSubscribeMore','查看知识订阅')
GO
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (34,34,'getDocSubscribeSettingStr','')
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 95,34,'24608','docsubject','0','','*','/docs/docs/DocDsp.jsp?id=','id','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 97,34,'24609','startdate','0','','*','','','0',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 98,34,'24610','enddate','0','','*','','','0',1)
GO
INSERT INTO hpSqlElement(elementid,sppbMethod) VALUES (34,'getDocSubscribeSpb')
GO
