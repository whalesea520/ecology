ALTER table  CRM_ContractProduct  ADD test integer
/
update CRM_ContractProduct set test  = number_n 
/
ALTER table  CRM_ContractProduct  drop column number_n
/
ALTER TABLE CRM_ContractProduct RENAME COLUMN test TO number_n
/
