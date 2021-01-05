Delete from LeftMenuInfo where id=606
/
update LeftMenuInfo set labelId=22825 where id=11
/

Delete from LeftMenuInfo where id=78
/
call LMConfig_U_ByInfoInsert (2,11,1)
/
call LMInfo_Insert (78,16444,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_78.png','/sms/SmsMessageEditTab.jsp',2,11,1,9 )
/

Delete from LeftMenuInfo where id=78
/
call LMConfig_U_ByInfoInsert (2,11,1)
/
call LMInfo_Insert (78,16444,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_78.png','/sms/SmsMessageEditTab.jsp',2,11,1,9 )
/

Delete from LeftMenuInfo where id=77
/
call LMConfig_U_ByInfoInsert (2,11,2)
/
call LMInfo_Insert (77,16443,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_77.png','/sms/ViewMessageTab.jsp',2,11,2,9) 
/

Delete from LeftMenuInfo where id=77
/
call LMConfig_U_ByInfoInsert (2,11,2)
/
call LMInfo_Insert (77,16443,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_77.png','/sms/ViewMessageTab.jsp',2,11,2,9 )
/

Delete from LeftMenuInfo where id=583
/
call LMConfig_U_ByInfoInsert (2,107,46)
/
call LMInfo_Insert (583,32638,NULL,NULL,2,107,46,9)
/

Delete from LeftMenuInfo where id=583
/
call LMConfig_U_ByInfoInsert (2,107,46)
/
call LMInfo_Insert (583,32638,NULL,NULL,2,107,46,9)
/

Delete from LeftMenuInfo where id=589
/
call LMConfig_U_ByInfoInsert (2,583,3)
/
call LMInfo_Insert (589,32642,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_589.png','/wechat/sendWechat.jsp',2,583,3,9 )
/

Delete from LeftMenuInfo where id=589
/
call LMConfig_U_ByInfoInsert (2,583,3)
/
call LMInfo_Insert (589,32642,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_589.png','/wechat/sendWechat.jsp',2,583,3,9 )
/

Delete from LeftMenuInfo where id=590
/
call LMConfig_U_ByInfoInsert (2,583,4)
/
call LMInfo_Insert (590,32640,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_590.png','/wechat/wechatListTab.jsp',2,583,4,9 )
/

Delete from LeftMenuInfo where id=590
/
call LMConfig_U_ByInfoInsert (2,583,4)
/
call LMInfo_Insert (590,32640,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_590.png','/wechat/wechatListTab.jsp',2,583,4,9 )
/

Delete from LeftMenuInfo where id=587
/
call LMConfig_U_ByInfoInsert (2,583,5)
/
call LMInfo_Insert (587,32641,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_587.png','/wechat/platformBandListTab.jsp',2,583,5,9 )
/

Delete from LeftMenuInfo where id=587
/
call LMConfig_U_ByInfoInsert (2,583,5)
/
call LMInfo_Insert (587,32641,'/images_face/ecologyFace_2/LeftMenuIcon/SMS_587.png','/wechat/platformBandListTab.jsp',2,583,5,9 )
/

Delete from LeftMenuInfo where id=586
/
Delete from LeftMenuInfo where id=603
/

Delete from MainMenuInfo where id=1329
/
call MMInfo_Insert (1329,26271,'','','mainFrame',0,0,5,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (0,1)
/

Delete from MainMenuInfo where id=1330
/
call MMInfo_Insert (1330,32639,'','/wechat/platformListFrame.jsp','mainFrame',1329,1,2,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (1329,2)
/

Delete from MainMenuInfo where id=1331
/
call MMInfo_Insert (1331,32776,'','/wechat/wechatSetupTab.jsp','mainFrame',1329,1,3,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (1329,3)
/


Delete from MainMenuInfo where id=1335
/
call MMInfo_Insert (1335,32949,'','/sms/SmsSetupTab.jsp','mainFrame',1329,1,1,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (1329,1)
/

update MainMenuInfo set linkAddress='/sms/SmsSetupTab.jsp?method=ALL' where id=1335
/