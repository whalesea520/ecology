alter table hpBaseElement alter column linkmode char(2)
GO
alter table hpBaseElement add isuse char(2)default '1' with values
GO
alter table hpBaseElement add titleEN varchar(500)
GO
alter table hpBaseElement add titleTHK varchar(500)
GO
alter table hpBaseElement add loginview char(1) default '0' with values
GO

INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( '20','2','新回复文档','New Reply Docs ','新回覆文檔','resource/image/Nrd.gif',-1,'-1','','查看回复自己创建的文档的回复文档')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'audio','2','音频元素','Audio ','音頻元素','resource/image/audio.gif',-1,'-1','','音频元素描述')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'blogStatus','1','微博动态','Microblogging ','微博動態','resource/image/slide.gif',-1,'-1','','工作微博的提醒')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'favourite','2','收藏元素','Collect ','收藏元素','resource/image/favourite.gif',-1,'2','','收藏元素')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'Flash','2','Flash元素','Flash ','Flash元素','resource/image/flash.gif',-1,'-1','','Flash元素描述')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'login','2','登录系统','Login ','登錄系統','resource/image/login.gif',-1,'2','','登录系统')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'menu','2','自定义菜单','Custom Menu ','自定義菜單','resource/image/menu.gif',-1,'1','','自定义菜单元素')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'news','2','公司新闻','News ','公司新聞','resource/image/news.gif',5,'2','','公司新闻')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'notice','2','公告栏元素','Announcement ','公告欄元素','resource/image/notice.gif',-1,'-1','','公告栏元素描述')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'picture','2','图片元素','Picture ','圖片元素','resource/image/picture.gif',-1,'-1','','图片元素描述')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'reportForm','2','图表元素','Report Form ','圖表元素','resource/image/reportForm.gif',-1,'-1','','图表元素')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'searchengine','2','搜索元素','Search ','搜索元素','resource/image/search.gif',-1,'-1','','搜索元素')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'Slide','1','幻灯片','Slideshow ','幻燈片','resource/image/slide.gif',-1,'-1','','幻灯片')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'video','2','视频元素','Video ','視頻元素','resource/image/video.gif',-1,'-1','','视频元素描述')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'weather','2','天气元素','Weather ','天氣元素','resource/image/weather.gif',-1,'-1','','天气元素')
GO
INSERT INTO hpBaseElement( id,elementtype,title,titleEN,titleTHK,logo,perpage,linkmode,moreurl,elementdesc) 
VALUES ( 'scratchpad','2','便签元素','Notes ','便簽元素','resource/image/scratchpad.gif',-1,'-1','','随时记录你的idea')
GO
UPDATE hpBaseElement set titleEN='RSS Reader ',titleTHK='RSS閱讀器' where id='1'
GO
UPDATE hpBaseElement set titleEN='Unread Docs ',titleTHK='未讀文檔' where id='6'
GO
UPDATE hpBaseElement set titleEN='Docs Center ',titleTHK='文檔中心' where id='7'
GO
UPDATE hpBaseElement set titleEN='Workflow Center ',titleTHK='流程中心' where id='8'
GO
UPDATE hpBaseElement set titleEN='Message reminding ',titleTHK='消息提醒' where id='9'
GO
UPDATE hpBaseElement set titleEN='My Projects ',titleTHK='我的項目' where id='10'
GO
UPDATE hpBaseElement set titleEN='New Customers ',titleTHK='最新客戶' where id='11'
GO
UPDATE hpBaseElement set titleEN='Last Meeting ',titleTHK='最新會議' where id='12'
GO
UPDATE hpBaseElement set titleEN='Unread Cooperation ',titleTHK='未讀協作' where id='13'
GO
UPDATE hpBaseElement set titleEN='Month Target ',titleTHK='當月目標' where id='14'
GO
UPDATE hpBaseElement set titleEN='Day Plan ',titleTHK='當日計畫' where id='15'
GO
UPDATE hpBaseElement set titleEN='My E-mail ',titleTHK='我的郵件' where id='16'
GO
UPDATE hpBaseElement set titleEN='More news ',titleTHK='多新聞中心' where id='17'
GO
UPDATE hpBaseElement set titleEN='Periodical Center ',titleTHK='期刊中心' where id='18'
GO
UPDATE hpBaseElement set titleEN='Stock ',titleTHK='股票元素' where id='19'
GO
UPDATE hpBaseElement set titleEN='en',titleTHK='新反饋流程' where id='21'
GO
UPDATE hpBaseElement set titleEN='Document Content ',titleTHK='文檔內容' where id='25'
GO
UPDATE hpBaseElement set titleEN='Custom Pages ',titleTHK='自定義頁面' where id='29'
GO
UPDATE hpBaseElement set titleEN='Scheduled Tasks ',titleTHK='計畫任務' where id='32'
GO
UPDATE hpBaseElement set titleEN='en',titleTHK='圖表元素' where id='33'
GO
UPDATE hpBaseElement set titleEN='Subscribe Knowledg ',titleTHK='知識訂閱' where id='34'
GO
UPDATE hpBaseElement set loginview='1' where id in('login','news')
GO
UPDATE hpBaseElement set loginview='2' where id in('19','29','audio','Flash','menu','notic','picture','reportForm','searchengine','Slide','video','weather')
GO
UPDATE hpBaseElement set loginview='4' where id in('20','21')
GO
UPDATE hpBaseElement set logo=REPLACE(logo,'/images/homepage/element/','resource/image/')
GO

