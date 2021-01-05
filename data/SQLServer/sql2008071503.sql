create table hpsetting_wfcenter(
   id int NOT NULL IDENTITY (1, 1),
   eid int,
   viewType int,
   typeids varchar(800),
   flowids varchar(2500),
   nodeids varchar(4000)
)
GO

update hpbaseelement set elementtype=2 where id=8
Go

insert into  hpextelement (id,extshow,description) values (8,'Workflow.jsp','流程中心')
Go

INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (85,8,'19225','createrDept','0','','','','','0',5)
GO

INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (86,8,'16579','workflowtype','0','','','','','0',6)
GO

INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (87,8,'15534','importantleve','0','','','','','0',7)
GO


update hpFieldElement set ordernum=3 where id=85
GO

update hpFieldElement set ordernum=4 where id=86
GO

update hpFieldElement set ordernum=5 where id=87
GO

update hpFieldElement set  ordernum=6 where id=14
GO

update hpFieldElement set ordernum=7 where id=15
GO
