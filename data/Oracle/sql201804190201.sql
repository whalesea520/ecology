delete from HtmlLabelIndex where id=383026 
/
delete from HtmlLabelInfo where indexid=383026 
/
INSERT INTO HtmlLabelIndex values(383026,'用户名提示语') 
/
INSERT INTO HtmlLabelInfo VALUES(383026,'拥有管理员权限的LDAP用户,输入对应的distinguishedName属性值;如果在根目录USERS组下只需要输入CN内容即可,如:administrator;如果在非根目录USERS组下的用户,需要输入全路径,如:CN=admin,OU=用户,OU=公司,DC=lw,DC=com',7) 
/
INSERT INTO HtmlLabelInfo VALUES(383026,'LDAP users with administrator privileges enter the corresponding distinguishedName attribute values; if you need to input only CN content under the root directory USERS group, such as administrator; if the user under the non root directory USERS group, you need to enter the full path, such as CN=admin,OU=用户,OU=公司,DC=lw,DC=com',8) 
/
INSERT INTO HtmlLabelInfo VALUES(383026,'擁有管理員許可權的LDAP用戶，輸入對應的distinguishedName屬性值；如果在根目錄USERS組下只需要輸入CN內容即可，如：administrator；如果在非根目錄USERS組下的用戶，需要輸入全路徑，如：CN=admin,OU=用户,OU=公司,DC=lw,DC=com',9) 
/