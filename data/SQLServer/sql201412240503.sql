UPDATE HTMLLABELINDEX SET indexdesc=REPLACE(indexdesc,'�Ե�','�Ժ�') WHERE indexdesc LIKE '%�Ե�%'
GO
UPDATE HtmlLabelInfo SET labelname=REPLACE(labelname,'�Ե�','�Ժ�') WHERE labelname LIKE '%�Ե�%'
GO