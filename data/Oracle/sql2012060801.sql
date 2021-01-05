update workflow_billfield set dsporder=dsporder+10 where billid=85 and  dsporder>9
/
update workflow_billfield set dsporder=10 where billid=85 and  fieldname='projectid' and dsporder=9
/
update workflow_billfield set dsporder=dsporder+10 where billid=85 and  dsporder>7
/
update workflow_billfield set dsporder=8 where billid=85 and  fieldname='resourcenum' and dsporder=7
/
update workflow_billfield set dsporder=9 where billid=85 and  fieldname='resources' and dsporder=7
/
update workflow_billfield set dsporder=10 where billid=85 and  fieldname='crms' and dsporder=7
/
update workflow_billfield set dsporder=11 where billid=85 and  fieldname='others' and dsporder=7
/
update workflow_billfield set dsporder=12 where billid=85 and  fieldname='description' and dsporder=7
/
update workflow_billfield set dsporder=13 where billid=85 and  fieldname='remindType' and dsporder=7
/
update workflow_billfield set dsporder=14 where billid=85 and  fieldname='remindBeforeStart' and dsporder=7
/
update workflow_billfield set dsporder=15 where billid=85 and  fieldname='remindBeforeEnd' and dsporder=7
/
update workflow_billfield set dsporder=16 where billid=85 and  fieldname='remindTimesBeforeStart' and dsporder=7
/
update workflow_billfield set dsporder=17 where billid=85 and  fieldname='remindTimesBeforeEnd' and dsporder=7
/