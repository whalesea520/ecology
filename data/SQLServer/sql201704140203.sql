DELETE FROM Social_Pc_ClientSettings where keytitle = 'maxWithdrawTime'
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, fromtype) values('maxWithdrawTime', '3', '1')
GO