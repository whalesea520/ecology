update SystemRights  set rightdesc='��н��������������' where id = 906
GO
update SystemRights  set rightdesc='��н����Ч������' where id = 907
GO
update SystemRights  set rightdesc='��н�ٹ���' where id = 908
GO
update SystemRightDetail  set rightdetailname='��н��������������' where rightid = 906
GO
update SystemRightDetail  set rightdetailname='��н����Ч������' where rightid = 907
GO
update SystemRightDetail  set rightdetailname='��н�ٹ���' where rightid = 908
GO
update SystemRightsLanguage  set rightdesc='��н��������������',rightname='��н��������������' where id = 906 and languageid=7
GO
update SystemRightsLanguage  set rightdesc='Paid fake batch processing setup',rightname='Paid fake batch processing setup' where id = 906 and languageid=8
GO
update SystemRightsLanguage  set rightdesc='��н������̎���O��',rightname='��н������̎���O��' where id = 906 and languageid=9
GO
update SystemRightsLanguage  set rightdesc='��н����Ч������',rightname='��н����Ч������' where id = 907 and languageid=7
GO
update SystemRightsLanguage  set rightdesc='Paid leave period setting',rightname='Paid leave period setting' where id = 907 and languageid=8
GO
update SystemRightsLanguage  set rightdesc='��н����Ч���O��',rightname='��н����Ч���O��' where id = 907 and languageid=9
GO
update SystemRightsLanguage  set rightdesc='��н�ٹ���',rightname='��н�ٹ���' where id = 908 and languageid=7
GO
update SystemRightsLanguage  set rightdesc='Paid leave management',rightname='Paid leave management' where id = 908 and languageid=8
GO
update SystemRightsLanguage  set rightdesc='��н�ٹ���',rightname='��н�ٹ���' where id = 908 and languageid=9
GO