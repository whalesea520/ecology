/*sql 脚本*/
update  HtmlNoteInfo set notename='该子目录下有文档存在，不能删除！!' where indexid = 13  and languageid = 7;
GO
update  HtmlNoteInfo set notename='This item can not be deleted because it has doc under it!' where indexid = 13  and languageid = 8
GO