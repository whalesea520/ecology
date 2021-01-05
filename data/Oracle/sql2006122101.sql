delete from HtmlLabelIndex where id in(20032,20033,20034,20035,20036,20037,20038,20039,20044,20045)
/
delete from HtmlLabelInfo where indexId in(20032,20033,20034,20035,20036,20037,20038,20039,20044,20045)
/
INSERT INTO HtmlLabelIndex values(20032,'签到') 
/
INSERT INTO HtmlLabelIndex values(20036,'如因工作原因迟到或早退请提交相应流程') 
/
INSERT INTO HtmlLabelIndex values(20034,'您已成功签到') 
/
INSERT INTO HtmlLabelIndex values(20035,'签到时间') 
/
INSERT INTO HtmlLabelIndex values(20038,'您已成功签退') 
/
INSERT INTO HtmlLabelIndex values(20033,'签退') 
/
INSERT INTO HtmlLabelIndex values(20037,'签到（签退）时间') 
/
INSERT INTO HtmlLabelIndex values(20039,'签退时间') 
/
INSERT INTO HtmlLabelInfo VALUES(20032,'签到',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20032,'sign in',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20033,'签退',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20033,'sign out',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20034,'您已成功签到',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20034,'You have signed in successfully',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20035,'签到时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20035,'sign in time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20036,'如因工作原因迟到或早退请提交相应流程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20036,'Please submit related workflow if be late or leave early because of work reason',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20037,'签到（签退）时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20037,'sign in(sign out) time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20038,'您已成功签退',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20038,'You have signed out successfully',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20039,'签退时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20039,'sign out time',8) 
/

INSERT INTO HtmlLabelIndex values(20044,'签到签退设置') 
/
INSERT INTO HtmlLabelIndex values(20045,'签到签退ip') 
/
INSERT INTO HtmlLabelInfo VALUES(20044,'签到签退设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20044,'sign in or sign out set',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20045,'签到签退ip',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20045,'sign in or sign out ip',8) 
/