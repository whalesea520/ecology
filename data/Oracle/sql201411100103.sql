ALTER TABLE blog_sysSetting ADD allowExport CHAR(1)
/
ALTER TABLE blog_sysSetting ADD isSendBlogNote CHAR(1)
/

INSERT INTO blog_app(name ,isActive,appType,sort , iconPath) VALUES(64,1,'template',7,null)
/
UPDATE blog_app SET sort = 8 WHERE appType = 'attachment'
/

ALTER TABLE blog_template ADD tempDesc VARCHAR(200)
/
ALTER TABLE blog_template ADD isSystem CHAR(1)
/
ALTER TABLE blog_template ADD userId INT
/
UPDATE blog_template SET isSystem = 1 ,tempDesc = tempName
/