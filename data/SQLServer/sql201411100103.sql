ALTER TABLE blog_sysSetting ADD allowExport CHAR(1)
GO
ALTER TABLE blog_sysSetting ADD isSendBlogNote CHAR(1)
GO

INSERT INTO blog_app(name ,isActive,appType,sort , iconPath) VALUES(64,1,'template',7,null)
GO
UPDATE blog_app SET sort = 8 WHERE appType = 'attachment'
GO

ALTER TABLE blog_template ADD tempDesc VARCHAR(200)
GO
ALTER TABLE blog_template ADD isSystem CHAR(1)
GO
ALTER TABLE blog_template ADD userId INT
GO
UPDATE blog_template SET isSystem = 1 ,tempDesc = tempName
GO