delete from HtmlLabelIndex where id in(20571,20572,20573,20574,20575,20576)
GO
delete from HtmlLabelInfo where indexId in(20571,20572,20573,20574,20575,20576)
GO
INSERT INTO HtmlLabelIndex values(20571,'×Ö·û´®Ò»') 
GO
INSERT INTO HtmlLabelIndex values(20572,'×Ö·û´®¶þ') 
GO
INSERT INTO HtmlLabelIndex values(20575,'×Ö·û´®Îå') 
GO
INSERT INTO HtmlLabelIndex values(20574,'×Ö·û´®ËÄ') 
GO
INSERT INTO HtmlLabelIndex values(20573,'×Ö·û´®Èý') 
GO
INSERT INTO HtmlLabelInfo VALUES(20571,'×Ö·û´®Ò»',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20571,'String One',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20572,'×Ö·û´®¶þ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20572,'String Two',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20573,'×Ö·û´®Èý',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20573,'String Three',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20574,'×Ö·û´®ËÄ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20574,'String Four',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20575,'×Ö·û´®Îå',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20575,'String Five',8) 
GO
INSERT INTO HtmlLabelIndex values(20576,'Éú³É±àºÅ') 
GO
INSERT INTO HtmlLabelInfo VALUES(20576,'Éú³É±àºÅ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20576,'Bulid Code',8) 
GO
delete from HtmlLabelIndex where id=20578
go
delete from HtmlLabelInfo where indexId=20578
go
INSERT INTO HtmlLabelIndex values(20578,'ÆðÊ¼±àºÅ') 
go
INSERT INTO HtmlLabelInfo VALUES(20578,'ÆðÊ¼±àºÅ',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20578,'Start Code',8) 
go