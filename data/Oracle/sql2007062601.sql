DELETE FROM HtmlLabelIndex WHERE id = 20518
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20518
/
INSERT INTO HtmlLabelIndex values(20518,'FTP服务器设置') 
/
INSERT INTO HtmlLabelInfo VALUES(20518,'FTP服务器设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20518,'FTP Server Config',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20519
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20519
/
INSERT INTO HtmlLabelIndex values(20519,'FTP服务器') 
/
INSERT INTO HtmlLabelInfo VALUES(20519,'FTP服务器',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20519,'FTP Server',8) 
/
 
DELETE FROM HtmlLabelIndex WHERE id = 18624
/
DELETE FROM HtmlLabelInfo WHERE indexId = 18624
/
INSERT INTO HtmlLabelIndex values(18624,'是否启用') 
/
INSERT INTO HtmlLabelInfo VALUES(18624,'是否启用',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18624,'Use Or Not',8) 
/
 
DELETE FROM HtmlLabelIndex WHERE id = 18782
/
DELETE FROM HtmlLabelInfo WHERE indexId = 18782
/
INSERT INTO HtmlLabelIndex values(18782,'端口号') 
/
INSERT INTO HtmlLabelInfo VALUES(18782,'端口号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18782,'Port Number',8) 
/
 
DELETE FROM HtmlLabelIndex WHERE id = 2072
/
DELETE FROM HtmlLabelInfo WHERE indexId = 2072
/
INSERT INTO HtmlLabelIndex values(2072,'用户名') 
/
INSERT INTO HtmlLabelInfo VALUES(2072,'Login name',8) 
/
INSERT INTO HtmlLabelInfo VALUES(2072,'用户名',7) 
/
 
DELETE FROM HtmlLabelIndex WHERE id = 409
/
DELETE FROM HtmlLabelInfo WHERE indexId = 409
/
INSERT INTO HtmlLabelIndex values(409,'密码') 
/
INSERT INTO HtmlLabelInfo VALUES(409,'Password',8) 
/
INSERT INTO HtmlLabelInfo VALUES(409,'密码',7) 
/

DELETE FROM HtmlLabelIndex WHERE id = 18476
/
DELETE FROM HtmlLabelInfo WHERE indexId = 18476
/
INSERT INTO HtmlLabelIndex values(18476,'根目录') 
/
INSERT INTO HtmlLabelInfo VALUES(18476,'根目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18476,'Root Folder',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20522
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20522
/
INSERT INTO HtmlLabelIndex values(20522,'最大连接数') 
/
INSERT INTO HtmlLabelInfo VALUES(20522,'最大连接数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20522,'Max Connect',8) 
/
 
DELETE FROM HtmlLabelIndex WHERE id = 20523
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20523
/
INSERT INTO HtmlLabelIndex values(20523,'IP访问规则') 
/
INSERT INTO HtmlLabelInfo VALUES(20523,'IP访问规则',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20523,'IP Access Rule',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 18541
/
DELETE FROM HtmlLabelInfo WHERE indexId = 18541
/
INSERT INTO HtmlLabelIndex values(18541,'例如') 
/
INSERT INTO HtmlLabelInfo VALUES(18541,'例如',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18541,'For example',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20540
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20540
/
INSERT INTO HtmlLabelIndex values(20540,'请确认该目录已存在!') 
/
INSERT INTO HtmlLabelInfo VALUES(20540,'请确认该目录已存在!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20540,'Please sure this directory is created!',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20541
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20541
/
INSERT INTO HtmlLabelIndex values(20541,'启用后，只有符合IP访问规则中的IP地址的客户端可以对此子目录下文档进行操作') 
/
INSERT INTO HtmlLabelInfo VALUES(20541,'启用后，只有符合IP访问规则中的IP地址的客户端可以对此子目录下文档进行操作',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20541,'if this open,it will be accessed whose ip in these ip rules',8) 
/
 
DELETE FROM HtmlLabelIndex WHERE id = 20542
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20542
/
INSERT INTO HtmlLabelIndex values(20542,'可以直接添加IP地址，如：127.0.0.1') 
/
INSERT INTO HtmlLabelInfo VALUES(20542,'可以直接添加IP地址，如：127.0.0.1',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20542,'can add ip example:127.0.0.1',8) 
/
 
DELETE FROM HtmlLabelIndex WHERE id = 20543
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20543
/
INSERT INTO HtmlLabelIndex values(20543,'可以在某个数字上使用单通配符?，如：12?.0.0.1') 
/
INSERT INTO HtmlLabelInfo VALUES(20543,'可以在某个数字上使用单通配符?，如：12?.0.0.1',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20543,'can add ? in one number of ip,example 12?.0.0.1',8) 
/
 
DELETE FROM HtmlLabelIndex WHERE id = 20544
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20544
/
INSERT INTO HtmlLabelIndex values(20544,'可以添加多位通配符*，如：127.*，128.0.*，129.0.0.*') 
/
INSERT INTO HtmlLabelInfo VALUES(20544,'可以添加多位通配符*，如：127.*，128.0.*，129.0.0.*',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20544,'can use * in some number example:127.*,128.0.*,129.0.0.*',8) 
/
