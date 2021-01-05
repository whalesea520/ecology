UPDATE hrm_formfield SET allowhide=-1 WHERE fieldname IN('accounttype','belongto')
GO
UPDATE HtmlLabelInfo SET labelname = 'Today is working day.  Would you like to attendence now?' WHERE indexid=21415 AND languageid=8
GO