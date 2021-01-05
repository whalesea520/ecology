update Workflow_SetTitle   set fieldzx = '0'where fieldname = 'depmarttype'   and txtUserUse = '1'   and fieldvalue = '1'   and fieldtype = 'main'   and xh = '4'   and fieldzx not in(1,2) 
/