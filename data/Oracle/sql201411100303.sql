UPDATE hrm_transfer_set SET  link_address = '/CRM/transfer/CustomerTab.jsp?_fromURL=auth'||code_name,class_name = 'weaver.hrm.authority.manager.CustomerManager'
WHERE id IN (SELECT id FROM hrm_transfer_set  
	WHERE code_name = 'T101' 
	OR code_name = 'C101' 
	OR code_name = 'C211' OR code_name = 'C311' OR code_name = 'C401'
	OR code_name = 'D171' OR code_name = 'D251' OR code_name = 'D351' OR code_name = 'D441'
)
/

UPDATE hrm_transfer_set SET link_address = '/cowork/transfer/CoworkTab.jsp?_fromURL=auth'||code_name,class_name = 'weaver.hrm.authority.manager.CoworkManager'
WHERE id IN (SELECT id FROM hrm_transfer_set  
	WHERE code_name = 'T181' OR code_name = 'T182' OR code_name = 'T183'
	OR code_name = 'T231' OR code_name = 'T232'
	OR code_name = 'T331' OR code_name = 'T332' 
	OR code_name = 'T421' OR code_name = 'T422'
	OR code_name = 'C171' OR code_name = 'C172' OR code_name = 'C173' 
	OR code_name = 'C251' OR code_name = 'C252' 
	OR code_name = 'C351' OR code_name = 'C352' 
	OR code_name = 'C441' OR code_name = 'C442'
	OR code_name = 'D151' OR code_name = 'D152' OR code_name = 'D153'
	OR code_name = 'D231' OR code_name = 'D232'
	OR code_name = 'D331' OR code_name = 'D332' 
	OR code_name = 'D421' OR code_name = 'D422'
)
/