UPDATE blog_app SET iconPath = '/blog/images/blog_template.png'  WHERE appType = 'template'
GO
CREATE TABLE blog_templateUser(
	userId       INT NULL,
	templateId   INT NULL
)
GO
