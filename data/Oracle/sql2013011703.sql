alter table sap_service add loadDate integer
/
update sap_service set loadDate=0
/  
update int_dataInter set dataname='WEBSERVICE数据交互',datadesc='异构系统间采用同一标准，通过发布、调用WEBSERVICE来实现系统间的数据交互。' where id=2 
/