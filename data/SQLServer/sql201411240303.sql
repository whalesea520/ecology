CREATE TABLE wechat_news (
[id] int NOT NULL IDENTITY(1,1) PRIMARY KEY ,
[name] varchar(200)   NULL ,
[createrid] int NULL ,
[createtime] varchar(19)   NULL ,
[updatetime] varchar(19)   NULL ,
[newstype] int NULL ,
[isdel] char(1)  NULL DEFAULT ((0)) 
)
go
CREATE TABLE wechat_news_material (
[id] int NOT NULL IDENTITY(1,1) PRIMARY KEY ,
[title] varchar(500)   NULL ,
[summary] varchar(500)   NULL ,
[content] text   NULL ,
[url] varchar(500)   NULL ,
[picUrl] varchar(500)   NULL ,
[userid] int NULL ,
[dsporder] int NULL ,
[newsId] int NULL 
)
GO
alter table wechat_msg add isNews int DEFAULT 0
go
update wechat_msg set isNews=0
go