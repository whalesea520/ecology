ALTER TABLE SystemLoginTemplate ADD  lasteditdate varchar2(100)
/
UPDATE SystemLoginTemplate SET lasteditdate ='2014-01-01'
/


UPDATE MainMenuInfo SET linkAddress = '/systeminfo/template/templateFrame.jsp' WHERE id = 1283
/

UPDATE MainMenuInfo SET linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=loginTemplate' WHERE id = 809
/


alter table hpBaseElement modify  linkmode char(2)
/
alter table hpBaseElement add isuse char(2) default '1' 
/
alter table hpBaseElement add titleEN varchar2(500)
/
alter table hpBaseElement add titleTHK varchar2(500)
/
alter table hpBaseElement add loginview char(1) default '0' 
/

INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( '20','2','新回复文档','New Reply Docs ','新回覆文檔','resource/image/Nrd.gif',-1,'-1','','查看回复自己创建的文档的回复文档')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'audio','2','音频元素','Audio ','音頻元素','resource/image/audio.gif',-1,'-1','','音频元素描述')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'blogStatus','1','微博动态','Microblogging ','微博動態','resource/image/slide.gif',-1,'-1','','工作微博的提醒')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'favourite','2','收藏元素','Collect ','收藏元素','resource/image/favourite.gif',-1,'2','','收藏元素')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'Flash','2','Flash元素','Flash ','Flash元素','resource/image/flash.gif',-1,'-1','','Flash元素描述')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'login','2','登录系统','Login ','登錄系統','resource/image/login.gif',-1,'2','','登录系统')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'menu','2','自定义菜单','Custom Menu ','自定義菜單','resource/image/menu.gif',-1,'1','','自定义菜单元素')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'news','2','公司新闻','News ','公司新聞','resource/image/news.gif',5,'2','','公司新闻')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'notice','2','公告栏元素','Announcement ','公告欄元素','resource/image/notice.gif',-1,'-1','','公告栏元素描述')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'picture','2','图片元素','Picture ','圖片元素','resource/image/picture.gif',-1,'-1','','图片元素描述')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'reportForm','2','图表元素','Report Form ','圖表元素','resource/image/reportForm.gif',-1,'-1','','图表元素')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'searchengine','2','搜索元素','Search ','搜索元素','resource/image/search.gif',-1,'-1','','搜索元素')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'Slide','1','幻灯片','Slideshow ','幻燈片','resource/image/slide.gif',-1,'-1','','幻灯片')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'video','2','视频元素','Video ','視頻元素','resource/image/video.gif',-1,'-1','','视频元素描述')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'weather','2','天气元素','Weather ','天氣元素','resource/image/weather.gif',-1,'-1','','天气元素')
/
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'scratchpad','2','便签元素','Notes ','便簽元素','resource/image/scratchpad.gif',-1,'-1','','随时记录你的idea')
/
UPDATE hpBaseElement set titleEN='RSS Reader ',titleTHK='RSS閱讀器' where id='1'
/
UPDATE hpBaseElement set titleEN='Unread Docs ',titleTHK='未讀文檔' where id='6'
/
UPDATE hpBaseElement set titleEN='Docs Center ',titleTHK='文檔中心' where id='7'
/
UPDATE hpBaseElement set titleEN='Workflow Center ',titleTHK='流程中心' where id='8'
/
UPDATE hpBaseElement set titleEN='Message reminding ',titleTHK='消息提醒' where id='9'
/
UPDATE hpBaseElement set titleEN='My Projects ',titleTHK='我的項目' where id='10'
/
UPDATE hpBaseElement set titleEN='New Customers ',titleTHK='最新客戶' where id='11'
/
UPDATE hpBaseElement set titleEN='Last Meeting ',titleTHK='最新會議' where id='12'
/
UPDATE hpBaseElement set titleEN='Unread Cooperation ',titleTHK='未讀協作' where id='13'
/
UPDATE hpBaseElement set titleEN='Month Target ',titleTHK='當月目標' where id='14'
/
UPDATE hpBaseElement set titleEN='Day Plan ',titleTHK='當日計畫' where id='15'
/
UPDATE hpBaseElement set titleEN='My E-mail ',titleTHK='我的郵件' where id='16'
/
UPDATE hpBaseElement set titleEN='More news ',titleTHK='多新聞中心' where id='17'
/
UPDATE hpBaseElement set titleEN='Periodical Center ',titleTHK='期刊中心' where id='18'
/
UPDATE hpBaseElement set titleEN='Stock ',titleTHK='股票元素' where id='19'
/
UPDATE hpBaseElement set titleEN='en',titleTHK='新反饋流程' where id='21'
/
UPDATE hpBaseElement set titleEN='Document Content ',titleTHK='文檔內容' where id='25'
/
UPDATE hpBaseElement set titleEN='Custom Pages ',titleTHK='自定義頁面' where id='29'
/
UPDATE hpBaseElement set titleEN='Scheduled Tasks ',titleTHK='計畫任務' where id='32'
/
UPDATE hpBaseElement set titleEN='en',titleTHK='圖表元素' where id='33'
/
UPDATE hpBaseElement set titleEN='Subscribe Knowledg ',titleTHK='知識訂閱' where id='34'
/
UPDATE hpBaseElement set loginview='1' where id in('login','news')
/
UPDATE hpBaseElement set loginview='2' where id in('19','29','audio','Flash','menu','notic','picture','reportForm','searchengine','Slide','video','weather')
/
UPDATE hpBaseElement set loginview='4' where id in('20','21')
/
UPDATE hpBaseElement set logo=REPLACE(logo,'/images/homepage/element/','resource/image/')
/


