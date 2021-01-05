INSERT INTO HtmlLabelIndex values(19309,'收文单位') 
GO
INSERT INTO HtmlLabelIndex values(19310,'上级单位') 
GO
INSERT INTO HtmlLabelIndex values(19311,'收文员') 
GO
INSERT INTO HtmlLabelIndex values(19312,'新建同级单位') 
GO
INSERT INTO HtmlLabelIndex values(19313,'新建下级单位') 
GO
INSERT INTO HtmlLabelInfo VALUES(19309,'收文单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19309,'Receive Unit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19310,'上级单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19310,'Superior Unit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19311,'收文员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19311,'Receiver',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19312,'新建同级单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19312,'New Peer Unit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19313,'新建下级单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19313,'New Lower Unit',8) 
GO
INSERT INTO HtmlLabelIndex values(19315,'上级单位不能为本单位！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19315,'上级单位不能为本单位！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19315,'The superior unit cann''t be this unit!',8) 
GO

INSERT INTO HtmlLabelIndex values(19319,'系统不支持10层以上的收文单位！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19319,'系统不支持10层以上的收文单位！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19319,'The system doesn''t support 10 level of receive unit!',8) 
GO

INSERT INTO HtmlLabelIndex values(19323,'开启全选') 
GO
INSERT INTO HtmlLabelIndex values(19324,'关闭全选') 
GO
INSERT INTO HtmlLabelInfo VALUES(19323,'开启全选',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19323,'Open Check All',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19324,'关闭全选',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19324,'Close Check All',8) 
GO


EXECUTE MMConfig_U_ByInfoInsert 20,5
GO
EXECUTE MMInfo_Insert 510,19309,'','/docs/sendDoc/DocReceiveUnitFrame.jsp','mainFrame',20,2,5,0,'',0,'',0,'','',0,'','',1
GO

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 142,19309,'varchar(400)','/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserMulti.jsp','DocReceiveUnit','receiveUnitName','id','/docs/sendDoc/DocReceiveUnitDsp.jsp?id=')
GO

INSERT INTO HtmlLabelIndex values(19365,'当前单位有下级单位，不能删除。') 
GO
INSERT INTO HtmlLabelInfo VALUES(19365,'当前单位有下级单位，不能删除。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19365,'Current unit has subunit,can''t be deleted.',8) 
GO
INSERT INTO HtmlLabelIndex values(19366,'同级单位名称不能重复') 
GO
INSERT INTO HtmlLabelInfo VALUES(19366,'同级单位名称不能重复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19366,'The names of peer units couldn''t be repeated.',8) 
GO

update ErrorMsgInfo set msgName='该记录被引用，不能删除。' where indexid=20 and languageid=7
GO



CREATE TABLE [DocReceiveUnit] (
        [id] [int] IDENTITY (1, 1) NOT NULL ,
        [receiveUnitName] [varchar] (200) NULL , 
        [superiorUnitId] int NULL ,
        [receiverIds] [varchar] (200) NULL ,
        [allSuperiorUnitId] [varchar] (80) NULL ,
        [unitLevel] int NULL ,
        [showOrder] int NULL 
) 
GO
