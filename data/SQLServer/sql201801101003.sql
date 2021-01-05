ALTER table workflow_requestLog alter column clientip varchar(256)
GO
ALTER table workflow_requestViewLog alter column ipaddress varchar(256)
GO
ALTER table workflow_requestdeletelog alter column client_address varchar(256)
GO