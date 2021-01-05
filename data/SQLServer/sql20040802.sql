/*td:872 减损资产、资产报表和查询资产页面，无减损状态*/
UPDATE HtmlLabelIndex SET indexdesc = '减损日期' WHERE id = 1406
GO
UPDATE HtmlLabelInfo SET labelname = '减损日期' WHERE indexid = 1406 AND languageid = 7
GO

UPDATE HtmlLabelIndex SET indexdesc = '减损' WHERE id = 1385
GO
UPDATE HtmlLabelInfo SET labelname = '减损' WHERE indexid = 1385 AND languageid = 7
GO

DROP TABLE CptCapitalState

CREATE TABLE [CptCapitalState] (
[id] [int] NOT NULL,
[name] [varchar] (60) NULL,
[description] [varchar] (200) NULL,
[issystem] [char] (1) NULL,
PRIMARY KEY([id])
)
GO

INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (-7, '减损', '减损的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (-6, '移交', '移交的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (-5, '调出', '调出的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (-4, '调入', '调入的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (-3, '出库', '出库的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (-2, '盘亏', '盘亏的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (-1, '盘赢', '盘赢的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (0, '归还', '归还的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (1, '入库', '入库的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (2, '使用', '使用的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (3, '借用', '借用的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (4, '维修', '维修的资产', '1')
GO
INSERT INTO CptCapitalState (id, name, description, issystem) VALUES (5, '报废', '报废的资产', '1')
GO