create table hpBaseElement(
	id int  NOT NULL,
	elementtype	Char(1)	Not null,
	title	Varchar(200)	null,
	logo	Varchar(500)	null,
	perpage	Int	null,
	linkmode	Char(1)	null,
	moreurl	Varchar(500)	null,
	elementdesc	Varchar(1000)	null
)
GO

INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 1,'2','RSS阅读器
','/images/homepage/element/1.gif',5,'2','getRssMore','可以直接填定RSS地址以及RSS主题')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 7,'2','新闻中心
','/images/homepage/element/3.gif',5,'2','getNews','系统中所有的新闻')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 8,'1','待办事宜
','/images/homepage/element/4.gif',5,'2','getNoreadFlow','系统流程部分的待办事宜')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 11,'1','最新客户
','/images/homepage/element/7.gif',5,'3','getNewCrmMore','对于我来说最新的客户')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 12,'1','最新会议
','/images/homepage/element/8.gif',5,'2','getNewMettingMore','最新的会议')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 6,'1','未读文档
','/images/homepage/element/2.gif',5,'2','getNoReadDoc','系统中所有的未读文档!')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 13,'1','未读协作
','/images/homepage/element/9.gif',5,'2','getNoReadCword','未读协作')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 14,'1','当月目标
','/images/homepage/element/10.gif',5,'2','getMoreTarget','当月目标')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 15,'1','当日计划
','/images/homepage/element/11.gif',5,'2','getWorkPlanMore','当日计划')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 16,'2','我的邮件
','/images/homepage/element/12.gif',5,'2','getMyMail','我的邮件')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 9,'1','消息提醒
','/images/homepage/element/5.gif',5,'2','getNoteMore','系统中的消息提醒')
GO
INSERT INTO hpBaseElement( id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) VALUES ( 10,'1','我的项目
','/images/homepage/element/6.gif',5,'2','getNewProj','我能看到的审批通过并且还没有结束的项目')
GO



create table hpFieldElement(
	id int  NOT NULL,
	elementid	Int	Not null,
	fieldname	Varchar(30)	Not null,
	fieldColumn	Varchar(300)	Not null,
	isDate	Char(1)	Not null,
	transMethod	Varchar(300)	null,
	fieldwidth Varchar(10)	Not null,
	linkurl	Varchar(300)	Null,
	valuecolumn	Varchar(50)	null,
	isLimitLength	char(1)	null,
	ordernum int	Not null
)
GO

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 1,1,'229','subject','0','','*','','','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 2,1,'1339','createtime','1','','62','','','',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 7,7,'229','docdocsubject','0','','*','/docs/docs/DocDsp.jsp?id=','id','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 4,6,'229','docsubject','0','','*','/docs/docs/DocDsp.jsp?id=','id','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 5,6,'19521','doclastmoddate','1','','76','','','',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 6,6,'19520','doclastmodtime','1','','62','','','',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 8,7,'19521','doclastmoddate','1','','76','','','',4)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 9,7,'19520','doclastmodtime','1','','62','','','',5)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 10,7,'341','summary','0','','','','','1',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 11,7,'74','img','0','','','','','0',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 12,8,'229','requestname','0','getRequestNewLink','*','','','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 13,8,'882','creater','0','getHrmStr','50','','','0',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 14,8,'17994','receivedate','1','','76','','','0',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 15,8,'18002','receivetime','1','','62','','','0',4)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 16,9,'195','typedescription','0','getInfoRemindLable','*','','','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 17,9,'16816','count','0','getInfoRemindStr','20','','','0',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 27,12,'2151','name','0','','*','/meeting/data/ViewMeeting.jsp?meetingid=','id','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 28,12,'780','address','0','','50','/meeting/Maint/MeetingRoom.jsp?id=','address','',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 29,12,'19559','begindate','1','','76','','','',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 30,12,'19560','begintime','1','','62','','','',4)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 31,13,'195','name','0','','*','/cowork/ViewCoWork.jsp?id=','id','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 32,13,'271','creater','0','getHrmStr','50','','','',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 33,13,'722','createdate','1','','76','','','',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 34,13,'1339','createtime','1','','62','','','',4)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 35,16,'344','subject','0','','*','/email/WeavermailDetail.jsp?msgid=','','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 36,16,'2034','priority','0','','40','','','0',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 37,16,'2035','senddate','0','','126','','','',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 40,15,'195','name','0','','*','/workplan/data/WorkPlanDetail.jsp?workid=','','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 41,15,'15534','urgentLevel','0','getWorkPlanStatusName','40','','','0',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 42,15,'1035','enddate','1','','76','','','0',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 43,15,'1036','endtime','1','','62','','','0',4)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 44,14,'18238','goalname','0','','*','','','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 45,14,'6071','percent_n','0','','40','','','0',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 18,1,'722','createdate','1','','76','','','0',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 19,10,'229','name','0','','*','/proj/data/ViewProject.jsp?ProjID=','id','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 20,10,'587','status','0','getProjStatusName','40','','','',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 21,10,'19550','planenddate','0','','76','','','',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 22,10,'19551','planendtime','0','','62','','','',4)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 23,11,'16857','name','0','','*','','','',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 24,11,'18901','movedate','1','','76','','','',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 25,11,'19552','movetime','1','','62','','','',4)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 26,11,'15078','status','0','','50','','','',2)
GO



