UPDATE hrm_transfer_set SET  link_address = '/CRM/transfer/CustomerTab.jsp?',class_name = 'weaver.hrm.authority.manager.CustomerManager'
WHERE id IN (SELECT id FROM hrm_transfer_set  
	WHERE code_name = 'D171' OR code_name = 'D251' OR code_name = 'D351' OR code_name = 'D441'
)
GO

UPDATE hrm_transfer_set SET link_address = '/cowork/transfer/CoworkTab.jsp?',class_name = 'weaver.hrm.authority.manager.CoworkManager'
WHERE id IN (SELECT id FROM hrm_transfer_set  
	WHERE code_name = 'D151' OR code_name = 'D152' OR code_name = 'D153'
	OR code_name = 'D231' OR code_name = 'D232'
	OR code_name = 'D331' OR code_name = 'D332' 
	OR code_name = 'D421' OR code_name = 'D422'
)
GO