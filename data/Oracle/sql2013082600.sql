delete from SystemRightDetail where rightid =1535
/
delete from SystemRightsLanguage where id =1535
/
delete from SystemRights where id =1535
/
insert into SystemRights (id,rightdesc,righttype) values (1535,'���������ĵ�����','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,8,'Document Sharing','Document Sharing') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,7,'���������ĵ�����','���������ĵ�����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,9,'�����{���ęn����','�����{���ęn����') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42782,'���������ĵ�����','DocShareRight:all',1535) 
/