create table hpWhereElement(
	id int NOT NULL,
	elementid	Int	Not null,
	settingshowmethod	Varchar(300)	Not null,
	getwheremethod	Varchar(300)	Not null
)
GO

INSERT INTO hpWhereElement( id,elementid,settingshowmethod,getwheremethod) VALUES ( 2,1,'getRssSettingStr','')
GO
INSERT INTO hpWhereElement( id,elementid,settingshowmethod,getwheremethod) VALUES ( 6,7,'getNewsSettingStr','')
GO
INSERT INTO hpWhereElement( id,elementid,settingshowmethod,getwheremethod) VALUES ( 9,8,'getWfSettingStr','')
GO
INSERT INTO hpWhereElement( id,elementid,settingshowmethod,getwheremethod) VALUES ( 11,9,'getInfoRemindSettingStr','')
GO
INSERT INTO hpWhereElement( id,elementid,settingshowmethod,getwheremethod) VALUES ( 13,13,'getCworkSettingStr','')
GO



create table hpSqlElement(
	id int IDENTITY (1, 1) NOT NULL,
	elementid	Int	Not null,
	sppbMethod	Varchar(1000)	null
)
GO

INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 6,'getNoReadDocSpb')
GO
INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 8,'getNoReadWfSpb')
GO
INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 9,'getInfoRemaind')
GO
INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 10,'getProjectSppb')
GO
INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 12,'getNewMeetingSppb')
GO
INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 13,'getNewCworkSppb')
GO
INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 14,'getMonthTargetSppb')
GO
INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 11,'getNewCrmSppb')
GO
INSERT INTO hpSqlElement( elementid,sppbMethod) VALUES ( 15,'getDayPlanSppb')
GO



create table hpextelement(
   id int not null,
   extsettinge varchar(300) null,
   extopreate varchar(300) null,
   extshow varchar(300) null,
   description   varchar(300) null
)
GO

INSERT INTO hpextelement( id,extsettinge,extopreate,extshow,description) VALUES ( 1,'','','getRssContent','rss特殊处理')
GO
INSERT INTO hpextelement( id,extsettinge,extopreate,extshow,description) VALUES ( 7,'','','getNewsContent','新闻内容的显示')
GO
INSERT INTO hpextelement( id,extsettinge,extopreate,extshow,description) VALUES ( 16,'','','getEmailContent','邮件内容的显示')
GO



create clustered index hpextelement_id_clu on hpextelement (id)
GO



