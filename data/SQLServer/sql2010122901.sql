delete from HtmlLabelIndex where id=25482 
GO
delete from HtmlLabelInfo where indexid=25482 
GO
INSERT INTO HtmlLabelIndex values(25482,'设置为0或空表示不进行备份，默认备份周期是一天（1440分钟），大于0且小于等于1440分钟则按照1440分钟备份，大于1440分钟即按照设置的时间进行备份') 
GO
INSERT INTO HtmlLabelInfo VALUES(25482,'设置为0或空表示不进行备份，默认备份周期是一天（1440分钟），小于等于1440分钟则按照1440分钟备份，大于1440分钟即按照设置的时间进行备份',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25482,'Set to 0 or empty says not to back up, the default backup cycle is the day (1,440 minutes), greater than 0 and less or equal to 1,440 minutes 1,440 minutes criterion according to greater than 1,440 minutes namely backup, according to setup time for backup',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25482,'設置為0或空表示不進行備份，默認備份週期是一天（1440分鐘），大於0且小於等於1440分鐘則按照1440分鐘備份，大於1440分鐘即按照設置的時間進行備份',9) 
GO
