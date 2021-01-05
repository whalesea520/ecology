ALTER table cus_formfield ADD hrm_fieldlable VARCHAR(500)
/
UPDATE cus_formfield SET hrm_fieldlable = fieldlable WHERE scope='HrmCustomFieldByInfoType'
/