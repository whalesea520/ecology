CREATE TABLE workflow_mgms (
        id int IDENTITY (1, 1) NOT NULL,        
        requestId int  NULL ,                
        userid int NULL ,                        
        receivedate varchar(10) NULL,              
        receivetime varchar(10) NULL,            
        sendTime varchar(20)  NULL,           
	transactionid varchar(250) NULL,
	previoustrsid varchar(250) NULL,
	status varchar(1) NULL,
	processtrsid varchar(250) NULL,
)
GO

CREATE TABLE workflow_mgmsworkflows (
        workflowid int NOT NULL
)
GO

CREATE TABLE workflow_mgmsusers (
        userid int NOT NULL
)
GO