create table  hpElement(
	id int IDENTITY (1, 1) NOT NULL,
	title	Varchar(30)	null,
	logo	Varchar(500)	null,
	islocked	Char(1)	Not null,
	strsqlwhere	Varchar(2000)	null,
	ebaseid	Int	Not null,	
	isSysElement	Char(1)	Not null,
	hpid	Int 	Not null
)
GO


create table  hpElementSettingDetail(
	id int IDENTITY (1, 1) NOT NULL,
	userid	Int	Not null,
	usertype	Int	Not null,
	eid	Int	Not null,
	perpage	Int	Not null,
	linkmode	Int	Not null,
	showfield	Varchar(500)	null,
	sharelevel       char(1),
	hpid            int null
)
GO


create table hpFieldLength(
	id int IDENTITY (1, 1) NOT NULL,
	eid	Int	Not null,
	userid	Int	Null,
	usertype	Int	Null,
	efieldid	int	Not null,
	charnum	int	Not null
)
GO

alter table SystemSet  add  defUseNewHomepage Char(1)
GO

update  systemSet  set defUseNewHomepage='1'
GO



create table  hpinfo(
	id int IDENTITY (1, 1) NOT NULL,
	infoname	Varchar(50)	Not null,
	infodesc	Varchar(500)	null,
	styleid	int	Not null,
	layoutid	int	Not null,
	Subcompanyid	int	Not null,
	isUse	Char(1)	Not null
)
GO



create table  hpsubcompanyappiont(
	id int IDENTITY (1, 1) NOT NULL,
	subcompanyid	Int	Not null,
	infoid	Int	Not null 
)
GO



create table  hpuserselect(
	id int IDENTITY (1, 1) NOT NULL,
	userid	Int	Not null,
	infoid	Int	Not null
)
GO




create table  hpBaseLayout(
	id int  NOT NULL,
	layoutname	Varchar(50)	Not null,
	layoutdesc	Varchar(500)	null,
	layoutimage	Varchar(200)	Not null,
	layoutcode	Varchar(2000)	Not null,
	allowArea	Varchar(50)	Not null
)
GO


