delete from HtmlLabelIndex where id=131015 
GO
delete from HtmlLabelInfo where indexid=131015 
GO
INSERT INTO HtmlLabelIndex values(131015,'�����������������ݣ���ʽΪ��select �����ֶ� from tablename where �����ֶ�={?currentvalue}��{?currentvalue}��ʾ��ǰֵ') 
GO
INSERT INTO HtmlLabelInfo VALUES(131015,'�����������������ݣ���ʽΪ��select �����ֶ� from tablename where �����ֶ�={?currentvalue}��{?currentvalue}��ʾ��ǰֵ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131015,'The parameters can be set as follows: The format is selected from tablename where the condition field = { Currentvalue} Currentvalue} represents the current value',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131015,'�������O�������ݣ���ʽ�飺select ��K�ֶ� from tablename where �l���ֶ�={?currentvalue}��{?currentvalue}��ʾ��ǰֵ',9) 
GO