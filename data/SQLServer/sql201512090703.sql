CREATE TABLE sms_interface (
id int NOT NULL IDENTITY(1,1) PRIMARY KEY,
name varchar(200),
keyword varchar(200),
type varchar(100),
remark varchar(2000),
clazzname varchar(200),
interfaceType int ,
versinNo decimal(6,2) ,
dsporder decimal(6,2)
)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('Httpͨ�ýӿ�', 'HTTP ͨ�� UMS86 һ��ͨ E��ͨƽ̨(��ͨ)', 'HTTP', 'Httpͨ�ýӿ�,����󲿷�ͨ������http��ʽ�Ķ��Žӿ�  ���� http://120.0.0.1/sendSms.jsp?userid=1&pwd=1&phone=13800138000&content=���&sendtime=  ����򵥵�����MD5����,����ֱ���������д���ܺõ�����', 'weaver.sms.system.HttpSmsServiceImpl', 0, 1.00, 1.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('���ز��Խӿ�', '����', 'HTTP', '��־��ӡ���ͼ�¼', 'weaver.sms.system.NativeSmsServiceImpl', 0, 1.00, 9999.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('����WebService�ӿ�', '���� Webservice emay', 'WebService', '��������Webservice���Žӿ�,���� http://sdk4report.eucp.b2m.cn:8080/sdk/SDKService �� http://sdk229ws.eucp.b2m.cn:8080/sdk/SDKService ��', 'weaver.sms.system.emay.YMSmsServiceImpl', 0, 1.00, 2.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('�Ϻ��ƶ�����ͨEMPP�ӿ�', '�ƶ�����ͨ EMPP', 'SDK', '�Ϻ��ƶ�����ͨEMPP �����Ҫʹ������ͨEMA��ʽ����ʹ��Httpͨ�ýӿڽ�������', 'weaver.sms.system.qxt.EMPP_SmsServiceImpl', 0, 1.00, 3.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('�����Ƽ�Webservice�ӿ�', '�����Ƽ� montnets  MWGate', 'Webservice', '�����Ƽ� http://www.montnets.com  http://ws.montnets.com:9002/MWGate/wmgw.asmx', 'weaver.sms.system.mw.MWSmsServiceImpl', 0, 1.00, 4.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('�����Ƽ�Webservice�ӿ�', '�����Ƽ� entinfo ', 'Webservice', 'http://sdk.entinfo.cn:8060/webservice.asmx', 'weaver.sms.system.entinfo.EntinfoSmsServiceImpl', 0, 1.00, 5.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('��ͨ����Http�ӿ�', '��ͨ���� etonenet', 'HTTP', 'http://esms.etonenet.com/sms/mt', 'weaver.sms.system.etonenet.ETongNetSmsServiceImpl', 0, 1.00, 6.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('��Ϊ���Ż�Webservice�ӿ�', 'azdg����  ��ΪMAS812 ��ҵ��Ϣ�� �ƶ�����������', 'Webservice', 'http://********/services/Sms', 'weaver.sms.system.azdg.AzdgSmsServiceImple', 0, 1.00, 7.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('��������SDK�ӿ�', '����SDK mobset', 'SDK', 'http://www.mobset.com/  �˿�:2036,��һƽ̨���˻���Ҳ������ҵID��1��ͷ��  �˿�:2046,����ƽ̨���˻� ', 'weaver.sms.system.shouyi.ShouYiSDKSmsServiceImpl', 0, 1.00, 8.00)
GO