insert into hpbaselayout(id,layoutname,layoutdesc,layoutimage,layoutcode,allowarea )
values(1,'一栏布局','一栏布局','\images\homepage\layout\layout_01.png','<table border=0 cellpadding=0 cellspacing=10 width=100%  
id=parentTable><tr><td id=area_A  width=W$_A  valign=top  areaflag=A><TABLE width=100% id=tblInfo style=''font-size:12px; border:1px 
solid #bdbebd;margin-bottom:10px;display:none''><TR><TD  id=tdInfo></TD></TR></TABLE><!--E$_A--></td></tr></table>','A')
GO

insert into hpbaselayout(id,layoutname,layoutdesc,layoutimage,layoutcode,allowarea )
values(2,'二栏布局','二栏布局','\images\homepage\layout\layout_02.png','<table border=0 cellpadding=0 cellspacing=10 width=100%  
id=parentTable><tr><td id=area_A  width=W$_A  valign=top  areaflag=A><TABLE width=100% id=tblInfo style=''font-size:12px; border:1px 
solid #bdbebd;margin-bottom:10px;display:none''><TR><TD  id=tdInfo></TD></TR></TABLE><!--E$_A--></td><td id=area_B  width=W$_B  
valign=top  areaflag=B><!--E$_B--></td></tr></table>','A,B')
GO


insert into hpbaselayout(id,layoutname,layoutdesc,layoutimage,layoutcode,allowarea )
values(3,'三栏布局','三栏布局','\images\homepage\layout\layout_03.png','<table border=0 cellpadding=0 cellspacing=10 width=100%  
id=parentTable><tr><td id=area_A  width=W$_A  valign=top  areaflag=A><TABLE width=100% id=tblInfo style=''font-size:12px; border:1px 
solid #bdbebd;margin-bottom:10px;display:none''><TR><TD  id=tdInfo></TD></TR></TABLE><!--E$_A--></td><td id=area_B  width=W$_B  
valign=top  areaflag=B><!--E$_B--></td><td id=area_C  width=W$_C  valign=top  areaflag=C><!--E$_C--></td></tr></table>','A,B,C')
GO

insert into hpbaselayout(id,layoutname,layoutdesc,layoutimage,layoutcode,allowarea )
values(4,'其它布局1','其它布局1','\images\homepage\layout\layout_04.png','<table border=0 cellpadding=0 cellspacing=10 width=100%  
id=parentTable><tr><td colspan=2 id=area_A  width=W$_A  valign=top  areaflag=A> <TABLE width=100% id=tblInfo style=''font-size:12px; 
border:1px solid #bdbebd;margin-bottom:10px;display:none''><TR><TD  id=tdInfo></TD></TR></TABLE><!--E$_A-->  </td>   <td rowspan=2 
id=area_B  width=W$_B  valign=top  areaflag=B><!--E$_B--></td>  </tr>  <tr>    <td id=area_C  width=W$_C  valign=top  
areaflag=C><!--E$_C--></td>    <td id=area_D  width=W$_D  valign=top  areaflag=D><!--E$_D--></td>  </tr></table>','A,B,C,D')
GO

insert into hpbaselayout(id,layoutname,layoutdesc,layoutimage,layoutcode,allowarea )
values(5,'其它布局2','其它布局2','\images\homepage\layout\layout_05.png','<table border=0 cellpadding=0 cellspacing=10 width=100%  
id=parentTable> <tr><td id=area_A  width=W$_A  valign=top  areaflag=A>	<TABLE width=100% id=tblInfo style=''font-size:12px; border:1px 
solid #bdbebd;margin-bottom:10px;display:none''><TR><TD  id=tdInfo></TD></TR></TABLE><!--E$_A--></td>    <td id=area_B  width=W$_B  
valign=top  areaflag=B><!--E$_B--></td>    <td rowspan="2" id=area_C width=W$_C  valign=top  areaflag=C><!--E$_C--></td>  </tr>  <tr>    
 <td colspan="2" id=area_D  width=W$_D valign=top areaflag=D><!--E$_D--></td>  </tr></table>','A,B,C,D')
GO



create table  hpLayout(
	id	Int	IDENTITY (1, 1) NOT NULL,
	hpid	Int	Not null,
	layoutbaseid	Int	null,
	areaflag	Varchar(50)	Not null,
	areasize	Varchar(50)	null,
        areaElements    varchar(500)    default '',
	userid	Int	null,
        usertype	Int	null

 )
GO


create table hpstyle(
	id int  IDENTITY (1, 1)  NOT NULL,
	stylename	Varchar(50)	Not null,
	styledesc	Varchar(500)	null,
	hpbgimg	Varchar(100)	null,
	hpbgcolor	Varchar(20)	null,
	etitlebgimg	Varchar(100)	null,
	etitlebgcolor	Varchar(20)	null,
	ebgimg	Varchar(100)	null,
	ebgcolor	Varchar(20) null,
	etitlecolor	Varchar(20)	null,
	ecolor	Varchar(20)	null,
	ebordercolor	Varchar(20)	null,
	edatemode	Varchar(1)	null,
	etimemode	Varchar(1)	null,
	elockimg1	Varchar(100)	null,
	elockimg2	Varchar(100)	null,
	eunlockimg1	Varchar(100)	null,
	eunlockimg2	Varchar(100)	null,
	erefreshimg1	Varchar(100)	Null,
	erefreshimg2	Varchar(100)	Null,
	esettingimg1	Varchar(100)	Null,
	esettingimg2	Varchar(100)	Null,
	ecoloseimg1	Varchar(100)	Null,
	ecoloseimg2	Varchar(100)	Null,
	emoreimg1	Varchar(100)	Null,
	emoreimg2	Varchar(100)	Null,
	esparatorimg	Varchar(100)	Null,
	esymbol	Varchar(100)	Null,
	issystemdefualt char(1) default '0'
)
GO

INSERT INTO hpstyle(stylename,styledesc,hpbgimg,hpbgcolor,etitlebgimg,etitlebgcolor,ebgimg,ebgcolor,etitlecolor,ecolor,ebordercolor,edatemode,etimemode,elockimg1,elockimg2,eunlockimg1,eunlockimg2,erefreshimg1,erefreshimg2,esettingimg1,esettingimg2,ecoloseimg1,ecoloseimg2,emoreimg1,emoreimg2,esparatorimg,esymbol,issystemdefualt) VALUES ('系统样式一','系统样式一','','','','#BBE3F9','','','#000000','#000000','#BBE3F9','','','/images/homepage/style/style1/lock1.gif','/images/homepage/style/style1/lock2.gif','/images/homepage/style/style1/unlock1.gif','/images/homepage/style/style1/unlock2.gif','/images/homepage/style/style1/refresh1.gif','/images/homepage/style/style1/refresh2.gif','/images/homepage/style/style1/setting1.gif','/images/homepage/style/style1/setting2.gif','/images/homepage/style/style1/close1.gif','/images/homepage/style/style1/close2.gif','/images/homepage/style/style1/more1.gif','/images/homepage/style/style1/more2.gif','/images/homepage/style/style1/esparatorimg.gif','/images/homepage/style/style1/esymbol.gif','1')
GO




insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse)
values ('系统默认首页1','系统默认首页1',1,1,0,2)
GO

insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse)
values ('系统默认首页2','系统默认首页2',1,1,0,2)
GO


insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaelements,userid,usertype)
values (1,1,'A','100%','',1,4)
GO


insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaelements,userid,usertype)
values (2,1,'A','100%','',1,4)
GO


insert into SystemRights (id,rightdesc,righttype,detachable) values (659,'首页维护权限','7',1) 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (659,7,'首页维护权限','首页维护权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (659,8,'homepage maintenance','homepage maintenance') 
GO


insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4159,'首页维护权限','homepage:Maint',659) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4162,'首页样式维护','homepage:styleMaint',659) 
GO
insert into SystemRightToGroup (groupid, rightid) values (1,659)
GO



