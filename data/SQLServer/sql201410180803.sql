ALTER TABLE HrmCompanyVirtual ADD virtualtypedesc varchar(100)
GO
UPDATE cus_formsetting SET STATUS = 2 WHERE module='hrm'
GO
