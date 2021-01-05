delete from HtmlLabelIndex where id=82293 
GO
delete from HtmlLabelInfo where indexid=82293 
GO
INSERT INTO HtmlLabelIndex values(82293,'部门下存在人员，不能封存') 
GO
delete from HtmlLabelIndex where id=82294 
GO
delete from HtmlLabelInfo where indexid=82294 
GO
INSERT INTO HtmlLabelIndex values(82294,'部门存在下级部门，不能封存') 
GO
delete from HtmlLabelIndex where id=82295 
GO
delete from HtmlLabelInfo where indexid=82295 
GO
INSERT INTO HtmlLabelIndex values(82295,'分部存在下级分部，不能封存') 
GO
delete from HtmlLabelIndex where id=82296 
GO
delete from HtmlLabelInfo where indexid=82296 
GO
INSERT INTO HtmlLabelIndex values(82296,'分部下存在部门，不能封存') 
GO
INSERT INTO HtmlLabelInfo VALUES(82296,'分部下存在部门，不能封存',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82296,'Division in the presence of authorities, can not be sealed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82296,'分部下存在部門，不能封存',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82296,'分部下存在部門，不能封存',10) 
GO
INSERT INTO HtmlLabelInfo VALUES(82295,'分部存在下级分部，不能封存',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82295,'Division subordinate divisions exist, can not be sealed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82295,'分部存在下級分部，不能封存',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82295,'分部存在下級分部，不能封存',10) 
GO
INSERT INTO HtmlLabelInfo VALUES(82294,'部门存在下级部门，不能封存',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82294,'Department subordinate departments exist, not sealed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82294,'部門存在下級部門，不能封存',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82294,'部門存在下級部門，不能封存',10) 
GO
INSERT INTO HtmlLabelInfo VALUES(82293,'部门下存在人员，不能封存',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82293,'Under the presence of personnel department, not sealed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82293,'部門下存在人員，不能封存',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82293,'部門下存在人員，不能封存',10) 
GO
