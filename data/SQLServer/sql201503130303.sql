Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '10','sub','-','','txtname','',-id,'44','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle    )  
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '6','sub','-','','txtname','',-id,'22','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle    )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '5','main','0','','resourcetype','2',-id,'','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle  )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '1','main','1','','txtusertitle','',-id,'44','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle   )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '2','sub','-','','txtname','',-id,'11','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle  )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '3','main','0','','subtype','0',-id,'','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle   )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '4','main','1','','depmarttype','0',-id,'','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle   )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '7','main','1','','txtuseryear','',-id,'','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle  )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '8','sub','-','','txtname','',-id,'33','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle  )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '9','main','1','','txtusermouth','',-id,'','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle  )
go
Insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse) select '11','main','1','','txtuserdate','',-id,'','1' from workflow_base where     id not in(select workflowid from Workflow_SetTitle   )
go
update  Workflow_SetTitle set workflowid=ABS(workflowid) where workflowid<0
go