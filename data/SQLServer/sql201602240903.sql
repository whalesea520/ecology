CREATE TABLE cpt_barcodesettings(
id int IDENTITY (1, 1) not null,
subcompanyid int,
departmentid int,
userid int,
isopen char(1),
isopen2 char(1),
barType varchar(200) default 'CODE128',
barType2 varchar(200) default 'QR_CODE',
code varchar(200),
width varchar(200),
width2 varchar(200) default '200',
height varchar(200),
height2 varchar(200) default '200',
st varchar(200) default 'y',
st2 varchar(200) default 'y',
textFont varchar(200) default 'Arial|PLAIN|11',
textFont2 varchar(200) default 'js/tabs/images/nav/mnav6_wev8.png',
content2type varchar(200) default 'link',
content2 varchar(4000) default '',
link2 varchar(1000) default '/cpt/app/cptsummary.jsp',
fontColor varchar(200) default 'BLACK',
barColor varchar(200) default 'BLACK',
backColor varchar(200) default 'WHITE',
rotate varchar(200) default '0',
barHeightCM varchar(200) default '1',
x varchar(200) default '0.03',
n varchar(200) default '2',
leftMarginCM varchar(200) default '0.3',
topMarginCM varchar(200) default '0.2',
checkCharacter varchar(200) default 'y',
checkCharacterInText varchar(200) default 'y',
Code128Set varchar(200) default '0',
UPCESytem varchar(200) default '0'
)
GO

SET IDENTITY_INSERT cpt_barcodesettings ON
insert into cpt_barcodesettings(id) values(-1);
SET IDENTITY_INSERT cpt_barcodesettings OFF
GO
CREATE TABLE CPT_PRINT_Mould(
	id int  NOT NULL,
	mouldname varchar(1000) NULL,
	mouldtext text NULL,
	issysdefault char(1) NULL,
	isuserdefault char(1) NULL,
	ismaildefault char(1) NULL,
	mouldType int NULL,
	mouldPath varchar(1000) NULL,
	lastModTime varchar(1000) NULL,
	subcompanyid int NULL
)
GO

INSERT INTO CPT_PRINT_Mould(id,issysdefault,mouldType,subcompanyid) VALUES(-1,1,1,-1)
GO
update CPT_PRINT_Mould set  mouldtext='<table border=&quot;1&quot; cellspacing=&quot;0&quot; cellpadding=&quot;0&quot; style=&quot;border: none;border-collapse: collapse&quot;><tbody><tr style=&quot;;height:51px&quot; class=&quot;firstRow&quot;><td width=&quot;389&quot; colspan=&quot;2&quot; valign=&quot;top&quot; style=&quot;width: 311px;border: 2px solid rgb(68, 114, 196);padding: 0 7px;height: 51px&quot;><p style=&quot;text-align:center&quot;><strong><span style=&quot;font-size:20px;font-family:微软雅黑,sans-serif;color:#2F5597&quot;>上海泛微网络科技股份有限公司</span></strong></p></td></tr><tr style=&quot;;height:27px&quot;><td width=&quot;105&quot; style=&quot;width: 84px;border-style: none solid solid;border-left-color: rgb(68, 114, 196);border-left-width: 2px;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 1px;padding: 0 7px;height: 27px&quot;><p><strong><span style=&quot;font-size:16px;font-family:宋体;color:#2F5597&quot;>编号</span></strong></p></td><td width=&quot;284&quot; style=&quot;width: 150px;border-style: none solid solid none;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 2px;padding: 0 7px;height: 27px&quot;><p><span style=&quot;font-size:16px;color:#2F5597&quot;>#[mark]</span></p></td></tr><tr style=&quot;;height:28px&quot;><td width=&quot;105&quot; style=&quot;width: 84px;border-style: none solid solid;border-left-color: rgb(68, 114, 196);border-left-width: 2px;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 1px;padding: 0 7px;height: 28px&quot;><p><strong><span style=&quot;font-size:16px;font-family:宋体;color:#2F5597&quot;>名称</span></strong></p></td><td width=&quot;284&quot; style=&quot;width: 150px;border-style: none solid solid none;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 2px;padding: 0 7px;height: 28px&quot;><p><span style=&quot;font-size:16px;color:#2F5597&quot;>#[name]</span></p></td></tr><tr style=&quot;;height:28px&quot;><td width=&quot;105&quot; style=&quot;width: 84px;border-style: none solid solid;border-left-color: rgb(68, 114, 196);border-left-width: 2px;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 1px;padding: 0 7px;height: 28px&quot;><p><strong><span style=&quot;font-size:16px;font-family:宋体;color:#2F5597&quot;>规格型号</span></strong></p></td><td width=&quot;284&quot; style=&quot;width: 150px;border-style: none solid solid none;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 2px;padding: 0 7px;height: 28px&quot;><p><span style=&quot;font-size:16px;color:#2F5597&quot;>#[capitalspec]</span></p></td></tr><tr style=&quot;;height:28px&quot;><td width=&quot;105&quot; style=&quot;width: 84px;border-style: none solid solid;border-left-color: rgb(68, 114, 196);border-left-width: 2px;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 1px;padding: 0 7px;height: 28px&quot;><p><strong><span style=&quot;font-size:16px;font-family:宋体;color:#2F5597&quot;>价格</span></strong></p></td><td width=&quot;284&quot; style=&quot;width: 150px;border-style: none solid solid none;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 2px;padding: 0 7px;height: 28px&quot;><p><span style=&quot;font-size:16px;color:#2F5597&quot;>#[startprice]</span></p></td></tr><tr style=&quot;;height:28px&quot;><td width=&quot;105&quot; style=&quot;width: 84px;border-style: none solid solid;border-left-color: rgb(68, 114, 196);border-left-width: 2px;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 1px;padding: 0 7px;height: 28px&quot;><p><strong><span style=&quot;font-size:16px;font-family:宋体;color:#2F5597&quot;>购置日期</span></strong></p></td><td width=&quot;284&quot; style=&quot;width: 150px;border-style: none solid solid none;border-bottom-color: rgb(68, 114, 196);border-bottom-width: 1px;border-right-color: rgb(68, 114, 196);border-right-width: 2px;padding: 0 7px;height: 28px&quot;><p><span style=&quot;font-size:16px;color:#2F5597&quot;>#[selectdate]</span></p></td></tr><tr style=&quot;;height:57px&quot;><td width=&quot;389&quot; colspan=&quot;2&quot; style=&quot;width: 311px;border-right-color: rgb(68, 114, 196);border-bottom-color: rgb(68, 114, 196);border-left-color: rgb(68, 114, 196);border-right-width: 2px;border-bottom-width: 2px;border-left-width: 2px;border-style: none solid solid;padding: 0 7px;height: 57px&quot;><p style=&quot;text-align:center&quot;><strong><span style=&quot;font-size:29px;font-family:宋体;color:#2F5597&quot;>#[1d-barcode]</span></strong></p></td></tr></tbody></table><p><br/></p>'
where id=-1
GO
CREATE TABLE CPT_PRINT_SET(
	id int  NOT NULL,
	col int NULL,
	row1 int NULL,
	forcepage int null,
	issysdefault char(1) NULL,
	isuserdefault char(1) NULL,
	ismaildefault char(1) NULL,
	mouldType int NULL,
	mouldPath varchar(1000) NULL,
	lastModTime varchar(1000) NULL,
	subcompanyid int NULL
)
GO

INSERT INTO CPT_PRINT_SET(id,issysdefault,mouldType,subcompanyid,col,row1,forcepage) VALUES(-1,1,1,-1,2,2,1)
GO