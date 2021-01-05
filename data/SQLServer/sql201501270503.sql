create table ldapsetsubparam (
id INT NOT NULL IDENTITY(1,1),
subattr VARCHAR(100) NULL,
ldapsubattr VARCHAR(100) NULL
)
GO
CREATE TABLE ldapsetdepparam (
id INT NOT NULL IDENTITY(1,1),
depattr VARCHAR(100) NULL,
ldapdepattr VARCHAR(100) NULL
)
GO
CREATE TABLE ldapsetoutype (
id INT NOT NULL IDENTITY(1,1),
ouattr VARCHAR(100) NULL,
subcompany VARCHAR(100) NULL,
department VARCHAR(100) NULL
)
GO
CREATE TABLE HrmResourceTemp (
textfield13 varchar(500) NULL ,
id int IDENTITY(1,1) NOT NULL ,
loginid varchar(60) NULL ,
password varchar(100) NULL ,
lastname varchar(60) NULL ,
sex char(1) NULL ,
birthday char(10) NULL ,
nationality int NULL ,
systemlanguage int NULL ,
maritalstatus char(1) NULL ,
telephone varchar(60) NULL ,
mobile varchar(60) NULL ,
mobilecall varchar(60) NULL ,
email varchar(60) NULL ,
locationid int NULL ,
workroom varchar(60) NULL ,
homeaddress varchar(100) NULL ,
resourcetype char(1) NULL ,
startdate char(10) NULL ,
enddate char(10) NULL ,
jobtitle int NULL ,
jobactivitydesc varchar(200) NULL ,
joblevel tinyint NULL ,
seclevel tinyint NULL ,
departmentid int NULL ,
subcompanyid1 int NULL ,
costcenterid int NULL ,
managerid int NULL ,
assistantid int NULL ,
bankid1 int NULL ,
accountid1 varchar(100) NULL ,
resourceimageid int NULL ,
createrid int NULL ,
createdate char(10) NULL ,
lastmodid int NULL ,
lastmoddate char(10) NULL ,
lastlogindate char(10) NULL ,
datefield1 varchar(10) NULL ,
datefield2 varchar(10) NULL ,
datefield3 varchar(10) NULL ,
datefield4 varchar(10) NULL ,
datefield5 varchar(10) NULL ,
numberfield1 float(53) NULL ,
numberfield2 float(53) NULL ,
numberfield3 float(53) NULL ,
numberfield4 float(53) NULL ,
numberfield5 float(53) NULL ,
textfield1 varchar(100) NULL ,
textfield2 varchar(100) NULL ,
textfield3 varchar(100) NULL ,
textfield4 varchar(100) NULL ,
textfield5 varchar(100) NULL ,
tinyintfield1 tinyint NULL ,
tinyintfield2 tinyint NULL ,
tinyintfield3 tinyint NULL ,
tinyintfield4 tinyint NULL ,
tinyintfield5 tinyint NULL ,
certificatenum varchar(60) NULL ,
nativeplace varchar(100) NULL ,
educationlevel int NULL ,
bememberdate char(10) NULL ,
bepartydate char(10) NULL ,
workcode varchar(60) NULL ,
regresidentplace varchar(200) NULL ,
healthinfo char(1) NULL ,
residentplace varchar(200) NULL ,
policy varchar(30) NULL ,
degree varchar(30) NULL ,
height varchar(10) NULL ,
usekind int NULL ,
jobcall int NULL ,
accumfundaccount varchar(30) NULL ,
birthplace varchar(60) NULL ,
folk varchar(30) NULL ,
residentphone varchar(60) NULL ,
residentpostcode varchar(60) NULL ,
extphone varchar(50) NULL ,
managerstr varchar(500) NULL ,
status int NULL ,
fax varchar(60) NULL ,
islabouunion char(1) NULL ,
weight int NULL ,
tempresidentnumber varchar(60) NULL ,
probationenddate char(10) NULL ,
countryid int NULL DEFAULT ((1)) ,
passwdchgdate char(10) NULL ,
needusb int NULL ,
serial varchar(32) NULL ,
account varchar(60) NULL ,
lloginid varchar(60) NULL ,
needdynapass int NULL ,
dsporder float(53) NULL ,
passwordstate int NULL ,
accounttype int NULL ,
belongto int NULL ,
dactylogram varchar(4000) NULL ,
assistantdactylogram varchar(4000) NULL ,
passwordlock int NULL ,
sumpasswordwrong int NULL ,
oldpassword1 varchar(100) NULL ,
oldpassword2 varchar(100) NULL ,
msgStyle varchar(20) NULL ,
messagerurl varchar(100) NULL ,
pinyinlastname varchar(50) NULL ,
tokenkey varchar(100) NULL ,
userUsbType varchar(10) NULL ,
adsjgs varchar(500) NULL ,
adgs varchar(500) NULL ,
adbm varchar(500) NULL ,
outkey varchar(100) NULL ,
maildeldate varchar(10) NULL ,
mobileshowtype int NULL ,
usbstate int NULL ,
totalSpace float(53) NULL DEFAULT ((100)) ,
occupySpace float(53) NULL DEFAULT ((0)) ,
ecology_pinyin_search varchar(300) NULL ,
isADAccount char(1) NULL 
)
GO

