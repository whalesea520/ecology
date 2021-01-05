INSERT INTO HtmlLabelIndex values(19414,'系统不支持10层以上的树状字段！') 
GO
INSERT INTO HtmlLabelIndex values(19410,'树状字段设置') 
GO
INSERT INTO HtmlLabelIndex values(19412,'新建下级节点') 
GO
INSERT INTO HtmlLabelIndex values(19411,'上级节点') 
GO
INSERT INTO HtmlLabelIndex values(19413,'新建同级节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(19410,'树状字段设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19410,'Tree Field Setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19411,'上级节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19411,'Superior Node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19412,'新建下级节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19412,'New Sub Node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19413,'新建同级节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19413,'New Peer Node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19414,'系统不支持10层以上的树状字段！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19414,'The system doesn''t support 10 level of tree field!',8) 
GO

INSERT INTO HtmlLabelIndex values(19441,'当前字段有下级节点，不能删除。') 
GO
INSERT INTO HtmlLabelIndex values(19442,'同级字段名称不能重复') 
GO
INSERT INTO HtmlLabelInfo VALUES(19441,'当前字段有下级节点，不能删除。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19441,'Current field has subnode,can''t be deleted.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19442,'同级字段名称不能重复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19442,'The names of peer fields can''t be repeated.',8) 
GO



CREATE TABLE DocTreeDocField (
	id int IDENTITY (1, 1) NOT NULL ,
        treeDocFieldName varchar(80) NULL , 
        superiorFieldId int NULL ,
        allSuperiorFieldId varchar(80) NULL ,
        fieldLevel int NULL ,
	    isLast  char(1) NULL,
        showOrder decimal(6,2) NULL 
) 
GO


insert into  DocTreeDocField(treeDocFieldName,superiorFieldId,allSuperiorFieldId,fieldLevel,isLast,showOrder) values('root',0,'',0,1,0.00)
GO


EXECUTE MMConfig_U_ByInfoInsert 2,16
GO
EXECUTE MMInfo_Insert 516,19410,'','/docs/category/DocTreeDocFieldFrame.jsp','mainFrame',2,1,16,0,'',0,'',0,'','',0,'','',1
GO

INSERT INTO HtmlLabelIndex values(19485,'树状文档字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(19485,'树状文档字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19485,'Tree Document Field',8) 
GO

INSERT INTO HtmlLabelIndex values(19490,'树状字段显示') 
GO
INSERT INTO HtmlLabelInfo VALUES(19490,'树状字段显示',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19490,'View by Tree Field',8) 
GO

INSERT INTO HtmlLabelIndex values(19500,'体系类别') 
GO
INSERT INTO HtmlLabelInfo VALUES(19500,'体系类别',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19500,'System Type',8) 
GO

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 143,19485,'varchar(400)','/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp','DocTreeDocField','treeDocFieldName','id','/docs/category/DocTreeDocFieldDsp.jsp?id=')


ALTER TABLE DocSearchMould ADD  treeDocFieldId int
GO
