delete from HtmlLabelIndex where id=129765 
GO
delete from HtmlLabelInfo where indexid=129765 
GO
INSERT INTO HtmlLabelIndex values(129765,'不允许') 
GO
delete from HtmlLabelIndex where id=129766 
GO
delete from HtmlLabelInfo where indexid=129766 
GO
INSERT INTO HtmlLabelIndex values(129766,'允许') 
GO
INSERT INTO HtmlLabelInfo VALUES(129766,'允许',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129766,'allow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129766,'允許',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(129765,'不允许',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129765,'Not allow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129765,'不允許',9) 
GO

delete from HtmlLabelIndex where id=129767 
GO
delete from HtmlLabelInfo where indexid=129767 
GO
INSERT INTO HtmlLabelIndex values(129767,'允许全部') 
GO
INSERT INTO HtmlLabelInfo VALUES(129767,'允许全部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129767,'Allow all',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129767,'允許全部',9) 
GO

delete from HtmlLabelIndex where id=129768 
GO
delete from HtmlLabelInfo where indexid=129768 
GO
INSERT INTO HtmlLabelIndex values(129768,'允许指定') 
GO
INSERT INTO HtmlLabelInfo VALUES(129768,'允许指定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129768,'Allow specify',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129768,'允許指定',9) 
GO

delete from HtmlLabelIndex where id=129769 
GO
delete from HtmlLabelInfo where indexid=129769 
GO
INSERT INTO HtmlLabelIndex values(129769,'允许下级') 
GO
INSERT INTO HtmlLabelInfo VALUES(129769,'允许下级',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129769,'Allow subordinates',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129769,'允許下級',9) 
GO

delete from HtmlLabelIndex where id=129770 
GO
delete from HtmlLabelInfo where indexid=129770 
GO
INSERT INTO HtmlLabelIndex values(129770,'允许所属分部') 
GO
delete from HtmlLabelIndex where id=129771 
GO
delete from HtmlLabelInfo where indexid=129771 
GO
INSERT INTO HtmlLabelIndex values(129771,'（含部门）') 
GO
INSERT INTO HtmlLabelInfo VALUES(129771,'（含部门）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129771,'(including Department)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129771,'（含部門）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(129770,'允许所属分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129770,'Allow the Division',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129770,'允許所屬分部',9) 
GO

delete from HtmlLabelIndex where id=129772 
GO
delete from HtmlLabelInfo where indexid=129772 
GO
INSERT INTO HtmlLabelIndex values(129772,'允许所属部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(129772,'允许所属部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129772,'Allow the Department',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129772,'允許所屬部門',9) 
GO