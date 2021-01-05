delete from HtmlLabelIndex where id=128946 
GO
delete from HtmlLabelInfo where indexid=128946 
GO
INSERT INTO HtmlLabelIndex values(128946,'未开启【下级统一费控】选项时，也不能开启【是否结转】选项') 
GO
INSERT INTO HtmlLabelInfo VALUES(128946,'未开启【下级统一费控】选项时，也不能开启【是否结转】选项',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128946,'Did not open the lower unified fee control options, you can not open the [whether] option',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128946,'未開啓【下級統一費控】選項時，也不能開啓【是否結轉】選項',9) 
GO

delete from HtmlLabelIndex where id=128948 
GO
delete from HtmlLabelInfo where indexid=128948 
GO
INSERT INTO HtmlLabelIndex values(128948,'当科目未开启【下级统一费控】选项时，【是否结转】也不能填写！') 
GO
delete from HtmlLabelIndex where id=128949 
GO
delete from HtmlLabelInfo where indexid=128949 
GO
INSERT INTO HtmlLabelIndex values(128949,'当科目开启【可编制预算】选项后，【是否结转】必须填写！') 
GO
INSERT INTO HtmlLabelInfo VALUES(128949,'当科目开启【可编制预算】选项后，【是否结转】必须填写！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128949,'When the subject is open to prepare budget options, [whether] must be completed!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128949,'當科目開啓【可編制預算】選項後，【是否結轉】必須填寫！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128948,'当科目未开启【下级统一费控】选项时，【是否结转】也不能填写！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128948,'When the subjects did not open the lower cost control options, [whether] can not be completed!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128948,'當科目未開啓【下級統一費控】選項時，【是否結轉】也不能填寫！',9) 
GO

delete from HtmlLabelIndex where id=128950 
GO
delete from HtmlLabelInfo where indexid=128950 
GO
INSERT INTO HtmlLabelIndex values(128950,'下级统一费控的科目必填，可选值：是、否') 
GO
INSERT INTO HtmlLabelInfo VALUES(128950,'下级统一费控的科目必填，可选值：是、否',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128950,'The subjects required lower fees, unified control, is not optional:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128950,'下級統一費控的科目必填，可選值：是、否',9) 
GO
