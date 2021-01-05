INSERT INTO HtmlLabelIndex values(19747,'您确认关闭此元素吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19747,'您确认关闭此元素吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19747,'The element isn''t reconver after it deleted,are you sure?',8) 
/

update HtmlLabelIndex set indexdesc='收缩/展开' where id=19652
/

update HtmlLabelInfo set labelname='收缩/展开' where indexid=19652 and languageid=7
/

update HtmlLabelInfo set labelname='Collapse/Expand' where indexid=19652 and languageid=8
/
