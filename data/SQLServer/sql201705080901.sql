delete from HtmlLabelIndex where id=130509 
GO
delete from HtmlLabelInfo where indexid=130509 
GO
INSERT INTO HtmlLabelIndex values(130509,'����ʽ��������ֵ���ã���ǰ����(��ʽ����2017-05-08)��ֵ����Ϊ$date$ ����ǰ����(��ʽ����20170508)��ֵ����Ϊ$date1$ ����ǰ����(��ʽ����2017/05/08)��ֵ����Ϊ$date2$ �� ��ǰʱ�� ��ֵ����Ϊ$time$ ����ǰ���ں�ʱ��(��ʽ�磺2017-05-08 12:30:00)��ֵ����Ϊ$date') 
GO
INSERT INTO HtmlLabelInfo VALUES(130509,'����ʽ��������ֵ���ã���ǰ����(��ʽ����2017-05-08)��ֵ����Ϊ$date$ ����ǰ����(��ʽ����20170508)��ֵ����Ϊ$date1$ ����ǰ����(��ʽ����2017/05/08)��ֵ����Ϊ$date2$ �� ��ǰʱ�� ��ֵ����Ϊ$time$ ����ǰ���ں�ʱ��(��ʽ�磺2017-05-08 12:30:00)��ֵ����Ϊ$dateandtime$����ǰ���ں�ʱ��(��ʽ�磺20170508123000)��ֵ����Ϊ$dateandtime1$����ǰ���ں�ʱ��(��ʽ�磺2017/05/08 12:30:00)��ֵ����Ϊ$dateandtime2$�� ��1970.1.1�ĺ�������ֵ����Ϊ$ts$',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130509,'The special value of expression parameters setting: the current date (Format: 2017-05-08), the $date$value is set to the current date; (Format: 20170508), the $date2$value is set to the current date; (Format: 2017/05/08), set the value to $date1$; the current time, set to a value of $time$; the current date and time format (such as 2017-05-08: 12:30:00), the $dateandtime$value is set to the current date and time; (formats such as: 20170508123000), set the value to $dateandtime1$; the current date and time (such as: 2017/05/08, 12:30:00 format) is set to a value of $dateandtime2$from 1970.1.1; the number of milliseconds, the value is set to $ts$',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130509,'���_ʽ��������ֵ�O�ã���ǰ����(��ʽ����2017-05-08)��ֵ�O�Þ�$date$ ����ǰ����(��ʽ����20170508)��ֵ�O�Þ�$date1$ ����ǰ����(��ʽ����2017/05/08)��ֵ�O�Þ�$date2$ �� ��ǰ�r�g ��ֵ�O�Þ�$time$ ����ǰ���ں͕r�g(��ʽ�磺2017-05-08 12:30:00)��ֵ�O�Þ�$dateandtime$����ǰ���ں͕r�g(��ʽ�磺20170508123000)��ֵ�O�Þ�$dateandtime1$����ǰ���ں͕r�g(��ʽ�磺2017/05/08 12:30:00)��ֵ�O�Þ�$dateandtime2$�� ��1970.1.1�ĺ��딵��ֵ�O�Þ�$ts$',9) 
GO