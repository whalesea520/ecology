create table wf_fna_initWfInfo(
  workflowId int, 
  formId int, 
  fnaWfType1 int, 
  fnaWfType2 int, 
  CONSTRAINT pk_wf_fna_initWfInfo PRIMARY KEY (workflowId,formId)
)
go