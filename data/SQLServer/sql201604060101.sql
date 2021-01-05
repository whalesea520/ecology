delete from HtmlLabelIndex where id=127102 
GO
delete from HtmlLabelInfo where indexid=127102 
GO
INSERT INTO HtmlLabelIndex values(127102,'导入必填字段，当设置选择框为空时表示导入时需要验证设置的字段是否必填，当选择框不为空时则表示满足选择框条件之后才去验证设置的字段是否必填。') 
GO
INSERT INTO HtmlLabelInfo VALUES(127102,'导入必填字段，当设置选择框为空时表示导入时需要验证设置的字段是否必填，当选择框不为空时则表示满足选择框条件之后才去验证设置的字段是否必填。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127102,'Import conditions for setting import verification required fields.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127102,'導入必填字段，當設置選擇框為空時表示導入時需要驗證設置的字段是否必填，當選擇框不為空時則表示滿足選擇框條件之後才去驗證設置的字段是否必填。',9) 
GO
