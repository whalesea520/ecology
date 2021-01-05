delete from HtmlLabelIndex where id=19789
/
delete from HtmlLabelInfo where indexid=19789
/

INSERT INTO HtmlLabelIndex values(19789,'新闻类型') 
/
INSERT INTO HtmlLabelInfo VALUES(19789,'新闻类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19789,'News Format',8)
/

INSERT INTO HtmlLabelIndex values(19790,'允许设置为新闻') 
/
INSERT INTO HtmlLabelInfo VALUES(19790,'允许设置为新闻',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19790,'can be set to news',8) 
/

update DocSecCategoryDocProperty set labelid = 19789 where labelid = 114
/