EXECUTE MMConfig_U_ByInfoInsert 11,20
GO
EXECUTE MMInfo_Insert 515,19100,'首页设置
','/homepage/maint/HomepageManit.jsp','mainFrame',11,1,20,0,'',0,'',0,'','',0,'','',9
GO


EXECUTE MMConfig_U_ByInfoInsert 11,20
GO
EXECUTE MMInfo_Insert 519,19439,'首页样式维护
','/homepage/style/HomepageStyleList.jsp','mainFrame',11,1,20,0,'',0,'',0,'','',0,'','',9
GO




INSERT INTO HtmlLabelIndex values(19405,'首页兼容性设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19405,'首页兼容性设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19405,'homepage compatibility setting',8) 
GO


INSERT INTO HtmlLabelIndex values(19406,'默认使用新首页') 
GO
INSERT INTO HtmlLabelInfo VALUES(19406,'默认使用新首页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19406,'default use new homepage',8) 
GO


INSERT INTO HtmlLabelIndex values(19407,'布局') 
GO
INSERT INTO HtmlLabelInfo VALUES(19407,'布局',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19407,'layout',8) 
GO


INSERT INTO HtmlLabelIndex values(19408,'元素') 
GO
INSERT INTO HtmlLabelInfo VALUES(19408,'元素',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19408,'Element',8) 
GO


INSERT INTO HtmlLabelIndex values(19419,'添加自定义元素') 
GO
INSERT INTO HtmlLabelInfo VALUES(19419,'添加自定义元素',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19419,'Add new customer element',8) 
GO

INSERT INTO HtmlLabelIndex values(19420,'以下是允许你选择的主页') 
GO
INSERT INTO HtmlLabelInfo VALUES(19420,'以下是允许你选择的主页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19420,'It`s allow you selected follow this',8) 
GO

INSERT INTO HtmlLabelIndex values(19422,'引用') 
GO
INSERT INTO HtmlLabelInfo VALUES(19422,'引用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19422,'reference',8) 
GO


INSERT INTO HtmlLabelIndex values(19423,'请选择需引用的首页') 
GO
INSERT INTO HtmlLabelIndex values(19425,'请选择需引用的样式') 
GO
INSERT INTO HtmlLabelIndex values(19424,'请选择需引用的布局') 
GO
INSERT INTO HtmlLabelInfo VALUES(19423,'请选择需引用的首页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19423,'please select a homepage',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19424,'请选择需引用的布局',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19424,'please select a layout',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19425,'请选择需引用的样式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19425,'please select a style',8) 
GO


INSERT INTO HtmlLabelIndex values(19426,'效果图') 
GO
INSERT INTO HtmlLabelInfo VALUES(19426,'效果图',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19426,'effect picture',8) 
GO


INSERT INTO HtmlLabelIndex values(19431,'你必须要选择一个首页才能提交！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19431,'你必须要选择一个首页才能提交！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19431,'before commit you must select a homepage!',8) 
GO


INSERT INTO HtmlLabelIndex values(19433,'新建首页向导') 
GO
INSERT INTO HtmlLabelInfo VALUES(19433,'新建首页向导',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19433,'new homepage guide',8) 
GO

INSERT INTO HtmlLabelIndex values(19434,'新建自定义样式') 
GO
INSERT INTO HtmlLabelInfo VALUES(19434,'新建自定义样式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19434,'create new style',8) 
GO


INSERT INTO HtmlLabelIndex values(19439,'首页样式维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(19439,'首页样式维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19439,'homepage style maintance',8) 
GO



INSERT INTO HtmlLabelIndex values(19440,'首页样式') 
GO
INSERT INTO HtmlLabelInfo VALUES(19440,'首页样式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19440,'homepage style',8) 
GO
 

INSERT INTO HtmlLabelIndex values(19443,'标题栏背景') 
GO
INSERT INTO HtmlLabelIndex values(19446,'非锁定') 
GO
INSERT INTO HtmlLabelIndex values(19448,'行前图标') 
GO
INSERT INTO HtmlLabelIndex values(19444,'时间显示方式') 
GO
INSERT INTO HtmlLabelIndex values(19445,'边框颜色') 
GO
INSERT INTO HtmlLabelIndex values(19447,'行分隔符') 
GO
INSERT INTO HtmlLabelInfo VALUES(19443,'标题栏背景',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19443,'title backgroud',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19444,'时间显示方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19444,'time format',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19445,'边框颜色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19445,'border color',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19446,'非锁定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19446,'unlock',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19447,'行分隔符',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19447,'row sparator',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19448,'行前图标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19448,'image befor row',8) 
GO

INSERT INTO HtmlLabelIndex values(19469,'首页样式还没保存，数据将会丢失，确认要离开吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19469,'首页样式还没保存，数据将会丢失，确认要离开吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19469,'homepage style isn''t save. if you left data will be lost ,are you 
srue',8) 
GO


INSERT INTO HtmlLabelIndex values(19484,'请填写以下基本信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(19484,'请填写以下基本信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19484,'please fill the base info',8) 
GO


INSERT INTO HtmlLabelIndex values(19486,'系统元素库') 
GO
INSERT INTO HtmlLabelInfo VALUES(19486,'系统元素库',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19486,'system element lib',8) 
GO

INSERT INTO HtmlLabelIndex values(19487,'添加此元素到') 
GO
INSERT INTO HtmlLabelInfo VALUES(19487,'添加此元素到',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19487,'add this element to',8) 
GO
 

INSERT INTO HtmlLabelIndex values(19491,'元素标题') 
GO
INSERT INTO HtmlLabelIndex values(19496,'显示条件') 
GO
INSERT INTO HtmlLabelIndex values(19497,'当前页') 
GO
INSERT INTO HtmlLabelIndex values(19498,'弹出页') 
GO
INSERT INTO HtmlLabelIndex values(19493,'显示条数') 
GO
INSERT INTO HtmlLabelIndex values(19494,'链接方式') 
GO
INSERT INTO HtmlLabelIndex values(19495,'显示字段') 
GO
INSERT INTO HtmlLabelIndex values(19492,'元素图标') 
GO
INSERT INTO HtmlLabelInfo VALUES(19491,'元素标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19491,'Element title',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19492,'元素图标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19492,'element icon',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19493,'显示条数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19493,'perpage',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19494,'链接方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19494,'link mode',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19495,'显示字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19495,'show field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19496,'显示条件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19496,'show where',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19497,'当前页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19497,'current page',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19498,'弹出页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19498,'pop-up page',8) 
GO




INSERT INTO HtmlLabelIndex values(19510,'请设置布局比例') 
GO
INSERT INTO HtmlLabelInfo VALUES(19510,'请设置布局比例',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19510,'please set the scale of layout',8) 
GO

INSERT INTO HtmlLabelIndex values(19520,'最后修改时间') 
GO
INSERT INTO HtmlLabelIndex values(19521,'最后修改日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(19520,'最后修改时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19520,'the last modify time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19521,'最后修改日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19521,'the last modify date',8) 
GO


INSERT INTO HtmlLabelIndex values(19524,'字数') 
GO
INSERT INTO HtmlLabelInfo VALUES(19524,'字数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19524,'word count',8) 

GO
INSERT INTO HtmlLabelIndex values(19525,'列表式') 
GO
INSERT INTO HtmlLabelIndex values(19526,'上图式') 
GO
INSERT INTO HtmlLabelIndex values(19527,'左图式') 
GO
INSERT INTO HtmlLabelInfo VALUES(19525,'列表式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19525,'list table mode',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19526,'上图式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19526,'the picture up mode',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19527,'左图式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19527,'the picture left mode',8) 
GO


INSERT INTO HtmlLabelIndex values(19550,'计划完成日期') 
GO
INSERT INTO HtmlLabelIndex values(19551,'计划完成时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(19550,'计划完成日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19550,'the date all done',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19551,'计划完成时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19551,'the time all done',8) 
GO

INSERT INTO HtmlLabelIndex values(19552,'分配时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(19552,'分配时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19552,'Distribute Time',8) 
GO

INSERT INTO HtmlLabelIndex values(19553,'显/隐元素库') 
GO
INSERT INTO HtmlLabelInfo VALUES(19553,'显/隐元素库',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19553,'Show/Hide Element Lib',8) 
GO

INSERT INTO HtmlLabelIndex values(19560,'会议开始时间') 
GO
INSERT INTO HtmlLabelIndex values(19559,'会议开始日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(19559,'会议开始日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19559,'meeting begin date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19560,'会议开始时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19560,'meeting begin time',8) 
GO
INSERT INTO HtmlLabelIndex values(19566,'取消使用此设置') 
GO
INSERT INTO HtmlLabelIndex values(19565,'确定使用此设置') 
GO
INSERT INTO HtmlLabelIndex values(19567,'到旧首页') 
GO
INSERT INTO HtmlLabelInfo VALUES(19565,'确定使用此设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19565,'confirm use this seeting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19566,'取消使用此设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19566,'cancel use this setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19567,'到旧首页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19567,'go to the old page',8) 
GO
INSERT INTO HtmlLabelIndex values(19568,'到新首页') 
GO
INSERT INTO HtmlLabelInfo VALUES(19568,'到新首页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19568,'go to the new homepage',8) 
GO

UPDATE hpFieldElement   SET  linkurl = '/CRM/data/ViewCustomer.jsp?CustomerID=', isLimitlength = '1',  valuecolumn = 'id'    WHERE id = 23
GO
UPDATE hpFieldElement   SET  transmethod = 'getCrmPlanStatusName'    WHERE id = 26
GO


INSERT INTO HtmlLabelIndex values(19100,'首页设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19100,'首页设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19100,'Frontpage Set',8) 
GO
