delete from HtmlLabelIndex where id>=20053 and id<=20065 
/

delete from HtmlLabelInfo  where indexId>=20053 and indexId<=20065 
/

INSERT INTO HtmlLabelIndex values(20054,'请假原因') 
/
INSERT INTO HtmlLabelIndex values(20053,'其它请假类型') 
/
INSERT INTO HtmlLabelIndex values(20055,'出差原因') 
/
INSERT INTO HtmlLabelIndex values(20057,'外出申请时间') 
/
INSERT INTO HtmlLabelIndex values(20060,'外出结束日期') 
/
INSERT INTO HtmlLabelIndex values(20061,'外出结束时间') 
/
INSERT INTO HtmlLabelIndex values(20059,'外出开始时间') 
/
INSERT INTO HtmlLabelIndex values(20058,'外出开始日期') 
/
INSERT INTO HtmlLabelIndex values(20056,'外出申请日期') 
/
INSERT INTO HtmlLabelIndex values(20062,'外出事由') 
/
INSERT INTO HtmlLabelInfo VALUES(20053,'其它请假类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20053,'Other Leave Type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20054,'请假原因',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20054,'Leave Reason',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20055,'出差原因',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20055,'Evection Reason',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20056,'外出申请日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20056,'Out Apply Date',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20057,'外出申请时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20057,'Out Apply Time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20058,'外出开始日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20058,'Out Start Date',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20059,'外出开始时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20059,'Out Start Time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20060,'外出结束日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20060,'Out End Date',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20061,'外出结束时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20061,'Out End Time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20062,'外出事由',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20062,'Out Reason',8) 
/

INSERT INTO HtmlLabelIndex values(20063,'渤海保险请假单据') 
/
INSERT INTO HtmlLabelIndex values(20064,'渤海保险出差单据') 
/
INSERT INTO HtmlLabelIndex values(20065,'渤海保险公出单据') 
/
INSERT INTO HtmlLabelInfo VALUES(20063,'渤海保险请假单据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20063,'Bo Hai Leave Bill',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20064,'渤海保险出差单据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20064,'Bo Hai Evection Bill',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20065,'渤海保险公出单据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20065,'Bo Hai Out Bill',8) 
/

delete from HtmlLabelIndex where id=20072 
/
delete from HtmlLabelInfo  where indexId=20072 
/

INSERT INTO HtmlLabelIndex values(20072,'一年内探亲假和年假两个假别只能休一个。') 
/
INSERT INTO HtmlLabelInfo VALUES(20072,'一年内探亲假和年假两个假别只能休一个。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20072,'There is only one between home-leaving and annual on one year.',8) 
/

