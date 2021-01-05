UPDATE HTMLLABELINDEX SET indexdesc=REPLACE(indexdesc,'ит╣х','ит╨Р') WHERE indexdesc LIKE '%ит╣х%'
GO
UPDATE HtmlLabelInfo SET labelname=REPLACE(labelname,'ит╣х','ит╨Р') WHERE labelname LIKE '%ит╣х%'
GO