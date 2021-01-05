Delete hpbaseelement where id=25
GO
Delete hpWhereElement where id=25
GO
Delete hpextelement where id=25
GO
insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(25,2,'文档内容','/images/homepage/element/DocContent.gif',-1,1,'getDoccontentMore','可以把文档内容显示出来的元素')
GO
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (25,25,'getDoccontentSettingStr','')
GO
insert into hpextelement(id,extsettinge,extopreate,extshow,description)
values(25,'','','DocContent.jsp','显示文档内容')
GO
