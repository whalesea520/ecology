INSERT INTO hpBaseElement (id, elementtype, title, logo, perpage, linkmode, moreurl, elementdesc, isuse, titleEN, titleTHK, loginview)
VALUES ('imgSlide', '2', '多图元素', 'resource/image/video_wev8.gif', -1, '-1', '', '多图元素描述', '1', 'Slide Element ', '多圖元素', '2')
GO

INSERT INTO hpBaseElement (id, elementtype, title, logo, perpage, linkmode, moreurl, elementdesc, isuse, titleEN, titleTHK, loginview)
VALUES ('newNotice', '2', '公告元素', 'resource/image/notice_wev8.gif', 3, '-1', 'listTab.jsp', '公告元素描述', '1', 'Notice Element ', '公告元素', '2')
GO

CREATE TABLE hpElement_slidesetting (
	id INT IDENTITY PRIMARY KEY,
	eleid INT,
	displaydesc CHAR,
	imgsrc VARCHAR(1000),
	imgdesc VARCHAR(1000)
)
go

create table hpElement_notice(
    id int identity primary key,
    title varchar(1000),
    content text,
    imgsrc varchar(1000),
    creator int, 
    creatortype char(1), 
    createdate varchar(10), 
    createtime varchar(8), 
    lastupdatedate varchar(10), 
    lastupdatetime varchar(8)
)
go
