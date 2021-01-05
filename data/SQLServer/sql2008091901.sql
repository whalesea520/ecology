delete from HtmlLabelIndex where id=21879 
GO
delete from HtmlLabelInfo where indexid=21879 
GO
INSERT INTO HtmlLabelIndex values(21879,'启用弹出窗口') 
GO
INSERT INTO HtmlLabelInfo VALUES(21879,'启用弹出窗口',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21879,'The opening of pop-up window',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21879,'啟用彈出窗口',9) 
GO
 
delete from HtmlLabelIndex where id=21880 
GO
delete from HtmlLabelInfo where indexid=21880 
GO
INSERT INTO HtmlLabelIndex values(21880,'关闭弹出窗口') 
GO
INSERT INTO HtmlLabelInfo VALUES(21880,'关闭弹出窗口',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21880,'Close pop-up window',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21880,'關閉彈出窗口',9) 
GO
delete from HtmlLabelIndex where id=21881 
GO
delete from HtmlLabelInfo where indexid=21881 
GO
INSERT INTO HtmlLabelIndex values(21881,'弹出次数') 
GO
INSERT INTO HtmlLabelInfo VALUES(21881,'弹出次数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21881,'The number of pop-up',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21881,'彈出次數',9) 
GO
delete from HtmlLabelIndex where id=21882 
GO
delete from HtmlLabelInfo where indexid=21882 
GO
INSERT INTO HtmlLabelIndex values(21882,'窗口高度') 
GO
INSERT INTO HtmlLabelInfo VALUES(21882,'窗口高度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21882,'A high degree of window',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21882,'窗口高度',9) 
GO
delete from HtmlLabelIndex where id=21884 
GO
delete from HtmlLabelInfo where indexid=21884 
GO
INSERT INTO HtmlLabelIndex values(21884,'窗口宽度') 
GO
INSERT INTO HtmlLabelInfo VALUES(21884,'窗口宽度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21884,'Width of the window',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21884,'窗口寬度',9) 
GO

delete from HtmlLabelIndex where id=21885 
GO
delete from HtmlLabelInfo where indexid=21885 
GO
INSERT INTO HtmlLabelIndex values(21885,'文档弹出窗口设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21885,'文档弹出窗口设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21885,'Pop-up document set',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21885,'文檔彈出窗口設置',9) 
GO
delete from HtmlLabelIndex where id=21886 
GO
delete from HtmlLabelInfo where indexid=21886 
GO
INSERT INTO HtmlLabelIndex values(21886,'窗口弹出状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(21886,'窗口弹出状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21886,'Pop-up window state',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21886,'窗口彈出狀態',9) 
GO
 
delete from HtmlLabelIndex where id=21887 
GO
delete from HtmlLabelInfo where indexid=21887 
GO
INSERT INTO HtmlLabelIndex values(21887,'开启状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(21887,'开启状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21887,'Open',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21887,'開啟狀態',9) 
GO
delete from HtmlLabelIndex where id=21888 
GO
delete from HtmlLabelInfo where indexid=21888 
GO
INSERT INTO HtmlLabelIndex values(21888,'未开启') 
GO
INSERT INTO HtmlLabelInfo VALUES(21888,'未开启',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21888,'未開啟',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21888,'Unopened',9) 
GO
delete from HtmlLabelIndex where id=21889 
GO
delete from HtmlLabelInfo where indexid=21889 
GO
INSERT INTO HtmlLabelIndex values(21889,'已开启') 
GO
INSERT INTO HtmlLabelInfo VALUES(21889,'已开启',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21889,'Has been opened',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21889,'已開啟',9) 
GO


delete from SystemRights where id=800
GO
insert into SystemRights (id,rightdesc,righttype) values (800,'文档弹出窗口设置权限','1') 
GO
delete from SystemRightsLanguage where id=800
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,7,'文档弹出窗口设置权限','文档弹出窗口设置权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,9,'文档弹出窗口设置权限','文档弹出窗口设置权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,8,'Pop-up document setting authority','Pop-up document setting authority') 
GO
delete from SystemRightDetail where id=4310
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4310,'文档弹出窗口设置权限','Docs:SetPopUp',800) 
GO
