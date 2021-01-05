update SystemRights  set rightdesc='带薪假批量处理设置' where id = 906
/
update SystemRights  set rightdesc='带薪假有效期设置' where id = 907
/
update SystemRights  set rightdesc='带薪假管理' where id = 908
/
update SystemRightDetail  set rightdetailname='带薪假批量处理设置' where rightid = 906
/
update SystemRightDetail  set rightdetailname='带薪假有效期设置' where rightid = 907
/
update SystemRightDetail  set rightdetailname='带薪假管理' where rightid = 908
/
update SystemRightsLanguage  set rightdesc='带薪假批量处理设置',rightname='带薪假批量处理设置' where id = 906 and languageid=7
/
update SystemRightsLanguage  set rightdesc='Paid fake batch processing setup',rightname='Paid fake batch processing setup' where id = 906 and languageid=8
/
update SystemRightsLanguage  set rightdesc='帶薪假批量處理設置',rightname='帶薪假批量處理設置' where id = 906 and languageid=9
/
update SystemRightsLanguage  set rightdesc='带薪假有效期设置',rightname='带薪假有效期设置' where id = 907 and languageid=7
/
update SystemRightsLanguage  set rightdesc='Paid leave period setting',rightname='Paid leave period setting' where id = 907 and languageid=8
/
update SystemRightsLanguage  set rightdesc='帶薪假有效期設置',rightname='帶薪假有效期設置' where id = 907 and languageid=9
/
update SystemRightsLanguage  set rightdesc='带薪假管理',rightname='带薪假管理' where id = 908 and languageid=7
/
update SystemRightsLanguage  set rightdesc='Paid leave management',rightname='Paid leave management' where id = 908 and languageid=8
/
update SystemRightsLanguage  set rightdesc='帶薪假管理',rightname='帶薪假管理' where id = 908 and languageid=9
/
