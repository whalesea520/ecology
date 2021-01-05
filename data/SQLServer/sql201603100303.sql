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
  ('2', '���ñ�����������', 'image/fna_wev8.gif', -1, '-1', NULL, '��ʾ�軹����ñ������', 'fnaBudgetAssistant', '1', 'Cost reimbursement intelligent assistant', '�M�È��N��������', '0', '1')
GO