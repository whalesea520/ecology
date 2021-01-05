update hpextelement set extshow='Rss.jsp' where id=1
/


delete from  HtmlLabelIndex where id=20173
/
delete from  HtmlLabelInfo where indexId=20173
/
delete from  HtmlLabelIndex where id=20174
/
delete from  HtmlLabelInfo where indexId=20174
/
delete from  HtmlLabelIndex where id=20175
/
delete from  HtmlLabelInfo where indexId=20175
/
delete from  HtmlLabelIndex where id=20176
/
delete from  HtmlLabelInfo where indexId=20176
/
INSERT INTO HtmlLabelIndex values(20174,'第一步:打开IE的“工具->Internet选项”') 
/
INSERT INTO HtmlLabelIndex values(20176,'第三步:把此站点添加到受信任站点') 
/
INSERT INTO HtmlLabelIndex values(20175,'第二步:打开"安全选项卡"') 
/
INSERT INTO HtmlLabelInfo VALUES(20174,'第一步:打开IE的“工具->Internet选项”',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20174,'First Step: Open IE "Tools->Internet option"',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20175,'第二步:打开"安全选项卡"',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20175,'Second Step: Open "safe option page"',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20176,'第三步:把此站点添加到受信任站点',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20176,'Third Setp:Add this web address to setting that can be confide',8) 
/
INSERT INTO HtmlLabelIndex values(20173,'当添加到可信任站点后，不需要降低IE的安全设置！') 
/
INSERT INTO HtmlLabelInfo VALUES(20173,'当添加到可信任站点后，不需要降低IE的安全设置！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20173,'No need low the IE''s setting when you add this web address into the setting that can confide',8) 
/