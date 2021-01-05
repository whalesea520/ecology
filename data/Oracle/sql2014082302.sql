

Delete from MainMenuInfo where id=138
/

Delete from MainMenuInfo where id=1319
/

CALL MMConfig_U_ByInfoInsert (128,24)
/

CALL MMInfo_Insert (1319,645,'','/CRM/Maint/ListContactWay.jsp','mainFrame',128,2,24,0,'',0,'',0,'','',0,'','',4)
/


DELETE FROM LeftMenuConfig WHERE id IN 
	(SELECT t1.id FROM LeftMenuConfig  t1, LeftMenuInfo t2 WHERE t1.infoId = t2.id AND t2.parentId = 3)
/

DELETE FROM LeftMenuInfo WHERE parentId = 3 AND id IN (24,25,26,27,28,29,30,31,32,33,34,103,104,105,106,279)
/


Delete from LeftMenuInfo where id=24
/
CALL LMConfig_U_ByInfoInsert (2,3,1)
/
CALL LMInfo_Insert (24,15006,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_1.gif','/CRM/data/AddCustomerFrame.jsp',2,3,1,4) 
/


Delete from LeftMenuInfo where id=25
/
CALL LMConfig_U_ByInfoInsert (2,3,2)
/
CALL LMInfo_Insert (25,6059,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_2.gif','/CRM/data/CustomerFrame.jsp?type=mine',2,3,2,4) 
/


Delete from LeftMenuInfo where id=26
/
CALL LMConfig_U_ByInfoInsert (2,3,3)
/
CALL LMInfo_Insert (26,6082,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_5.gif','/CRM/report/ContactFrame.jsp',2,3,3,4) 
/

Delete from LeftMenuInfo where id=27
/
CALL LMConfig_U_ByInfoInsert (2,3,4)
/
CALL LMInfo_Insert (27,2227,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_6.gif','/CRM/sellchance/SellChanceFrame.jsp',2,3,4,4) 
/

Delete from LeftMenuInfo where id=28
/
CALL LMConfig_U_ByInfoInsert (2,3,5)
/
CALL LMInfo_Insert (28,16260,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_7.gif','/CRM/report/ContractFrame.jsp',2,3,5,4) 
/

Delete from LeftMenuInfo where id=29
/
CALL LMConfig_U_ByInfoInsert (2,3,6)
/
CALL LMInfo_Insert (29,32731,'/images_face/ecologyFace_1/LeftMenuIcon/LinkmanSearch.gif','/CRM/search/ContacterSearchFrame.jsp',2,3,6,4) 
/

Delete from LeftMenuInfo where id=30
/
CALL LMConfig_U_ByInfoInsert (2,3,7)
/
CALL LMInfo_Insert (30,16407,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_11.gif','/CRM/data/CustomerFrame.jsp?type=search',2,3,7,4) 
/

Delete from LeftMenuInfo where id=31
/
CALL LMConfig_U_ByInfoInsert (2,3,8)
/
CALL LMInfo_Insert (31,18037,'/images_face/ecologyFace_1/LeftMenuIcon/BatchShare.gif','/CRM/data/CustomerFrame.jsp?type=share',2,3,8,4) 
/

Delete from LeftMenuInfo where id=32
/
CALL LMConfig_U_ByInfoInsert (2,3,9)
/
CALL LMInfo_Insert (32,17648,'/images_face/ecologyFace_1/LeftMenuIcon/CRMWatch.gif','/CRM/data/CustomerFrame.jsp?type=monitor',2,3,9,4) 
/






Delete from LeftMenuInfo where id=576
/
CALL LMConfig_U_ByInfoInsert (2,80,1)
/
CALL LMInfo_Insert (576,32571,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance.gif','/cowork/coworkview.jsp?menuType=discuss',2,80,1,9) 
/

Delete from LeftMenuInfo where id=577
/
CALL LMConfig_U_ByInfoInsert (2,80,2)
/
CALL LMInfo_Insert (577,32572,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance.gif','/cowork/CoworkRelatedFrame.jsp',2,80,2,9) 
/


Delete from LeftMenuInfo where id=579
/
CALL LMConfig_U_ByInfoInsert (2,80,3)
/
CALL LMInfo_Insert (579,32574,'like: /images_face/ecologyFace_1/LeftMenuIcon/*.gif','/cowork/coworkview.jsp?menuType=themeApproval',2,80,3,9) 
/


Delete from LeftMenuInfo where id=580
/
CALL LMConfig_U_ByInfoInsert (2,80,4)
/
CALL LMInfo_Insert (580,32575,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance.gif','/cowork/coworkview.jsp?menuType=contentApproval',2,80,4,9) 
/

Delete from LeftMenuInfo where id=581
/
CALL LMConfig_U_ByInfoInsert (2,80,5)
/
CALL LMInfo_Insert (581,32576,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance.gif','/cowork/coworkview.jsp?menuType=themeMonitor',2,80,5,9) 
/ 

Delete from LeftMenuInfo where id=582
/
CALL LMConfig_U_ByInfoInsert (2,80,6)
/
CALL LMInfo_Insert (582,32577,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance.gif','/cowork/coworkview.jsp?menuType=contentMonitor',2,80,6,9) 
/


Delete from LeftMenuInfo where id=638
/
CALL LMConfig_U_ByInfoInsert (2,80,5)
/
CALL LMInfo_Insert (638,33842,'/images_face/ecologyFace_1/LeftMenuIcon/WF_3.gif','/cowork/CoworkApplyFrame.jsp',2,80,5,9) 
/


Delete from MainMenuInfo where id=1381
/
CALL MMConfig_U_ByInfoInsert (11,86)
/
CALL MMInfo_Insert (1381,24751,'邮件设置','','',11,1,86,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=1382
/
CALL MMConfig_U_ByInfoInsert (1381,0)
/
CALL MMInfo_Insert (1382,15037,'邮件系统设置','/email/maint/MailSystemFrame.jsp','',1381,2,0,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=1383
/
CALL MMConfig_U_ByInfoInsert (1381,1)
/
CALL MMInfo_Insert (1383,33447,'邮件模板设置','/email/maint/MailTemplateFrame.jsp','',1381,2,1,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=1384
/
CALL MMConfig_U_ByInfoInsert (1381,2)
/
CALL MMInfo_Insert (1384,33448,'邮件监控设置','/email/maint/MailMonitorFrame.jsp','',1381,2,2,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=1385
/
CALL MMConfig_U_ByInfoInsert (1381,3)
/
CALL MMInfo_Insert (1385,33449,'企业邮箱管理','/email/maint/MailEnterpriseFrame.jsp','',1381,2,3,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=1386
/
CALL MMConfig_U_ByInfoInsert (1381,4)
/
CALL MMInfo_Insert (1386,33450,'邮箱空间管理','/email/new/MailSpaceFrame.jsp','',1381,2,4,0,'',0,'',0,'','',0,'','',9)
/


update LeftMenuInfo set iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/ASSIS_638.png' where id=638
/
update LeftMenuInfo set iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/ASSIS_577.png' where id=577
/