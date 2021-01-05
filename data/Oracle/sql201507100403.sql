alter table mode_pageexpand add showcondition2 varchar2(4000)
/
update mode_pageexpand set showcondition2=showcondition
/
alter table mode_pageexpand drop column showcondition
/
alter table mode_pageexpand rename column showcondition2 to showcondition
/

alter table mode_pageexpand add showconditioncn2 varchar2(4000)
/
update mode_pageexpand set showconditioncn2=showconditioncn
/
alter table mode_pageexpand drop column showconditioncn
/
alter table mode_pageexpand rename column showconditioncn2 to showconditioncn
/