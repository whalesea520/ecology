delete from HtmlLabelIndex where id=128476 
GO
delete from HtmlLabelInfo where indexid=128476 
GO
INSERT INTO HtmlLabelIndex values(128476,'请填写允许调用本接口的IP地址
例如：192.168.1.2
多个地址以英文逗号分割
例如：192.168.1.2,192.168.1.3,192.168.1.4
如不填写，默认为不做限制') 
GO
INSERT INTO HtmlLabelInfo VALUES(128476,'请填写允许调用本接口的IP地址
例如：192.168.1.2
多个地址以英文逗号分割
例如：192.168.1.2,192.168.1.3,192.168.1.4
如不填写，默认为不做限制',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128476,'Please fill in the IP address that is allowed to call this interface 
For example: 192.168.1.2
Multiple addresses in English comma separated 
For example: 192.168.1.2,192.168.1.3,192.168.1.4
If not completed, the default is not to do limit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128476,'請填寫允許調用本接口的IP地址
例如：192.168.1.2
多個地址以英文逗號分隔
例如：192.168.1.2,192.168.1.3,192.168.1.4
如不填寫，默認為不做限制',9) 
GO