ALTER table workflow_billfield ADD selectItemType CHAR(1)
GO
ALTER table workflow_billfield ADD pubchoiceId int
GO
ALTER table workflow_billfield ADD pubchilchoiceId int
GO
ALTER table workflow_billfield ADD statelev int
GO


UPDATE workflow_billfield set selectItemType='0' WHERE selectItemType IS NULL
GO




CREATE TABLE selectItemLog
(
	id int NOT NULL IDENTITY(1, 1),
	objid int,
	selectname varchar (1000) ,
	logmodule varchar (20) ,
	logtype varchar (80) ,
	operator varchar (400) ,
	operatorname varchar (400) ,
	optdatetime varchar (400)
) 

GO

ALTER TABLE mode_selectitempage ADD operatetime VARCHAR(20)
GO
ALTER TABLE mode_selectitempage ADD formids VARCHAR(2000)
GO

ALTER TABLE mode_selectitempagedetail ADD name1 VARCHAR(1000)
GO
ALTER TABLE mode_selectitempagedetail ADD name2 VARCHAR(1000)
GO

