delete from HtmlLabelIndex where id=130509 
GO
delete from HtmlLabelInfo where indexid=130509 
GO
INSERT INTO HtmlLabelIndex values(130509,'表达式参数特殊值设置：当前日期(格式：如2017-05-08)，值设置为$date$ ；当前日期(格式：如20170508)，值设置为$date1$ ；当前日期(格式：如2017/05/08)，值设置为$date2$ ； 当前时间 ，值设置为$time$ ；当前日期和时间(格式如：2017-05-08 12:30:00)，值设置为$date') 
GO
INSERT INTO HtmlLabelInfo VALUES(130509,'表达式参数特殊值设置：当前日期(格式：如2017-05-08)，值设置为$date$ ；当前日期(格式：如20170508)，值设置为$date1$ ；当前日期(格式：如2017/05/08)，值设置为$date2$ ； 当前时间 ，值设置为$time$ ；当前日期和时间(格式如：2017-05-08 12:30:00)，值设置为$dateandtime$；当前日期和时间(格式如：20170508123000)，值设置为$dateandtime1$；当前日期和时间(格式如：2017/05/08 12:30:00)，值设置为$dateandtime2$； 距1970.1.1的毫秒数，值设置为$ts$',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130509,'The special value of expression parameters setting: the current date (Format: 2017-05-08), the $date$value is set to the current date; (Format: 20170508), the $date2$value is set to the current date; (Format: 2017/05/08), set the value to $date1$; the current time, set to a value of $time$; the current date and time format (such as 2017-05-08: 12:30:00), the $dateandtime$value is set to the current date and time; (formats such as: 20170508123000), set the value to $dateandtime1$; the current date and time (such as: 2017/05/08, 12:30:00 format) is set to a value of $dateandtime2$from 1970.1.1; the number of milliseconds, the value is set to $ts$',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130509,'表達式參數特殊值設置：當前日期(格式：如2017-05-08)，值設置為$date$ ；當前日期(格式：如20170508)，值設置為$date1$ ；當前日期(格式：如2017/05/08)，值設置為$date2$ ； 當前時間 ，值設置為$time$ ；當前日期和時間(格式如：2017-05-08 12:30:00)，值設置為$dateandtime$；當前日期和時間(格式如：20170508123000)，值設置為$dateandtime1$；當前日期和時間(格式如：2017/05/08 12:30:00)，值設置為$dateandtime2$； 距1970.1.1的毫秒數，值設置為$ts$',9) 
GO