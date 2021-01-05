Delete HtmlLabelIndex where id=20288
/
Delete HtmlLabelInfo where indexid=20288
/
INSERT INTO HtmlLabelIndex values(20288,'新反馈流程') 
/
INSERT INTO HtmlLabelInfo VALUES(20288,'新反馈流程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20288,'New Back Workflow',8) 
/
insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(21,1,'新反馈流程','/images/homepage/element/Nbw.gif',5,2,'getNewBackWorkflow','查询当前操作人提交后,又有未查看的签字意见的流程')
/
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (21,21,'getNewBackWorkflow_mSettingStr','')
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 56,21,'229','requestname','0','getRequestNewLink','*','','','1',1)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 57,21,'882','creater','0','getHrmStr','50','','','0',2)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 58,21,'17994','receivedate','1','','76','','','0',3)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 59,21,'18002','receivetime','1','','62','','','0',4)
/


insert into hpSqlElement(elementid,sppbmethod)
values (21,'getNewBackWorkflowSppb')
/