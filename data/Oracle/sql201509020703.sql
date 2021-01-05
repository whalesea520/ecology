INSERT INTO hpBaseElement (id, elementtype, title, logo, perpage, linkmode, moreurl, elementdesc, isuse, titleEN, titleTHK, loginview)
VALUES ('imgSlide', '2', '多图元素', 'resource/image/video_wev8.gif', -1, '-1', '', '多图元素描述', '1', 'Slide Element ', '多圖元素', '2')
/
INSERT INTO hpBaseElement (id, elementtype, title, logo, perpage, linkmode, moreurl, elementdesc, isuse, titleEN, titleTHK, loginview)
VALUES ('newNotice', '2', '公告元素', 'resource/image/notice_wev8.gif', 3, '-1', 'listTab.jsp', '公告元素描述', '1', 'Notice Element ', '公告元素', '2')
/

CREATE TABLE hpElement_slidesetting (
	id integer PRIMARY KEY,
	eleid integer,
	displaydesc CHAR,
	imgsrc VARCHAR(1000),
	imgdesc VARCHAR(1000)
)
/
create sequence SEQ_hpElement_slidesetting minvalue 1 nomaxvalue start with 1 increment by 1 nocycle nocache
/
CREATE OR REPLACE TRIGGER Tri_U_hpElement_slidesetting
BEFORE INSERT ON hpElement_slidesetting FOR EACH ROW WHEN (new.id is null) 
begin
	select SEQ_hpElement_slidesetting.nextval into:new.id from dual; 
end;
/
create table hpElement_notice(
    id integer primary key,
    title varchar(1000),
    content clob,
    imgsrc varchar(1000),
    creator integer, 
    creatortype char(1), 
    createdate varchar(10), 
    createtime varchar(8), 
    lastupdatedate varchar(10), 
    lastupdatetime varchar(8)
)
/

create sequence SEQ_hpElement_notice minvalue 1 nomaxvalue start with 1 increment by 1 nocycle nocache
/
CREATE OR REPLACE TRIGGER Tri_U_hpElement_notice
BEFORE INSERT ON hpElement_notice FOR EACH ROW WHEN (new.id is null) 
begin
	select SEQ_hpElement_notice.nextval into:new.id from dual; 
end;
/
