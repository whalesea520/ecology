delete from HtmlLabelIndex where id=126163 
GO
delete from HtmlLabelInfo where indexid=126163 
GO
INSERT INTO HtmlLabelIndex values(126163,'【国家】为必填，填写国家简称或全称均可正常导入；') 
GO
INSERT INTO HtmlLabelInfo VALUES(126163,'【国家】为必填，填写国家简称或全称均可正常导入；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126163,'[country] as required, fill in the country or the normal import can be referred to as;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126163,'【國家】爲必填，填寫國家簡稱或全稱均可正常導入；',9) 
GO
delete from HtmlLabelIndex where id=126164 
GO
delete from HtmlLabelInfo where indexid=126164 
GO
INSERT INTO HtmlLabelIndex values(126164,'导入城市时需要填写省份，导入区县时需要填写城市和省份，否则导入失败；') 
GO
INSERT INTO HtmlLabelInfo VALUES(126164,'导入城市时需要填写省份，导入区县时需要填写城市和省份，否则导入失败；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126164,'When you import a city, you need to fill in the provinces;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126164,'導入城市時需要填寫省份，導入區縣時需要填寫城市和省份，否則導入失敗；',9) 
GO
delete from HtmlLabelIndex where id=126165 
GO
delete from HtmlLabelInfo where indexid=126165 
GO
INSERT INTO HtmlLabelIndex values(126165,'经度纬度可不填写，如区县不为空默认是区县经纬度，否则为城市经纬度；') 
GO
INSERT INTO HtmlLabelInfo VALUES(126165,'经度纬度可不填写，如区县不为空默认是区县经纬度，否则为城市经纬度；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126165,'Latitude and longitude can not be filled, such as the county is not null default is the latitude and longitude of the District, otherwise it is the latitude and longitude of the city;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126165,'經度緯度可不填寫，如區縣不爲空默認是區縣經緯度，否則爲城市經緯度；',9) 
GO
delete from HtmlLabelIndex where id=126166 
GO
delete from HtmlLabelInfo where indexid=126166 
GO
INSERT INTO HtmlLabelIndex values(126166,'当填写的国家、省份、城市没有匹配到已有数据时，全部进行创建。') 
GO
INSERT INTO HtmlLabelInfo VALUES(126166,'当填写的国家、省份、城市没有匹配到已有数据时，全部进行创建。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126166,'When the country, the province, the city did not match the existing data, all of the creation.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126166,'當填寫的國家、省份、城市沒有匹配到已有數據時，全部進行創建。',9) 
GO
delete from HtmlLabelIndex where id=126167 
GO
delete from HtmlLabelInfo where indexid=126167 
GO
INSERT INTO HtmlLabelIndex values(126167,'行政区域') 
GO
INSERT INTO HtmlLabelInfo VALUES(126167,'行政区域',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126167,'Administrative division',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126167,'行政區域',9) 
GO
delete from HtmlLabelIndex where id=126168 
GO
delete from HtmlLabelInfo where indexid=126168 
GO
INSERT INTO HtmlLabelIndex values(126168,'行政区域导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(126168,'行政区域导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126168,'Administrative region import',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126168,'行政區域導入',9) 
GO
delete from HtmlLabelIndex where id=126169 
GO
delete from HtmlLabelInfo where indexid=126169 
GO
INSERT INTO HtmlLabelIndex values(126169,'行政区域设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(126169,'行政区域设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126169,'Administrative region setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126169,'行政區域設置',9) 
GO