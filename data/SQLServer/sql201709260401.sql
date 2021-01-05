delete from HtmlLabelIndex where id=131715 
GO
delete from HtmlLabelInfo where indexid=131715 
GO
INSERT INTO HtmlLabelIndex values(131715,'说明：1、不设置为不限制补交时间; 2、0表示不能补交; 3、正数表示可补交天数（自然日）;') 
GO
INSERT INTO HtmlLabelInfo VALUES(131715,'说明：1、不设置为不限制补交时间; 2、0表示不能补交; 3、正数表示可补交天数（自然日）;',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131715,'Note: 1, not set to not limit the payment time; 2,0 that can not pay; 3, positive number that can be compensated for days (natural days);',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131715,'說明：1、不設置爲不限制補交時間; 2、0表示不能補交; 3、正數表示可補交天數（自然日）;',9) 
GO