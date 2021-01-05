create table fnaBudgetAssistant1(
	eid integer, 
	ebaseid varchar2(200), 
	hpid integer, 
	PRIMARY KEY (eid, ebaseid) 
)
/

alter table fnaBudgetAssistant1 add Hrm integer
/
alter table fnaBudgetAssistant1 add Dep integer
/
alter table fnaBudgetAssistant1 add SubCmp integer
/
alter table fnaBudgetAssistant1 add Fcc integer
/

CREATE INDEX idx_fnaBudgetAssistant1_1 ON fnaBudgetAssistant1(eid)
/
CREATE INDEX idx_fnaBudgetAssistant1_2 ON fnaBudgetAssistant1(hpid)
/
CREATE INDEX idx_fnaBudgetAssistant1_3 ON fnaBudgetAssistant1(ebaseid)
/


insert into hpbaseelement
  (elementtype, title, logo, perpage, linkmode, moreurl, elementdesc, id, isuse, titleen, titlethk, loginview, isbase)
values
  ('2', '审批助手元素', 'image/fna_wev8.gif', -1, '-1', NULL, '审批助手元素', 'fnaBudgetAssistant1', '1', 'Approval assistant element', '審批助手元素', '0', '1')
/