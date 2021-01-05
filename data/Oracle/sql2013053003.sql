create table fontinfo(
       id integer,
       f_name varchar(50),
       f_desc varchar(50)
)
/
create sequence sq_fontinfo
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger tr_fontinfo
before insert on fontinfo
for each row
begin
select sq_fontinfo.nextval into :new.id from dual;
end;
/

insert into fontinfo(f_name,f_desc)values('宋体','宋体')
/
insert into fontinfo(f_name,f_desc)values('黑体','黑体')
/
insert into fontinfo(f_name,f_desc)values('Verdana','Verdana')
/
insert into fontinfo(f_name,f_desc)values('华文行楷','华文行楷')
/
insert into fontinfo(f_name,f_desc)values('华文彩云','华文彩云')
/

insert into fontinfo (f_name,f_desc) values('方正舒体','方正舒体')
/
insert into fontinfo (f_name,f_desc) values('方正姚体','方正姚体')
/
insert into fontinfo (f_name,f_desc) values('华文仿宋','华文仿宋')
/
insert into fontinfo (f_name,f_desc) values('华文楷体','华文楷体')
/
insert into fontinfo (f_name,f_desc) values('华文琥珀','华文琥珀')
/
insert into fontinfo (f_name,f_desc) values('华文隶书','华文隶书')
/
insert into fontinfo (f_name,f_desc) values('华文中宋','华文中宋')
/
insert into fontinfo (f_name,f_desc) values('微软雅黑','微软雅黑')
/
insert into fontinfo (f_name,f_desc) values('新宋体','新宋体')
/
insert into fontinfo (f_name,f_desc) values('仿宋','仿宋')
/
insert into fontinfo (f_name,f_desc) values('楷体','楷体')
/
insert into fontinfo (f_name,f_desc) values('隶书','隶书')
/
insert into fontinfo (f_name,f_desc) values('幼圆','幼圆')
/
insert into fontinfo (f_name,f_desc) values('serif','serif')
/
insert into fontinfo (f_name,f_desc) values('sans-serif','sans-serif')
/
insert into fontinfo (f_name,f_desc) values('cursive','cursive')
/
insert into fontinfo (f_name,f_desc) values('fantasy','fantasy')
/
insert into fontinfo (f_name,f_desc) values('monospace','monospace')
/
insert into fontinfo (f_name,f_desc) values('inherit','inherit')
/