alter table hpElement add isRemind varchar2(200) default 'isnew'
/
alter table hpElement add fromModule varchar2(50)default 'Portal' 	
/
alter table hpElement add isuse int default 1 
/
alter table menucenter add menucreater varchar2(5) default '1' 
/
alter table menucenter add menulastdate varchar2(20) 
/
alter table menucenter add menulasttime varchar2(20)
/
create table hpMenuStyle(
	styleid varchar2(30),
	menustylename varchar2(200),
	menustyledesc varchar2(500),
	menustyletype varchar2(20),
	menustylecreater int,
	menustylemodifyid varchar2(4000),
	menustylelastdate varchar2(12),
	menustylelasttime varchar2(12),
	menustulecite varchar2(30)
)
/

alter table hpinfo add hplanuageid int default 7 
/
alter table hpinfo add hpcreatorid int default 1
/
alter table hpinfo add hplastdate varchar2(20) 
/
alter table hpinfo add hplasttime varchar2(20) 
/

create table ImageLibrary( 
	fileid int PRIMARY KEY,
	filename varchar2(200),
	filetype varchar2(50),
	filesize varchar2(50),
	filecreateid int,
	filelastdate varchar2(12),
	filelasttime varchar2(12),
	filedirid int,
	filedir varchar2(200),
	fileThumbnailspath varchar2(500),
	filerealpath varchar2(500)
)
/
create sequence ImageLibrary_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ImageLibrary_id_Tri
before insert on ImageLibrary
for each row
begin
select ImageLibrary_id.nextval into :new.id from dual;
end;
/

create table ImageFolder(
	dirid int  PRIMARY KEY,
	dirname varchar2(200),
	dirtype varchar2(10),
	dirparentid int,
	dirparentname varchar2(10),
	dirfilecount int,
	dirfileids clob,
	dircreateid int,
	dirlastdate varchar2(12),
	dirlasttime varchar2(12),
	dirrealpath varchar2(500)
)
/
create sequence ImageFolder_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ImageFolder_id_Tri
before insert on ImageFolder
for each row
begin
select ImageFolder_id.nextval into :new.id from dual;
end;
/


ALTER TABLE shareinnerhp ADD  lastdate varchar2(200)
/

ALTER TABLE shareinnerhp ADD  seclevelmax varchar2(200)
/
UPDATE shareinnerhp SET seclevelmax = 100
/

ALTER table hpMenuStyle add menustylecite varchar2(200)
/

CREATE TABLE  elementsetting(
	id INT,
	ebaseid varchar2(200), 
	title varchar2(200),
	clname varchar2(200), 
	fliedtype varchar2(200),
	defvalue  varchar2(2000)
	
)
/
create sequence elementsetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger elementsetting_id_Tri
before insert on elementsetting
for each row
begin
select elementsetting_id.nextval into :new.id from dual;
end;
/



CREATE TABLE  elementsettingitem( 
	id INT,
	ebaseid varchar2(200),
	tabid int,
	itemname varchar2(2000),
	itemvalue varchar2(2000)
	
)
/
create sequence elementsettingitem_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger elementsettingitem_id_Tri
before insert on elementsettingitem
for each row
begin
select elementsettingitem_id.nextval into :new.id from dual;
end;
/

create table ElementUseInfo(
   userid int,
   usertype int,
   layoutid int,
   eid int
)
/
create table ColorStyleInfo(
   userid int,
   style varchar2(200)
)
/
ALTER TABLE LeftMenuInfo ADD  menucss varchar(200)
/

