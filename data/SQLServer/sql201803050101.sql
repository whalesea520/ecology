delete from HtmlLabelIndex where id=382662 
GO
delete from HtmlLabelInfo where indexid=382662 
GO
INSERT INTO HtmlLabelIndex values(382662,'简体中文不可关闭') 
GO
delete from HtmlLabelIndex where id=382664 
GO
delete from HtmlLabelInfo where indexid=382664 
GO
INSERT INTO HtmlLabelIndex values(382664,'点击刷新按钮，重新加载多语言配置') 
GO
INSERT INTO HtmlLabelInfo VALUES(382664,'点击刷新按钮，重新加载多语言配置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382664,'Click fresh button to reload language config files',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382664,'點擊刷新按鈕，重新加載多語言配置',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382662,'简体中文不可关闭',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382662,'simplified Chinese can not be closed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382662,'簡體中文不可關閉',9) 
GO

delete from HtmlNoteIndex where id=4920 
GO
delete from HtmlNoteInfo where indexid=4920 
GO
INSERT INTO HtmlNoteIndex values(4920,'提示:同时开启的语言不能超过5种!') 
GO
delete from HtmlNoteIndex where id=4921 
GO
delete from HtmlNoteInfo where indexid=4921 
GO
INSERT INTO HtmlNoteIndex values(4921,'配置文件已重新加载') 
GO
INSERT INTO HtmlNoteInfo VALUES(4921,'配置文件已重新加载',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4921,'ConfigFiles Reload Complete',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4921,'配置文件已重新加載',9) 
GO
INSERT INTO HtmlNoteInfo VALUES(4920,'提示:同时开启的语言不能超过5种!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4920,'Tips:Open Language cannot set more than 5!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4920,'提示:同時開啓的語言不能超過5種!',9) 
GO