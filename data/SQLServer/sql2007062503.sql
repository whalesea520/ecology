
alter table DocTreeDocField add  treeDocFieldDesc varchar(500)
Go

alter table DocTreeDocField add  mangerids varchar(500)
Go


INSERT INTO HtmlLabelInfo VALUES(19414,'The system doesn''t support 10 level of dummy catelog field!',8) 
GO


create table DocDummyDetail(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	catelogid varchar(10) not null,
	docid int not null,
	importdate char(10) null,
        importtime char(10) null,
        publicdate char(10) null,
        publictime char(10) null,
        status char(1) default 0 
)
GO

create index Ddd_cid on DocDummyDetail(catelogid)
go

create index Ddd_did on DocDummyDetail(docid)
go

create index Ddd_cd on DocDummyDetail(catelogid ,docid)
go

create index Ddd_idt on DocDummyDetail(importdate desc,importtime desc)
go

delete workflow_browserurl where labelid=19485 and tablename='DocTreeDocField'
GO

alter table docseccategory  add  defaultDummyCata varchar(300)
GO

update DocSecCategoryDocProperty set viewindex = viewindex + 1 where viewindex >= 24
GO

insert into DocSecCategoryDocProperty(secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput,isCustom,scope,scopeid,fieldid)
select 
a.id as secCategoryId,
24 as viewindex,
24 as type,
20482 as labelid,
1 as visible,
'' as customName,
1 as columnWidth,
0 as mustInput,
0 as isCustom,
'' as scope,
0 as scopeid,
0 as fieldid
from DocSecCategory a
where exists (select 1 from DocSecCategoryDocProperty where secCategoryId = a.id and type>0)
and not exists (select 1 from DocSecCategoryDocProperty where secCategoryId = a.id and type=24)
order by secCategoryId
GO

