CREATE TABLE workflow_agentpersons
(
    requestid       int           NULL,
    receivedPersons varchar(1000) NULL
)
go

update SystemModule set modulereleased=0 where id=8
go

UPDATE license set cversion = '3.000'
Go
