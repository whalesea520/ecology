delete from HtmlLabelIndex where id=33283
go
delete from HtmlLabelInfo where indexid=33283 
go

INSERT INTO HtmlLabelIndex values(33283,'����������') 
go
INSERT INTO HtmlLabelInfo VALUES(33283,'����������',7) 
go
INSERT INTO HtmlLabelInfo VALUES(33283,'Pending task',8) 
go
INSERT INTO HtmlLabelInfo VALUES(33283,'�������΄�',9) 
go

delete from HtmlLabelIndex where id=16412 
go
delete from HtmlLabelInfo where indexid=16412 
go
INSERT INTO HtmlLabelIndex values(16412,'��������') 
go
INSERT INTO HtmlLabelInfo VALUES(16412,'��������',7) 
go
INSERT INTO HtmlLabelInfo VALUES(16412,'Exceed LimitTime Task',8) 
go
