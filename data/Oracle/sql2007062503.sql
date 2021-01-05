alter table DocTreeDocField add  treeDocFieldDesc varchar2(500)
/

alter table DocTreeDocField add  mangerids varchar2(500)
/


create table DocDummyDetail(
	id integer PRIMARY KEY NOT NULL,
	catelogid varchar2(10) not null,
	docid integer not null,
	importdate char(10) null,
        importtime char(10) null,
        publicdate char(10) null,
        publictime char(10) null,
        status char(1) default 0 /*0:未发布 1:发布*/
)
/

CREATE SEQUENCE DocDummyDetail_Id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER DocDummyDetail_Id_Trigger
	before insert on DocDummyDetail
	for each row
	begin
	select DocDummyDetail_Id.nextval into :new.id from dual;
	end ;
/

create index Ddd_cid on DocDummyDetail(catelogid)
/

create index Ddd_did on DocDummyDetail(docid)
/


create index Ddd_cd on DocDummyDetail(catelogid ,docid)
/


create index Ddd_idt on DocDummyDetail(importdate desc,importtime desc)
/



delete workflow_browserurl where labelid=19485 and tablename='DocTreeDocField'
/

alter table docseccategory  add  defaultDummyCata varchar2(300)
/

update DocSecCategoryDocProperty set viewindex = viewindex + 1 where viewindex >= 24
/

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
/