UPDATE MainMenuInfo set labelid='32457',menuname='员工门户',defaultIndex=1 where id=808
/
UPDATE mainmenuconfig set viewIndex=1 where infoId=808
/

UPDATE MainMenuInfo set labelid='32459',menuname='登录前门户',defaultIndex=1 where id=809
/
UPDATE mainmenuconfig set viewIndex=1 where infoId=809
/

UPDATE MainMenuInfo set labelid='32464',menuname='门户布局库',defaultIndex=5,defaultParentId=1280,parentId=1280 where id=800
/
UPDATE mainmenuconfig set viewIndex=5 where infoId=800
/

UPDATE MainMenuInfo set labelid='32462',menuname='门户主题库',defaultIndex=1,defaultParentId=1280,parentId=1280 where id=810
/
UPDATE mainmenuconfig set viewIndex=1 where infoId=810
/

UPDATE MainMenuInfo set labelid='32129',menuname='门户菜单库',defaultIndex=2,defaultParentId=1280,parentId=1280 where id=805
/
UPDATE mainmenuconfig set viewIndex=2 where infoId=805
/

UPDATE MainMenuInfo set labelid='32126',menuname='菜单样式库',defaultIndex=3,defaultParentId=1280,parentId=1280,linkaddress='/page/maint/style/MenuStyleList.jsp' where id=798
/
UPDATE mainmenuconfig set viewIndex=3 where infoId=798
/

UPDATE MainMenuInfo set labelid='32466',menuname='元素样式库',defaultIndex=8,defaultParentId=1280,parentId=1280,linkaddress='/page/maint/style/ElementStyleList.jsp' where id=796
/
UPDATE mainmenuconfig set viewIndex=8 where infoId=796
/

UPDATE MainMenuInfo set labelid='23088',menuname='新闻模版库',defaultIndex=9,defaultParentId=1280,parentId=1280,linkaddress='/page/maint/template/news/NewsTemplateList.jsp' where id=801
/
UPDATE mainmenuconfig set viewIndex=9 where infoId=801
/

UPDATE MainMenuInfo set labelid='32463',menuname='门户页面库',defaultIndex=4,defaultParentId=1280,parentId=1280 where id=802
/
UPDATE mainmenuconfig set viewIndex=4 where infoId=802
/

UPDATE MainMenuInfo set labelid='24666',menuname='页面布局库',defaultIndex=6,defaultParentId=1280,parentId=1280,linkaddress='/page/maint/layout/LayoutList.jsp' where id=767
/
UPDATE mainmenuconfig set viewIndex=6 where infoId=767
/

UPDATE MainMenuInfo set labelid='32127',menuname='系统使用菜单',defaultIndex=1,defaultParentId=805,parentId=805,linkaddress='/page/maint/menu/SystemMenuMaint.jsp?type=left' where id=807
/
UPDATE mainmenuconfig set viewIndex=1 where infoId=807
/

UPDATE MainMenuInfo set labelid='32128',menuname='系统维护菜单',defaultIndex=2,defaultParentId=805,parentId=805,linkaddress='/page/maint/menu/SystemMenuMaint.jsp?type=top' where id=797
/
UPDATE mainmenuconfig set viewIndex=2 where infoId=797
/

UPDATE MainMenuInfo set labelid='18773',menuname='自定义菜单',defaultIndex=3,defaultParentId=805,parentId=805,linkaddress='/page/maint/menu/SystemMenuMaint.jsp?type=custom' where id=806
/
UPDATE mainmenuconfig set viewIndex=3 where infoId=806
/

UPDATE MainMenuInfo set defaultIndex=1,defaultParentId=802,parentId=802 where id=803
/
UPDATE mainmenuconfig set viewIndex=1 where infoId=803
/

UPDATE MainMenuInfo set defaultIndex=2,defaultParentId=802,parentId=802 where id=804
/
UPDATE mainmenuconfig set viewIndex=2 where infoId=804
/

UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=menuStyle' where id=798
/
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=hpLayout' where id=767
/
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=eStyle' where id=796
/
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=pLayout' where id=800
/
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=newsTemplate' where id=801
/
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=pElement' where id=1287
/
UPDATE mainMenuInfo set linkAddress = '/portal/PortalTabs.jsp?_fromURL=ecology8' where id=810
/

create table hpareaelement(
	id int primary key,
	hpid int,
	eid int,
	ebaseid varchar2(30),
	userid int,
	usertype int,
	module varchar2(20),
	modelastdate varchar2(12),
	modelasttime varchar2(12),
	ordernum int 
)
/
create sequence hpareaelement_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger hpareaelement_id_Tri
before insert on hpareaelement
for each row
begin
select hpareaelement_id.nextval into :new.id from dual;
end;
/

