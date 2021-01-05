create table fnaBudgetAssistant(
	eid integer, 
	ebaseid varchar2(200), 
	hpid integer, 
	grjk integer, 
	bxxx integer, 
	bxtb integer, 
	PRIMARY KEY (eid, ebaseid) 
)
/

CREATE INDEX idx_fnaBudgetAssistant_1 ON fnaBudgetAssistant(eid)
/
CREATE INDEX idx_fnaBudgetAssistant_2 ON fnaBudgetAssistant(hpid)
/
CREATE INDEX idx_fnaBudgetAssistant_3 ON fnaBudgetAssistant(ebaseid)
/


insert into hpbaseelement
  (elementtype, title, logo, perpage, linkmode, moreurl, elementdesc, id, isuse, titleen, titlethk, loginview, isbase)
values
  ('2', '费用报销智能助手', 'image/fna_wev8.gif', -1, '-1', NULL, '显示借还款、费用报销金额', 'fnaBudgetAssistant', '1', 'Cost reimbursement intelligent assistant', '費用報銷智能助手', '0', '1')
/