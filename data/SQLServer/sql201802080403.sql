delete from blog_remind where remindtype = 6 and (remindvalue is null or remindvalue = '0')
GO