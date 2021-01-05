update systemrights set detachable=1 where id=37
GO
update systemrights set detachable=1 where id=381
GO

insert into systemrighttogroup(groupid,rightid) values(3,381)
GO
update systemrights set rightdesc='考勤种类维护' where id=37
GO
update SystemRightsLanguage set rightname='考勤种类维护',rightdesc='考勤种类维护' where id=37 and languageid=7
GO
update mainmenuinfo set linkaddress='/hrm/schedule/HrmScheduleDiff_frm.jsp' where id=82
GO
INSERT INTO HtmlLabelIndex values(19374,'应用范围')
GO
INSERT INTO HtmlLabelIndex values(19375,'以考勤月记录计算')
GO
INSERT INTO HtmlLabelInfo VALUES(19374,'应用范围',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19374,'apply scope',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19375,'以考勤月记录计算',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19375,'calculate by month record',8)
GO
alter table hrmschedulediff add diffscope int
GO
alter table hrmschedulediff add subcompanyid int
GO
INSERT INTO HtmlLabelIndex values(19397,'考勤月记录')
GO
INSERT INTO HtmlLabelInfo VALUES(19397,'考勤月记录',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19397,'time check record monthly',8)
GO
EXECUTE MMConfig_U_ByInfoInsert 47,4
GO
EXECUTE MMInfo_Insert 514,19397,'','/hrm/schedule/HrmScheduleMonth_frm.jsp','mainFrame',47,2,4,0,'',0,'',0,'','',0,'','',2
GO
create table HrmScheduleMonth (hrmid int,
                                 difftype int,
                                 hours float,
                                 theyear char(4),
                                 themonth char(2))
GO
INSERT INTO HtmlLabelIndex values(19421,'我的考勤')
GO
INSERT INTO HtmlLabelInfo VALUES(19421,'我的考勤',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19421,'my roll',8)
GO
EXECUTE LMConfig_U_ByInfoInsert 2,5,8
GO
EXECUTE LMInfo_Insert 162,19421,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_9.gif','/hrm/schedule/HrmScheduleMonthPersonal.jsp',2,5,8,2
GO
INSERT INTO HtmlLabelIndex values(19428,'考勤月已存在')
GO
INSERT INTO HtmlLabelInfo VALUES(19428,'所选考勤月已存在，请重新选择。',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19428,'the month has existed,please reselect.',8)
GO
declare @detachable int
declare @defaultsubcom int
declare @minsubcom int
select @detachable=detachable,@defaultsubcom=dftsubcomid  from systemset
if(@detachable<>null and @defaultsubcom<>null)
update  hrmschedulediff set diffscope=0,subcompanyid=@defaultsubcom
else
begin
select @minsubcom=min(id)  from hrmsubcompany
update  hrmschedulediff set diffscope=0,subcompanyid=@minsubcom
end
GO