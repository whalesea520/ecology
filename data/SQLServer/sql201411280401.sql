delete from HtmlNoteIndex where id=3401 
GO
delete from HtmlNoteInfo where indexid=3401 
GO
INSERT INTO HtmlNoteIndex values(3401,'无法封存:部门中存在岗位!') 
GO
INSERT INTO HtmlNoteInfo VALUES(3401,'无法封存:部门中存在岗位!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(3401,'Unable Archive: job sectors exist!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(3401,'無法封存:部門中存在崗位!',9) 
GO