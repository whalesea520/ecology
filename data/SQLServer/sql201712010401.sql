delete from HtmlLabelIndex where id=132215 
GO
delete from HtmlLabelInfo where indexid=132215 
GO
INSERT INTO HtmlLabelIndex values(132215,'�����޶�ϵ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(132215,'�����޶�ϵ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132215,'Cost limit coefficient',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132215,'�M�����~ϵ��',9) 
GO

delete from HtmlLabelIndex where id=132218 
GO
delete from HtmlLabelInfo where indexid=132218 
GO
INSERT INTO HtmlLabelIndex values(132218,'���ñ�׼ϵ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(132218,'���ñ�׼ϵ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132218,'Cost standard coefficient',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132218,'�M�ñ��ϵ��',9) 
GO

delete from HtmlLabelIndex where id=132219 
GO
delete from HtmlLabelInfo where indexid=132219 
GO
INSERT INTO HtmlLabelIndex values(132219,'���ñ�׼*���ñ�׼ϵ�����粻ƥ����ñ�׼ϵ���ֶΣ���Ĭ�ϰ�ϵ��1������㣩��ȡ��ֵ������޶��ֶν��бȽϣ���������޶���ڼ����ķ��ñ�׼������ͨ��action��ֹ�����ύ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(132219,'���ñ�׼*���ñ�׼ϵ�����粻ƥ����ñ�׼ϵ���ֶΣ���Ĭ�ϰ�ϵ��1������㣩��ȡ��ֵ������޶��ֶν��бȽϣ���������޶���ڼ����ķ��ñ�׼������ͨ��action��ֹ�����ύ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132219,'The cost standard * the cost standard coefficient (such as the mismatched cost standard coefficient field, the default is calculated by coefficient 1), and the value obtained is compared with the cost limit field. If the cost limit is greater than the calculated cost standard amount, it will be submitted through the action blocking process.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132219,'�M�ñ��*�M�ñ��ϵ�����粻ƥ���M�ñ��ϵ���ֶΣ��tĬ�J��ϵ��1���cӋ�㣩�@ȡ��ֵ�c�M�����~�ֶ��M�б��^������M�����~����Ӌ������M�ñ���~�Ȅt��ͨ�^action��ֹ�����ύ��',9) 
GO

delete from HtmlLabelIndex where id=132220 
GO
delete from HtmlLabelInfo where indexid=132220 
GO
INSERT INTO HtmlLabelIndex values(132220,'���ñ�׼�������action������Ϣ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(132220,'���ñ�׼�������action������Ϣ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132220,'Cost standard excess control action configuration information:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132220,'�M�ñ�ʳ��~����action������Ϣ��',9) 
GO

delete from HtmlLabelIndex where id=132224 
GO
delete from HtmlLabelInfo where indexid=132224 
GO
INSERT INTO HtmlLabelIndex values(132224,'�����ֶ�����SQL') 
GO
INSERT INTO HtmlLabelInfo VALUES(132224,'�����ֶ�����SQL',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132224,'Generate field property SQL',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132224,'�����ֶΌ���SQL',9) 
GO