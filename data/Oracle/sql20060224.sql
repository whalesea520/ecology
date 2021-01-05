insert into SequenceIndex (indexdesc,currentid) values('alertid',1)
/

INSERT INTO HtmlLabelIndex values(18280,'季') 
/
INSERT INTO HtmlLabelInfo VALUES(18280,'季',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18280,'quarter',8) 
/

insert into SysPoppupInfo values (3,'/system/SysRemindGoalLink.jsp?type=3','目标建立提醒','y','目标建立')
/  
insert into SysPoppupInfo values (4,'/system/SysRemindGoalLink.jsp?type=4','计划建立提醒','y','计划建立')
/  
insert into SysPoppupInfo values (5,'/system/SysRemindGoalLink.jsp?type=5','提交报告提醒','y','提交报告')
/  

CREATE TABLE HrmPerformanceAlertCheck (
	id integer NOT NULL ,
	alertName varchar2 (100)  NULL ,
	cycle char (1)  NULL ,
	performanceDate varchar2 (50)  NULL ,
	performanceType char (1)  NULL ,
	objId integer NULL ,
	alertType char (1)  NULL 
)
/

ALTER TABLE HrmPerformanceAlertCheck  ADD 
	CONSTRAINT PK_HPfAlertCheck PRIMARY KEY 
	(
		id
	)
/

