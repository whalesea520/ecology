update SystemRightDetail set rightid=(select id from SystemRights where rightdesc like '%��ͬ����ά��%') where rightdetailname like '%��ͬ����鿴%'
GO