ALTER TABLE LeftMenuInfo ADD  topmenuname varchar2(200) 
/
ALTER TABLE LeftMenuInfo ADD  topname_e varchar2(200) 
/
ALTER TABLE LeftMenuInfo ADD  topname_t varchar2(200) 
/
ALTER TABLE LeftMenuConfig ADD  topmenuname varchar2(200) 
/
ALTER TABLE LeftMenuConfig ADD  topname_e varchar2(200) 
/
ALTER TABLE LeftMenuConfig ADD  topname_t varchar2(200) 
/

ALTER TABLE MainMenuInfo ADD  topmenuname varchar2(200) 
/
ALTER TABLE MainMenuInfo ADD  topname_e varchar2(200) 
/
ALTER TABLE MainMenuInfo ADD  topname_t varchar2(200) 
/

ALTER TABLE MainMenuConfig ADD  topmenuname varchar2(200) 
/
ALTER TABLE MainMenuConfig ADD  topname_e varchar2(200) 
/
ALTER TABLE MainMenuConfig ADD  topname_t varchar2(200) 
/


create table menushareinfo(
   id int ,
   resourceid int,
   resourcetype int,
   infoid int,
   menutype varchar2(200),
   sharetype varchar2(200),
   sharevalue varchar2(200),
   seclevel varchar2(200),
   rolelevel varchar2(200)
)
/
create sequence menushareinfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger menushareinfo_id_Tri
before insert on menushareinfo
for each row
begin
select menushareinfo_id.nextval into :new.id from dual;
end;
/

create table UserCommonMenu(
   id int,
   userid int,
   menuid int
)
/
create sequence UserCommonMenu_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger UserCommonMenu_id_Tri
before insert on UserCommonMenu
for each row
begin
select UserCommonMenu_id.nextval into :new.id from dual;
end;
/



ALTER TABLE SystemTemplate ADD  ecology7themeid varchar2(200) 
/


create table AppKeyPath(
   id int,
   appid int,
   keypath varchar2(200)
)
/
create sequence AppKeyPath_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger AppKeyPath_id_Tri
before insert on AppKeyPath
for each row
begin
select AppKeyPath_id.nextval into :new.id from dual;
end;
/

INSERT INTO AppKeyPath(appid,keypath) VALUES('3','HrmResourceSearch.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('502','MeetingCalView.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('504','WorkPlan.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1329','SmsMessageEdit.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1329','sendWechat.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('5','ViewCustomer.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1381','MailInboxList.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('359','ViewCoWork.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1047','myBlog.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestView.jsp?offical=1&officalType=1')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestType.jsp?needPopupNewPage=true&offical=1&officalType=1')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/docs/search/DocMain.jsp?offical=1&officalType=1&urlType=-99')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestHandled.jsp?offical=1&officalType=1')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestView.jsp?offical=1&officalType=2')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestType.jsp?needPopupNewPage=true&offical=1&officalType=2')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/docs/search/DocMain.jsp?offical=1&officalType=2&urlType=-98')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/docs/tabs/DocCommonTab.jsp?_fromURL=70')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/docs/tabs/DocCommonTab.jsp?_fromURL=71')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('10086','VotingPoll.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('10086','VotingPollResult.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('8','CptCapital.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('6','ViewProject.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('364','CarUseInfo.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewFnaWipeApply.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewFnaPayApply.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewFnaBudgetChgApply.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewFnaLoanApply.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewBillExpense.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1336','showSynergyFrame.jsp')
/
INSERT INTO AppKeyPath(appid,keypath) VALUES('1255','CompanyInfoList.jsp')
/

create table AppUseInfo(
   id int,
   appid int,
   userid varchar2(200),
   usedate varchar2(200),
   usecount int
)
/
create sequence AppUseInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger AppUseInfo_id_Tri
before insert on AppUseInfo
for each row
begin
select AppUseInfo_id.nextval into :new.id from dual;
end;
/

create table PortalLogInfo(
   id int,
   userid varchar2(200),
   type varchar2(200),
   item varchar2(200),
   sql varchar2(2000),
   description varchar2(2000),
   opdate varchar2(200),
   optime varchar2(200),
   ip varchar2(200)
)
/
create sequence PortalLogInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger PortalLogInfo_id_Tri
before insert on PortalLogInfo
for each row
begin
select PortalLogInfo_id.nextval into :new.id from dual;
end;
/