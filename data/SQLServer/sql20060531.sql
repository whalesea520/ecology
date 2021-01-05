alter table Bill_Meeting add resourcenum int
GO
alter table Bill_Meeting add resources varchar(255)
GO
alter table Bill_Meeting add crms varchar(255)
GO
alter table Bill_Meeting add others varchar(255)
GO
alter table Bill_Meeting add projectid int
GO
alter table Meeting add cancel char(1)
GO
alter table Meeting add canceldate char(10)
GO
alter table Meeting add canceltime char(8)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (85,'resourcenum',2166,'int',1,2,7,0,'')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (85,'resources',2106,'varchar(255)',3,17,7,0,'')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (85,'crms',2167,'varchar(255)',3,18,7,0,'')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (85,'others',19078,'varchar(255)',1,1,7,0,'')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (85,'projectid',782,'int',3,8,9,0,'')
GO
INSERT INTO HtmlLabelIndex values(19078,'其它人员') 
GO
INSERT INTO HtmlLabelInfo VALUES(19078,'其它人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19078,'others',8) 
GO
INSERT INTO HtmlLabelIndex values(19095,'会议起止时间内会议室使用冲突，是否继续申请？')
GO
INSERT INTO HtmlLabelInfo VALUES(19095,'会议起止时间内会议室使用冲突，是否继续申请？',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19095,'time conflict of the meeting,whether or not continue?',8)
GO
INSERT INTO HtmlLabelIndex values(19097,'占用')
GO
INSERT INTO HtmlLabelIndex values(19098,'使用冲突')
GO
INSERT INTO HtmlLabelIndex values(19096,'空闲')
GO
INSERT INTO HtmlLabelInfo VALUES(19096,'空闲',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19096,'vacancy',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19097,'占用',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19097,'use',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19098,'使用冲突',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19098,'use conflict',8)
GO

