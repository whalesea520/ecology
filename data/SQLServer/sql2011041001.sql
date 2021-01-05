delete from HtmlLabelIndex where id=25899 
GO
delete from HtmlLabelInfo where indexid=25899 
GO
INSERT INTO HtmlLabelIndex values(25899,'多城市名称请用半角逗号分隔(上海,北京)') 
GO
INSERT INTO HtmlLabelInfo VALUES(25899,'多城市名称请用半角逗号分隔(上海,北京)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25899,'Use city name more comma-separated (Shanghai, Beijing)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25899,'多城市名稱請用半角逗號分隔(上海,北京)',9) 
GO