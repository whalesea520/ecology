delete from HtmlLabelIndex where id=21723 
/
delete from HtmlLabelInfo where indexid=21723 
/
INSERT INTO HtmlLabelIndex values(21723,'投票后不可查看结果') 
/
INSERT INTO HtmlLabelInfo VALUES(21723,'投票后不可查看结果',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21723,'After the voting results can not be read',8) 
/
delete from HtmlLabelIndex where id=21724 
/
delete from HtmlLabelInfo where indexid=21724 
/
INSERT INTO HtmlLabelIndex values(21724,'投票已成功，谢谢参与！') 
/
INSERT INTO HtmlLabelInfo VALUES(21724,'投票已成功，谢谢参与！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21724,'Vote has been successful, thank you participate!',8) 
/
delete from HtmlLabelIndex where id=21725 
/
delete from HtmlLabelInfo where indexid=21725 
/
INSERT INTO HtmlLabelIndex values(21725,'可选项数') 
/
INSERT INTO HtmlLabelInfo VALUES(21725,'可选项数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21725,'Can be few options',8) 
/
delete from HtmlLabelIndex where id=21726 
/
delete from HtmlLabelInfo where indexid=21726 
/
INSERT INTO HtmlLabelIndex values(21726,'可选取项超过规定,请重新选取') 
/
INSERT INTO HtmlLabelInfo VALUES(21726,'可选取项超过规定,请重新选取',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21726,'You can select the items over, please re-select',8) 
/
delete from HtmlLabelIndex where id=21727 
/
delete from HtmlLabelInfo where indexid=21727 
/
INSERT INTO HtmlLabelIndex values(21727,'已投票人') 
/
INSERT INTO HtmlLabelInfo VALUES(21727,'已投票人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21727,'Voters have',8) 
/
delete from HtmlLabelIndex where id=21728 
/
delete from HtmlLabelInfo where indexid=21728 
/
INSERT INTO HtmlLabelIndex values(21728,'未投票人') 
/
INSERT INTO HtmlLabelInfo VALUES(21728,'未投票人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21728,'People did not vote',8) 
/

delete from SystemRights where id=792
/
insert into SystemRights (id,rightdesc,righttype) values (792,'调查删除权限','1') 
/
delete from SystemRightsLanguage where id=792
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (792,7,'调查删除权限','调查删除权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (792,8,'votingDelete','votingDelete') 
/
delete from SystemRightDetail where id=4302
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4302,'调查删除权限','voting:delete',792) 
/
delete from SystemRights where id=793
/
insert into SystemRights (id,rightdesc,righttype) values (793,'调查详细信息查看权限','1') 
/
delete from SystemRightsLanguage where id=793
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (793,7,'调查详细信息查看权限','调查详细信息查看权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (793,8,'votingParticular','votingParticular') 
/
delete from SystemRightDetail where id=4303
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4303,'调查详细信息查看权限','voting:particular',793) 
/

delete from HtmlLabelIndex where id=21765 
/
delete from HtmlLabelInfo where indexid=21765 
/
INSERT INTO HtmlLabelIndex values(21765,'请输入大于0的数字!') 
/
INSERT INTO HtmlLabelInfo VALUES(21765,'请输入大于0的数字!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21765,'Please enter the number greater than 0!',8) 
/