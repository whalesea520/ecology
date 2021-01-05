UPDATE hrm_transfer_set SET  link_address = '/CRM/transfer/CustomerTab.jsp?',class_name = 'weaver.hrm.authority.manager.CustomerManager'
WHERE id IN (SELECT id FROM hrm_transfer_set  
	WHERE code_name = 'T101' 
	OR code_name = 'C101' 
	OR code_name = 'C211' OR code_name = 'C311' OR code_name = 'C401'
)
GO

UPDATE hrm_transfer_set SET link_address = '/cowork/transfer/CoworkTab.jsp?',class_name = 'weaver.hrm.authority.manager.CoworkManager'
WHERE id IN (SELECT id FROM hrm_transfer_set  
	WHERE code_name = 'T181' OR code_name = 'T182' OR code_name = 'T183'
	OR code_name = 'T231' OR code_name = 'T232'
	OR code_name = 'T331' OR code_name = 'T332' 
	OR code_name = 'T421' OR code_name = 'T422'
	OR code_name = 'C171' OR code_name = 'C172' OR code_name = 'C173' 
	OR code_name = 'C251' OR code_name = 'C252' 
	OR code_name = 'C351' OR code_name = 'C352' 
	OR code_name = 'C441' OR code_name = 'C442'
)
GO