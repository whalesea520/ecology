create table wf_fna_initWfInfo(
  workflowId integer, 
  formId integer, 
  fnaWfType1 integer, 
  fnaWfType2 integer, 
  CONSTRAINT pk_wf_fna_initWfInfo PRIMARY KEY (workflowId,formId)
)
/