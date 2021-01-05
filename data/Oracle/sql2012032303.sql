alter table Prj_ProjectInfo add (relationxmlremark varchar(4000))
/
update Prj_ProjectInfo set relationxmlremark=relationxml 
/
alter table Prj_ProjectInfo drop column relationxml
/
alter table Prj_ProjectInfo add (relationxml long)
/
update Prj_ProjectInfo set relationxml=relationxmlremark 
/
alter table Prj_ProjectInfo drop column relationxmlremark
/
alter table Prj_Template add (relationxmlremark varchar(4000))
/
update Prj_Template set relationxmlremark=relationxml 
/
alter table Prj_Template drop column relationxml
/
alter table Prj_Template add (relationxml long)
/
update Prj_Template set relationxml=relationxmlremark 
/
alter table Prj_Template drop column relationxmlremark
/