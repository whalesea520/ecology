drop index IDX_FNAFEEWFINFO_1
/

alter table fnaFeeWfInfo modify FNAWFTYPE varCHAR2(50)
/

update fnaFeeWfInfo set FNAWFTYPE = trim(FNAWFTYPE) 
/

create index IDX_FNAFEEWFINFO_1 on fnaFeeWfInfo(FNAWFTYPE) 
/