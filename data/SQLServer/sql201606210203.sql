create table fnaBudgetAssistant1(
	eid INT, 
	ebaseid varchar(200), 
	hpid INT, 
	CONSTRAINT pk_fnaBudgetAssistant1 PRIMARY KEY NONCLUSTERED 
	(
	  eid, ebaseid 
	)
)
GO

alter table fnaBudgetAssistant1 add Hrm INT
GO
alter table fnaBudgetAssistant1 add Dep INT
GO
alter table fnaBudgetAssistant1 add SubCmp INT
GO
alter table fnaBudgetAssistant1 add Fcc INT
GO

CREATE NONCLUSTERED INDEX idx_fnaBudgetAssistant1_1 ON fnaBudgetAssistant1(eid)
GO
CREATE NONCLUSTERED INDEX idx_fnaBudgetAssistant1_2 ON fnaBudgetAssistant1(hpid)
GO
CREATE NONCLUSTERED INDEX idx_fnaBudgetAssistant1_3 ON fnaBudgetAssistant1(ebaseid)
GO


insert into hpbaseelement
  (elementtype, title, logo, perpage, linkmode, moreurl, elementdesc, id, isuse, titleen, titlethk, loginview, isbase)
values
  ('2', '审批助手元素', 'image/fna_wev8.gif', -1, '-1', NULL, '审批助手元素', 'fnaBudgetAssistant1', '1', 'Approval assistant element', '審批助手元素', '0', '1')
GO