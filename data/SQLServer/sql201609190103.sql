CREATE TABLE wf_fna_ffilar_imp(
	id int NOT NULL,
	MAINID int NULL,
	rule1 int NULL,
	rule1INTENSITY int NULL,
	rule2 int NULL,
	rule2INTENSITY int NULL,
	rule3 int NULL,
	rule3INTENSITY int NULL,
	rule4 int NULL,
	rule4INTENSITY int NULL,
	rule5 int NULL,
	rule5INTENSITY int NULL,
	PROMPTSC varchar(4000) NULL,
	PROMPTTC varchar(4000) NULL,
	PROMPTEN varchar(4000) NULL,
	PROMPTSC2 varchar(4000) NULL,
	PROMPTTC2 varchar(4000) NULL,
	PROMPTEN2 varchar(4000) NULL,
	PROMPTSC3 varchar(4000) NULL,
	PROMPTTC3 varchar(4000) NULL,
	PROMPTEN3 varchar(4000) NULL,
	PROMPTSC4 varchar(4000) NULL,
	PROMPTTC4 varchar(4000) NULL,
	PROMPTEN4 varchar(4000) NULL,
	PROMPTSC5 varchar(4000) NULL,
	PROMPTTC5 varchar(4000) NULL,
	PROMPTEN5 varchar(4000) NULL, 
	impguid1 varchar(50)
)
GO



ALTER TABLE wf_fna_ffi_imp add fnaWfTypeReverseAdvance INT
GO