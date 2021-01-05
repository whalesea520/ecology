
delete from mainmenuinfo where id>=348 and id<=351
go

delete from mainmenuconfig where infoid>=348 and infoid<=351
go





EXECUTE MMInfo_Insert 348,16522,'','/hrm/country/HrmCountries.jsp','mainFrame',11,1,0,0,'',0,'',0,'','',0,'','',9
GO


EXECUTE MMInfo_Insert 349,16523,'','/hrm/province/HrmProvince.jsp','mainFrame',11,1,3,0,'',0,'',0,'','',0,'','',9
GO


EXECUTE MMInfo_Insert 350,16524,'','/hrm/city/HrmCity.jsp','mainFrame',11,1,4,0,'',0,'',0,'','',0,'','',9
GO


EXECUTE MMInfo_Insert 351,16525,'','/fna/maintenance/FnaCurrencies.jsp','mainFrame',11,1,5,0,'',0,'',0,'','',0,'','',9
GO
