create table coremailsetting
(
  isuse               int,
  systemaddress       varchar(200),
  orgid               varchar(200),
  providerid          varchar(200),
  domain              varchar(200),
  issync              int,
  bindfield           varchar(500)
)
GO



create table coremaillog
(
  id                  int identity(1,1) not null,
  datatype            int,
  operatedata         varchar(1000),
  operatetype         int,
  operateresult       int,
  operateremark       varchar(2000),
  logdate             varchar(50),
  logtime             varchar(50)
)
GO


insert into hpBaseElement(id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleEN,titleTHK,loginview,isbase) 
values('CoreMail','2','CoreMail” œ‰','resource/image/16_wev8.gif',-1,'-1','','CoreMail” œ‰','1','CoreMail','CoreMail‡]œ‰','0','1')
GO