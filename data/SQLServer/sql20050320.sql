/*个人设置 label*/
INSERT INTO HtmlLabelIndex values(17627,'个人设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(17627,'个人设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17627,'user setting',8) 
GO

/*RTX是否自动登陆 label*/
INSERT INTO HtmlLabelIndex values(17628,'RTX是否自动登陆') 
GO
INSERT INTO HtmlLabelInfo VALUES(17628,'RTX是否自动登陆',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17628,'RTX AutoOnload',8) 
GO

/* 用户自定义的设置表 */
CREATE TABLE HrmUserSetting ( 
    id int NOT NULL IDENTITY (1, 1),
    resourceId int,
    rtxOnload char(1)) 
GO