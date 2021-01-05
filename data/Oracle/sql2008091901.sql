delete from HtmlLabelIndex where id=21879 
/
delete from HtmlLabelInfo where indexid=21879 
/
INSERT INTO HtmlLabelIndex values(21879,'启用弹出窗口') 
/
INSERT INTO HtmlLabelInfo VALUES(21879,'启用弹出窗口',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21879,'The opening of pop-up window',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21879,'啟用彈出窗口',9) 
/
 
delete from HtmlLabelIndex where id=21880 
/
delete from HtmlLabelInfo where indexid=21880 
/
INSERT INTO HtmlLabelIndex values(21880,'关闭弹出窗口') 
/
INSERT INTO HtmlLabelInfo VALUES(21880,'关闭弹出窗口',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21880,'Close pop-up window',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21880,'關閉彈出窗口',9) 
/
delete from HtmlLabelIndex where id=21881 
/
delete from HtmlLabelInfo where indexid=21881 
/
INSERT INTO HtmlLabelIndex values(21881,'弹出次数') 
/
INSERT INTO HtmlLabelInfo VALUES(21881,'弹出次数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21881,'The number of pop-up',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21881,'彈出次數',9) 
/
delete from HtmlLabelIndex where id=21882 
/
delete from HtmlLabelInfo where indexid=21882 
/
INSERT INTO HtmlLabelIndex values(21882,'窗口高度') 
/
INSERT INTO HtmlLabelInfo VALUES(21882,'窗口高度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21882,'A high degree of window',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21882,'窗口高度',9) 
/
delete from HtmlLabelIndex where id=21884 
/
delete from HtmlLabelInfo where indexid=21884 
/
INSERT INTO HtmlLabelIndex values(21884,'窗口宽度') 
/
INSERT INTO HtmlLabelInfo VALUES(21884,'窗口宽度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21884,'Width of the window',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21884,'窗口寬度',9) 
/

delete from HtmlLabelIndex where id=21885 
/
delete from HtmlLabelInfo where indexid=21885 
/
INSERT INTO HtmlLabelIndex values(21885,'文档弹出窗口设置') 
/
INSERT INTO HtmlLabelInfo VALUES(21885,'文档弹出窗口设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21885,'Pop-up document set',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21885,'文檔彈出窗口設置',9) 
/
delete from HtmlLabelIndex where id=21886 
/
delete from HtmlLabelInfo where indexid=21886 
/
INSERT INTO HtmlLabelIndex values(21886,'窗口弹出状态') 
/
INSERT INTO HtmlLabelInfo VALUES(21886,'窗口弹出状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21886,'Pop-up window state',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21886,'窗口彈出狀態',9) 
/
 
delete from HtmlLabelIndex where id=21887 
/
delete from HtmlLabelInfo where indexid=21887 
/
INSERT INTO HtmlLabelIndex values(21887,'开启状态') 
/
INSERT INTO HtmlLabelInfo VALUES(21887,'开启状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21887,'Open',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21887,'開啟狀態',9) 
/
delete from HtmlLabelIndex where id=21888 
/
delete from HtmlLabelInfo where indexid=21888 
/
INSERT INTO HtmlLabelIndex values(21888,'未开启') 
/
INSERT INTO HtmlLabelInfo VALUES(21888,'未开启',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21888,'未開啟',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21888,'Unopened',9) 
/
delete from HtmlLabelIndex where id=21889 
/
delete from HtmlLabelInfo where indexid=21889 
/
INSERT INTO HtmlLabelIndex values(21889,'已开启') 
/
INSERT INTO HtmlLabelInfo VALUES(21889,'已开启',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21889,'Has been opened',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21889,'已開啟',9) 
/


delete from SystemRights where id=800
/
insert into SystemRights (id,rightdesc,righttype) values (800,'文档弹出窗口设置权限','1') 
/
delete from SystemRightsLanguage where id=800
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,7,'文档弹出窗口设置权限','文档弹出窗口设置权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,9,'文档弹出窗口设置权限','文档弹出窗口设置权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,8,'Pop-up document setting authority','Pop-up document setting authority') 
/
delete from SystemRightDetail where id=4310
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4310,'文档弹出窗口设置权限','Docs:SetPopUp',800) 
/

