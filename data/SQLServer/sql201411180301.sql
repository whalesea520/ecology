delete from HtmlLabelIndex where id=30643 
GO
delete from HtmlLabelInfo where indexid=30643 
GO
INSERT INTO HtmlLabelIndex values(30643,'ÿҳ��ʾ') 
GO
INSERT INTO HtmlLabelInfo VALUES(30643,'ÿҳ��ʾ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(30643,'Per Page',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(30643,'ÿ��@ʾ',9) 
GO
delete from HtmlLabelIndex where id=81511 
GO
delete from HtmlLabelInfo where indexid=81511 
GO
INSERT INTO HtmlLabelIndex values(81511,'�������ݼ���') 
GO
INSERT INTO HtmlLabelInfo VALUES(81511,'�������ݼ���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81511,'Existing Data Integration',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81511,'���Д�������',9) 
GO
delete from HtmlLabelIndex where id=30688 
GO
delete from HtmlLabelInfo where indexid=30688 
GO
INSERT INTO HtmlLabelIndex values(30688,'����ѡ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(30688,'����ѡ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(30688,'Data selection',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(30688,'�����x��',9) 
GO
delete from HtmlLabelIndex where id=32219 
GO
delete from HtmlLabelInfo where indexid=32219 
GO
INSERT INTO HtmlLabelIndex values(32219,'�Զ��巽ʽ') 
GO
INSERT INTO HtmlLabelInfo VALUES(32219,'�Զ��巽ʽ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32219,'Customize the way',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32219,'�Զ��x��ʽ',9) 
GO
delete from HtmlLabelIndex where id=22970 
GO
delete from HtmlLabelInfo where indexid=22970 
GO
INSERT INTO HtmlLabelIndex values(22970,'TABҳ') 
GO
INSERT INTO HtmlLabelInfo VALUES(22970,'TABҳ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22970,'Tab Page',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22970,'TABҳ',9) 
GO
delete from hpBaseElement where id='OutData'
GO 
INSERT INTO hpBaseElement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleEN,titleTHK,loginview) VALUES ('OutData','2','�ⲿ����Ԫ��','resource/image/8.gif','10','2','getNoreadFlow','�ⲿ����Ԫ��','1','OutData','�ⲿ����Ԫ��','0')
GO