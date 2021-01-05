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
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('Http通用接口', 'HTTP 通用 UMS86 一信通 E信通平台(联通)', 'HTTP', 'Http通用接口,满足大部分通过请求http方式的短信接口  例如 http://120.0.0.1/sendSms.jsp?userid=1&pwd=1&phone=13800138000&content=你好&sendtime=  如果简单的密码MD5加密,可以直接在这边填写加密好的密码', 'weaver.sms.system.HttpSmsServiceImpl', 0, 1.00, 1.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('本地测试接口', '测试', 'HTTP', '日志打印发送记录', 'weaver.sms.system.NativeSmsServiceImpl', 0, 1.00, 9999.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('亿美WebService接口', '亿美 Webservice emay', 'WebService', '满足亿美Webservice短信接口,例如 http://sdk4report.eucp.b2m.cn:8080/sdk/SDKService 或 http://sdk229ws.eucp.b2m.cn:8080/sdk/SDKService 等', 'weaver.sms.system.emay.YMSmsServiceImpl', 0, 1.00, 2.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('上海移动企信通EMPP接口', '移动企信通 EMPP', 'SDK', '上海移动企信通EMPP 如果需要使用企信通EMA方式可以使用Http通用接口进行配置', 'weaver.sms.system.qxt.EMPP_SmsServiceImpl', 0, 1.00, 3.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('梦网科技Webservice接口', '梦网科技 montnets  MWGate', 'Webservice', '梦网科技 http://www.montnets.com  http://ws.montnets.com:9002/MWGate/wmgw.asmx', 'weaver.sms.system.mw.MWSmsServiceImpl', 0, 1.00, 4.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('漫道科技Webservice接口', '漫道科技 entinfo ', 'Webservice', 'http://sdk.entinfo.cn:8060/webservice.asmx', 'weaver.sms.system.entinfo.EntinfoSmsServiceImpl', 0, 1.00, 5.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('移通网络Http接口', '移通网络 etonenet', 'HTTP', 'http://esms.etonenet.com/sms/mt', 'weaver.sms.system.etonenet.ETongNetSmsServiceImpl', 0, 1.00, 6.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('华为短信机Webservice接口', 'azdg加密  华为MAS812 企业信息机 移动代理服务器', 'Webservice', 'http://********/services/Sms', 'weaver.sms.system.azdg.AzdgSmsServiceImple', 0, 1.00, 7.00)
GO
INSERT INTO  sms_interface(name, keyword, type, remark, clazzname, interfacetype, versinNo, dsporder) VALUES ('广州首易SDK接口', '首易SDK mobset', 'SDK', 'http://www.mobset.com/  端口:2036,是一平台的账户，也就是企业ID是1开头的  端口:2046,是三平台的账户 ', 'weaver.sms.system.shouyi.ShouYiSDKSmsServiceImpl', 0, 1.00, 8.00)
GO