alter table hpElement add isRemind varchar(200)default 'isnew' with values
GO
alter table hpElement add fromModule varchar(50)default 'Portal' with values
GO
alter table hpElement add isuse int default 1 with values
GO
alter table menucenter add menucreater varchar(5) default '1' with values
GO
alter table menucenter add menulastdate varchar(20) 
GO
alter table menucenter add menulasttime varchar(20)
GO
create table hpMenuStyle(
	styleid varchar(30),
	menustylename varchar(200),
	menustyledesc varchar(500),
	menustyletype varchar(20),
	menustylecreater int,
	menustylemodifyid varchar(8000),
	menustylelastdate varchar(12),
	menustylelasttime varchar(12),
	menustulecite varchar(30)
)
GO

alter table hpinfo add hplanuageid int default 7 with values
GO
alter table hpinfo add hpcreatorid int default 1 with values
GO
alter table hpinfo add hplastdate varchar(20) 
GO
alter table hpinfo add hplasttime varchar(20) 
GO

create table ImageLibrary(
	fileid int IDENTITY(1, 1)  PRIMARY KEY,
	filename varchar(200),
	filetype varchar(50),
	filesize varchar(50),
	filecreateid int,
	filelastdate varchar(12),
	filelasttime varchar(12),
	filedirid int,
	filedir varchar(200),
	fileThumbnailspath varchar(500),
	filerealpath varchar(500)
)
GO

create table ImageFolder( 
	dirid int IDENTITY(1, 1)  PRIMARY KEY,
	dirname varchar(200),
	dirtype varchar(10),
	dirparentid int,
	dirparentname varchar(10),
	dirfilecount int,
	dirfileids text,
	dircreateid int,
	dirlastdate varchar(12),
	dirlasttime varchar(12),
	dirrealpath varchar(500)
)
GO

UPDATE MainMenuInfo set labelid='32457',menuname='员工门户',defaultIndex=1 where id=808
GO
UPDATE mainmenuconfig set viewIndex=1 where infoId=808
GO

UPDATE MainMenuInfo set labelid='32459',menuname='登录前门户',defaultIndex=1 where id=809
GO
UPDATE mainmenuconfig set viewIndex=1 where infoId=809
GO

UPDATE MainMenuInfo set labelid='32464',menuname='门户布局库',defaultIndex=5,defaultParentId=1280,parentId=1280 where id=800
GO
UPDATE mainmenuconfig set viewIndex=5 where infoId=800
GO

UPDATE MainMenuInfo set labelid='32462',menuname='门户主题库',defaultIndex=1,defaultParentId=1280,parentId=1280 where id=810
GO
UPDATE mainmenuconfig set viewIndex=1 where infoId=810
GO

UPDATE MainMenuInfo set labelid='32129',menuname='门户菜单库',defaultIndex=2,defaultParentId=1280,parentId=1280 where id=805
GO
UPDATE mainmenuconfig set viewIndex=2 where infoId=805
GO

UPDATE MainMenuInfo set labelid='32126',menuname='菜单样式库',defaultIndex=3,defaultParentId=1280,parentId=1280,linkaddress='/page/maint/style/MenuStyleList.jsp' where id=798
GO
UPDATE mainmenuconfig set viewIndex=3 where infoId=798
GO

