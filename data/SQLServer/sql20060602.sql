UPDATE HtmlLabelIndex SET indexdesc = '即下级分部管理员以及用户可对该菜单进行显示隐藏的操作' where id = 19051
GO
UPDATE HtmlLabelInfo SET labelname = '即下级分部管理员以及用户可对该菜单进行显示隐藏的操作' where indexid = 19051 and languageid = 7
GO
UPDATE HtmlLabelInfo SET labelname = 'lower lever user can set the menu to view and hide' where indexid = 19051 and languageid = 8
GO
 
UPDATE HtmlLabelIndex SET indexdesc = '即下级分部管理员以及用户可对该菜单进行自定义名称的操作' where id = 19052
GO
UPDATE HtmlLabelInfo SET labelname = '即下级分部管理员以及用户可对该菜单进行自定义名称的操作' where indexid = 19052 and languageid = 7
GO
UPDATE HtmlLabelInfo SET labelname = 'lower lever user can custom the menu''s name' where indexid = 19052 and languageid = 8
GO


INSERT INTO HtmlLabelIndex values(19063,'图标地址') 
GO
INSERT INTO HtmlLabelInfo VALUES(19063,'图标地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19063,'Icon',8) 
GO
INSERT INTO HtmlLabelIndex values(18773,'自定义菜单') 
GO
INSERT INTO HtmlLabelInfo VALUES(18773,'自定义菜单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18773,'User Define Menu',8) 
GO
INSERT INTO HtmlLabelIndex values(18772,'自定义菜单分类') 
GO
INSERT INTO HtmlLabelInfo VALUES(18772,'自定义菜单分类',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18772,'User Define Menu Classification',8) 
GO

INSERT INTO HtmlLabelIndex values(19064,'缩略图') 
GO
INSERT INTO HtmlLabelInfo VALUES(19064,'缩略图',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19064,'Thumbnail',8) 
GO
INSERT INTO HtmlLabelIndex values(19090,'提醒消息') 
GO
INSERT INTO HtmlLabelIndex values(19091,'本页面用于显示提醒消息的具体内容')
GO
INSERT INTO HtmlLabelIndex values(19092,'点击左侧提醒消息名称，右侧会显示点击的提醒消息的具体内容，顶级节点除外。') 
GO
INSERT INTO HtmlLabelIndex values(19093,'提醒消息名称旁边的数量是代表这个提醒消息底下有多少提醒消息。') 
GO
INSERT INTO HtmlLabelInfo VALUES(19090,'提醒消息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19090,'Remind Information',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19091,'本页面用于显示提醒消息的具体内容。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19091,'This Page is used to view the content of the remind information.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19092,'点击左侧提醒消息名称，右侧会显示点击的提醒消息的具体内容，顶级节点除外。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19092,'Click the message name left,you will see the information right which you clicked except the top node.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19093,'提醒消息名称旁边的数量是代表这个提醒消息底下有多少提醒消息。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19093,'The Number beside the remind message means the number of the information inside this message tree.',8) 
GO

INSERT INTO HtmlLabelIndex values(19084,'您有系统帮您新创建的工作流需要处理') 
GO
INSERT INTO HtmlLabelIndex values(19086,'您有以下新事务需要处理：') 
GO
INSERT INTO HtmlLabelIndex values(19085,'消息提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(19084,'您有系统帮您新创建的工作流需要处理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19084,'you have new request by system to process',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19085,'消息提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19085,'message remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19086,'您有以下新事务需要处理：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19086,'you have these new request to process:',8) 
GO
INSERT INTO HtmlLabelIndex values(19010,'操作说明') 
GO
INSERT INTO HtmlLabelInfo VALUES(19010,'操作说明',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19010,'Description of operation',8) 
GO