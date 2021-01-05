delete from codedetail
go

INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'编码前缀',2,'proj',1)
GO

INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'客户类型编码',1,'1',2)
GO

INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'项目类型编码',1,'1',3)
GO


INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'工作类型编码',1,'1',4)
GO


INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'年',3,'1|1',5)
GO
INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'月',1,'1',6)
GO

INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'日',1,'1',7)
GO


INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'流水号位数',2,'4',8)
GO