UPDATE MainMenuInfo set labelid='32466',menuname='元素样式库',defaultIndex=8,defaultParentId=1280,parentId=1280,linkaddress='/page/maint/style/ElementStyleList.jsp' where id=796
GO
UPDATE mainmenuconfig set viewIndex=8 where infoId=796
GO

UPDATE MainMenuInfo set labelid='23088',menuname='新闻模版库',defaultIndex=9,defaultParentId=1280,parentId=1280,linkaddress='/page/maint/template/news/NewsTemplateList.jsp' where id=801
GO
UPDATE mainmenuconfig set viewIndex=9 where infoId=801
GO

UPDATE MainMenuInfo set labelid='32463',menuname='门户页面库',defaultIndex=4,defaultParentId=1280,parentId=1280 where id=802
GO
UPDATE mainmenuconfig set viewIndex=4 where infoId=802
GO

UPDATE MainMenuInfo set labelid='24666',menuname='页面布局库',defaultIndex=6,defaultParentId=1280,parentId=1280,linkaddress='/page/maint/layout/LayoutList.jsp' where id=767
GO
UPDATE mainmenuconfig set viewIndex=6 where infoId=767
GO

UPDATE MainMenuInfo set labelid='32127',menuname='系统使用菜单',defaultIndex=1,defaultParentId=805,parentId=805,linkaddress='/page/maint/menu/SystemMenuMaint.jsp?type=left' where id=807
GO
UPDATE mainmenuconfig set viewIndex=1 where infoId=807
GO

UPDATE MainMenuInfo set labelid='32128',menuname='系统维护菜单',defaultIndex=2,defaultParentId=805,parentId=805,linkaddress='/page/maint/menu/SystemMenuMaint.jsp?type=top' where id=797
GO
UPDATE mainmenuconfig set viewIndex=2 where infoId=797
GO

UPDATE MainMenuInfo set labelid='18773',menuname='自定义菜单',defaultIndex=3,defaultParentId=805,parentId=805,linkaddress='/page/maint/menu/SystemMenuMaint.jsp?type=custom' where id=806
GO
UPDATE mainmenuconfig set viewIndex=3 where infoId=806
GO

UPDATE MainMenuInfo set defaultIndex=1,defaultParentId=802,parentId=802 where id=803
GO
UPDATE mainmenuconfig set viewIndex=1 where infoId=803
GO

UPDATE MainMenuInfo set defaultIndex=2,defaultParentId=802,parentId=802 where id=804
GO
UPDATE mainmenuconfig set viewIndex=2 where infoId=804
GO

UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=menuStyle' where id=798
GO
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=hpLayout' where id=767
GO
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=eStyle' where id=796
GO
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=pLayout' where id=800
GO
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=newsTemplate' where id=801
GO
UPDATE mainMenuInfo set linkAddress = '/homepage/maint/HomepageTabs.jsp?_fromURL=pElement' where id=1287
GO
UPDATE mainMenuInfo set linkAddress = '/portal/PortalTabs.jsp?_fromURL=ecology8' where id=810
GO

create table hpareaelement(
	id int identity(1,1) primary key,
	hpid int,
	eid int,
	ebaseid varchar(30),
	userid int,
	usertype int,
	module varchar(20),
	modelastdate varchar(12),
	modelasttime varchar(12),
	ordernum int 
)
GO


create table menushareinfo(
   id int IDENTITY (1, 1),
   resourceid int,
   resourcetype int,
   infoid int,
   menutype VARCHAR(200),
   sharetype VARCHAR(200),
   sharevalue VARCHAR(200),
   seclevel VARCHAR(200),
   rolelevel varchar(200)
)
GO

create table UserCommonMenu(
   id int IDENTITY (1, 1),
   userid int,
   menuid int
)
GO

ALTER TABLE LeftMenuInfo ADD  topmenuname varchar(200) 
GO
ALTER TABLE LeftMenuInfo ADD  topname_e varchar(200) 
GO
ALTER TABLE LeftMenuInfo ADD  topname_t varchar(200) 
GO
ALTER TABLE LeftMenuConfig ADD  topmenuname varchar(200) 
GO
ALTER TABLE LeftMenuConfig ADD  topname_e varchar(200) 
GO
ALTER TABLE LeftMenuConfig ADD  topname_t varchar(200) 
GO

