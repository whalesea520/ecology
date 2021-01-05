call MMConfig_U_ByInfoInsert (11,0)
/
call MMInfo_Insert (492,16484,'基础设置','','mainFrame',11,1,0,0,'',0,'',0,'','',0,'','',9)
/


delete from mainmenuinfo where id>=348 and id<=351
/

delete from mainmenuconfig where infoid>=348 and infoid<=351
/

call MMConfig_U_ByInfoInsert (492,1)
/
call MMInfo_Insert (348,16522,'','/hrm/country/HrmCountries.jsp','mainFrame',492,2,1,0,'',0,'',0,'','',0,'','',9)
/

call MMConfig_U_ByInfoInsert (492,2)
/
call MMInfo_Insert (349,16523,'','/hrm/province/HrmProvince.jsp','mainFrame',492,2,2,0,'',0,'',0,'','',0,'','',9)
/


call  MMConfig_U_ByInfoInsert (492,3)
/
call  MMInfo_Insert (350,16524,'','/hrm/city/HrmCity.jsp','mainFrame',492,2,3,0,'',0,'',0,'','',0,'','',9)
/

call  MMConfig_U_ByInfoInsert (492,4)
/
call  MMInfo_Insert (351,16525,'','/fna/maintenance/FnaCurrencies.jsp','mainFrame',492,2,4,0,'',0,'',0,'','',0,'','',9)
/





INSERT INTO HtmlLabelIndex values(19174,'权限管理') 
/
INSERT INTO HtmlLabelInfo VALUES(19174,'权限管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19174,'Rights Manager',8) 
/
INSERT INTO HtmlLabelIndex values(19175,'会议设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19175,'会议设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19175,'Meeting Settings',8) 
/

call MMConfig_U_ByInfoInsert (11,1)
/
call MMInfo_Insert (500,19174,'权限管理','','mainFrame',11,1,1,0,'',0,'',0,'','',0,'','',9)
/

update mainmenuinfo set defaultparentid=500 where id=352 or id=353 or id=354 or id=383 or id=414 or id=472
/
update mainmenuinfo set defaultlevel=2 where id=352 or id=353 or id=354 or id=383 or id=414 or id=472
/
update mainmenuinfo set defaultparentid=11 where id=500
/


call MMConfig_U_ByInfoInsert (11,8)
/
call MMInfo_Insert (501,17632,'参数设置','','mainFrame',11,1,8,0,'',0,'',0,'','',0,'','',9)
/

update mainmenuinfo set defaultparentid=501 where id=428 or id=429 or id=355 or id=478
/
update mainmenuinfo set defaultlevel=2 where id=428 or id=429 or id=355 or id=478
/
update mainmenuinfo set defaultparentid=11 where id=501
/

call MMConfig_U_ByInfoInsert (11,9)
/
call MMInfo_Insert (502,19175,'会议设置','','mainFrame',11,1,9,0,'',0,'',0,'','',0,'','',9)
/
update mainmenuinfo set defaultparentid=502 where id=356 or id=357 or id=358
/
update mainmenuinfo set defaultlevel=2 where id=356 or id=357 or id=358
/
update mainmenuinfo set defaultparentid=11 where id=502
/
call MMConfig_U_ByInfoInsert (11,10)
/
call MMInfo_Insert (503,15804,'系统信息','','mainFrame',11,1,10,0,'',0,'',0,'','',0,'','',9)
/
update mainmenuinfo set defaultparentid=503 where id=368 or id=426
/
update mainmenuinfo set defaultlevel=2 where id=368 or id=426
/
update mainmenuinfo set defaultparentid=11 where id=503
/


update mainmenuconfig set parentid=503 where infoid=368 or infoid=426
/
update mainmenuconfig set parentid=502 where infoid=356 or infoid=357 or infoid=358
/
update mainmenuconfig set parentid=501 where infoid=428 or infoid=429 or infoid=355 or infoid=478
/
update mainmenuconfig set parentid=500 where infoid=352 or infoid=353 or infoid=354 or infoid=383 or infoid=414 or infoid=472
/
