INSERT INTO HtmlLabelIndex values(19654,'布局说明(<BR>如果设置不正确,显示时将会出现混乱)') 
GO
INSERT INTO HtmlLabelIndex values(19655,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中A区宽度应为100<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:100)') 
GO
INSERT INTO HtmlLabelIndex values(19656,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中A+B区的宽度和应为100<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:50 B:50)') 
GO
INSERT INTO HtmlLabelIndex values(19657,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中A+B+C区的宽度和应为100<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:33 B:33 C:34)') 
GO
INSERT INTO HtmlLabelIndex values(19658,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中A+B区的宽度和应为100，C+D区的宽度和应为100(它所指的是C与D占A区的百分比)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:70 B:30 C:50 D:50)') 
GO
INSERT INTO HtmlLabelIndex values(19659,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中D+C区的宽度和应为100，A+B区的宽度和应为100(它所指的是A与B占D区的百分比)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:50 B:50 C:30 D:70)') 
GO

INSERT INTO HtmlLabelInfo VALUES(19654,'布局说明(<BR>如果设置不正确,显示时将会出现混乱)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19654,'Layout Note(it will error if you setting error)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19655,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中A区宽度应为100<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:100)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19655,'<br>Note：<br>&nbsp;&nbsp;&nbsp;&nbsp;Layout A is 100(<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eg.A:100)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19656,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中A+B区的宽度和应为100<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:50 B:50)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19656,'<br>Note：<br>&nbsp;&nbsp;&nbsp;&nbsp;Layout A+B is 100(<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eg.A:50 B:50)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19657,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中A+B+C区的宽度和应为100<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:33 B:33 C:34)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19657,'<br>Note：<br>&nbsp;&nbsp;&nbsp;&nbsp;Layout A+B+C is 100(<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eg.A:33 B:33 C:34)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19658,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中A+B区的宽度和应为100，C+D区的宽度和应为100</font>(它所指的是C与D占A区的百分比)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:70 B:30 C:50 D:50)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19658,'<br>Note：<br>&nbsp;&nbsp;&nbsp;&nbsp;Layout A+B is 100, C+D is 100(C or D is percent of A )(<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eg.A:70 B:30 C:50 D:50)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19659,'<br>说明：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此布局中D+C区的宽度和应为100，A+B区的宽度和应为100</font>(它所指的是A与B占D区的百分比)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如(A:50 B:50 C:30 D:70)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19659,'<br>Note：<br>&nbsp;&nbsp;&nbsp;&nbsp;Layout D+C is 100, A+B is 100(A or B is percent of D )(<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eg.A:50 B:50 C:30 D:70)',8) 
GO

update hpbaselayout set layoutdesc='19655' where id=1
GO
update hpbaselayout set layoutdesc='19656' where id=2
GO
update hpbaselayout set layoutdesc='19657' where id=3
GO
update hpbaselayout set layoutdesc='19658' where id=4
GO
update hpbaselayout set layoutdesc='19659' where id=5
GO


