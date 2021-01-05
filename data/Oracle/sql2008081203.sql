CREATE TABLE DocHandwrittenColor ( 
    id integer NOT NULL ,
    nameCn varchar2(40) NULL,
    nameEn varchar2(40) NULL,
    hexRGB char(7) NULL
)  
/

insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(1,'红色','red','#FF0000')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(2,'蓝色','blue','#0000FF')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(3,'绿色','green','#008000')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(4,'紫罗兰','blueviolet','#8A2BE2')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(5,'粉红','pink','#FFC0CB')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(6,'深红(暗深红色)','crimson','#DC143C')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(7,'青绿','turquoise','#40E0D0')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(8,'鲜绿(酸橙色)','lime','#00FF00')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(9,'青色','cyan','#00FFFF')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(10,'深蓝(暗蓝色)','darkblue','#00008B')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(11,'深黄(暗黄褐色)','darkkhaki','#BDB76B')
/
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(12,'灰色-50%(暗灰色)','darkgray','#A9A9A9')
/


CREATE TABLE DocHandwrittenDetail ( 
    id integer NOT NULL ,
    docId integer NULL,
    docEditionId integer NULL,
    userName varchar2(40) NULL,
    colorId integer NULL
)  
/

create sequence DocHandwrittenDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger DocHandwrittenDetail_Tri
before insert on DocHandwrittenDetail
for each row
begin
select DocHandwrittenDetail_id.nextval into :new.id from dual;
end;
/