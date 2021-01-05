delete from HtmlLabelIndex where id>=20053 and id<=20065 
go

delete from HtmlLabelInfo  where indexId>=20053 and indexId<=20065 
go

INSERT INTO HtmlLabelIndex values(20054,'请假原因') 
go
INSERT INTO HtmlLabelIndex values(20053,'其它请假类型') 
go
INSERT INTO HtmlLabelIndex values(20055,'出差原因') 
go
INSERT INTO HtmlLabelIndex values(20057,'外出申请时间') 
go
INSERT INTO HtmlLabelIndex values(20060,'外出结束日期') 
go
INSERT INTO HtmlLabelIndex values(20061,'外出结束时间') 
go
INSERT INTO HtmlLabelIndex values(20059,'外出开始时间') 
go
INSERT INTO HtmlLabelIndex values(20058,'外出开始日期') 
go
INSERT INTO HtmlLabelIndex values(20056,'外出申请日期') 
go
INSERT INTO HtmlLabelIndex values(20062,'外出事由') 
go
INSERT INTO HtmlLabelInfo VALUES(20053,'其它请假类型',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20053,'Other Leave Type',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20054,'请假原因',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20054,'Leave Reason',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20055,'出差原因',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20055,'Evection Reason',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20056,'外出申请日期',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20056,'Out Apply Date',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20057,'外出申请时间',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20057,'Out Apply Time',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20058,'外出开始日期',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20058,'Out Start Date',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20059,'外出开始时间',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20059,'Out Start Time',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20060,'外出结束日期',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20060,'Out End Date',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20061,'外出结束时间',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20061,'Out End Time',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20062,'外出事由',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20062,'Out Reason',8) 
go

INSERT INTO HtmlLabelIndex values(20063,'渤海保险请假单据') 
go
INSERT INTO HtmlLabelIndex values(20064,'渤海保险出差单据') 
go
INSERT INTO HtmlLabelIndex values(20065,'渤海保险公出单据') 
go
INSERT INTO HtmlLabelInfo VALUES(20063,'渤海保险请假单据',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20063,'Bo Hai Leave Bill',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20064,'渤海保险出差单据',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20064,'Bo Hai Evection Bill',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20065,'渤海保险公出单据',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20065,'Bo Hai Out Bill',8) 
go

delete from HtmlLabelIndex where id=20072 
go
delete from HtmlLabelInfo  where indexId=20072 
go

INSERT INTO HtmlLabelIndex values(20072,'一年内探亲假和年假两个假别只能休一个。') 
go
INSERT INTO HtmlLabelInfo VALUES(20072,'一年内探亲假和年假两个假别只能休一个。',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20072,'There is only one between home-leaving and annual on one year.',8) 
go