ALTER TABLE MainMenuInfo ADD  topmenuname varchar(200) 
GO
ALTER TABLE MainMenuInfo ADD  topname_e varchar(200) 
GO
ALTER TABLE MainMenuInfo ADD  topname_t varchar(200) 
GO

ALTER TABLE MainMenuConfig ADD  topmenuname varchar(200) 
GO
ALTER TABLE MainMenuConfig ADD  topname_e varchar(200) 
GO
ALTER TABLE MainMenuConfig ADD  topname_t varchar(200) 
GO


ALTER TABLE SystemTemplate ADD  ecology7themeid varchar(200) 
GO


create table AppKeyPath(
   id int IDENTITY (1, 1),
   appid int,
   keypath varchar(200)
)
GO

INSERT INTO AppKeyPath(appid,keypath) VALUES('3','HrmResourceSearch.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('502','MeetingCalView.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('504','WorkPlan.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1329','SmsMessageEdit.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1329','sendWechat.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('5','ViewCustomer.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1381','MailInboxList.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('359','ViewCoWork.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1047','myBlog.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestView.jsp?offical=1&officalType=1')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestType.jsp?needPopupNewPage=true&offical=1&officalType=1')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/docs/search/DocMain.jsp?offical=1&officalType=1&urlType=-99')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestHandled.jsp?offical=1&officalType=1')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestView.jsp?offical=1&officalType=2')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/workflow/request/RequestType.jsp?needPopupNewPage=true&offical=1&officalType=2')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/docs/search/DocMain.jsp?offical=1&officalType=2&urlType=-98')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/docs/tabs/DocCommonTab.jsp?_fromURL=70')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1366','/docs/tabs/DocCommonTab.jsp?_fromURL=71')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('10086','VotingPoll.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('10086','VotingPollResult.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('8','CptCapital.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('6','ViewProject.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('364','CarUseInfo.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewFnaWipeApply.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewFnaPayApply.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewFnaBudgetChgApply.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewFnaLoanApply.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('7','ViewBillExpense.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1336','showSynergyFrame.jsp')
GO
INSERT INTO AppKeyPath(appid,keypath) VALUES('1255','CompanyInfoList.jsp')
GO


create table AppUseInfo(
   id int IDENTITY (1, 1),
   appid int,
   userid varchar(200),
   usedate varchar(200),
   usecount int
)
GO


create table PortalLogInfo(
   id int IDENTITY (1, 1),
   userid varchar(200),
   type varchar(200),
   item varchar(200),
   sql varchar(2000),
   description varchar(2000),
   opdate varchar(200),
   optime varchar(200),
   ip varchar(200)
)

UPDATE hpBaseElement SET logo ='resource/image/'+id+'.gif' WHERE  id<'9'
GO
UPDATE hpBaseElement SET logo = 'resource/image/blogStatus.gif' WHERE id= 'blogStatus'
GO
UPDATE hpBaseElement SET logo = 'resource/image/reportForm.gif' WHERE id= '33'
GO

ALTER TABLE shareinnerhp ADD  lastdate VARCHAR(200)
GO

ALTER TABLE shareinnerhp ADD  seclevelmax VARCHAR(200)
GO
UPDATE shareinnerhp SET seclevelmax = 100
GO

ALTER table hpMenuStyle add menustylecite varchar(200)
GO


CREATE TABLE  elementsetting(
	id INT IDENTITY(1, 1),    
	ebaseid varchar(200),  
	title varchar(200),   
	clname varchar(200),    
	fliedtype varchar(200),  
	defvalue  varchar(2000), 
	
)
GO

CREATE TABLE  elementsettingitem( 
	id INT IDENTITY(1, 1),    
	ebaseid varchar(200),
	tabid int,  
	itemname varchar(2000),    
	itemvalue varchar(2000),   
	
)
GO
create table ElementUseInfo(
   userid int,
   usertype int,
   layoutid int,
   eid int,
)

ALTER TABLE LeftMenuInfo ADD  menucss varchar(200)
GO


create table ColorStyleInfo(
   userid int,
   style varchar(200)
)
GO

UPDATE hrm_transfer_set SET link_address = '/page/maint/PageShareBrowser.jsp',class_name='weaver.page.PageShareManager' WHERE name LIKE '%门户%'
GO

