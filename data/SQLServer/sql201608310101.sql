delete from HtmlLabelIndex where id=128476 
GO
delete from HtmlLabelInfo where indexid=128476 
GO
INSERT INTO HtmlLabelIndex values(128476,'����д�������ñ��ӿڵ�IP��ַ
���磺192.168.1.2
�����ַ��Ӣ�Ķ��ŷָ�
���磺192.168.1.2,192.168.1.3,192.168.1.4
�粻��д��Ĭ��Ϊ��������') 
GO
INSERT INTO HtmlLabelInfo VALUES(128476,'����д�������ñ��ӿڵ�IP��ַ
���磺192.168.1.2
�����ַ��Ӣ�Ķ��ŷָ�
���磺192.168.1.2,192.168.1.3,192.168.1.4
�粻��д��Ĭ��Ϊ��������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128476,'Please fill in the IP address that is allowed to call this interface 
For example: 192.168.1.2
Multiple addresses in English comma separated 
For example: 192.168.1.2,192.168.1.3,192.168.1.4
If not completed, the default is not to do limit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128476,'Ո����S�{�ñ��ӿڵ�IP��ַ
���磺192.168.1.2
������ַ��Ӣ�Ķ�̖�ָ�
���磺192.168.1.2,192.168.1.3,192.168.1.4
�粻���Ĭ�J�鲻������',9) 
GO