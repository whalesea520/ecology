update Social_Pc_UrlIcons set ifshowon = '0' where id in(3,4,5,7,8,10,11,12,13,14,15)
GO

update Social_Pc_ClientSettings set keyvalue = '1' where keytitle in ('ifForbitCheckInOut','ifDisableMenuItem','ifForbitFolderTransfer','ifForbitSSO','ifForbitAccountSwitch')
GO