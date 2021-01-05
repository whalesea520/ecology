create table fnaBudgetAssistant(
	eid INT, 
	ebaseid varchar(200), 
	hpid INT, 
	grjk INT, 
	bxxx INT, 
	bxtb INT, 
	CONSTRAINT pk_fnaBudgetAssistant PRIMARY KEY NONCLUSTERED 
	(
	  eid, ebaseid 
	)
)
GO

CREATE NONCLUSTERED INDEX idx_fnaBudgetAssistant_1 ON fnaBudgetAssistant(eid)
GO
CREATE NONCLUSTERED INDEX idx_fnaBudgetAssistant_2 ON fnaBudgetAssistant(hpid)
GO
CREATE NONCLUSTERED INDEX idx_fnaBudgetAssistant_3 ON fnaBudgetAssistant(ebaseid)
GO


insert into hpbaseelement
  (elementtype, title, logo, perpage, linkmode, moreurl, elementdesc, id, isuse, titleen, titlethk, loginview, isbase)
values
  ('2', '费用报销智能助手', 'image/fna_wev8.gif', -1, '-1', NULL, '显示借还款、费用报销金额', 'fnaBudgetAssistant', '1', 'Cost reimbursement intelligent assistant', '費用報銷智能助手', '0', '1')
GO