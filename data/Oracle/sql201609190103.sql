CREATE TABLE wf_fna_ffilar_imp(
	id integer NOT NULL,
	MAINID integer NULL,
	rule1 integer NULL,
	rule1INTENSITY integer NULL,
	rule2 integer NULL,
	rule2INTENSITY integer NULL,
	rule3 integer NULL,
	rule3INTENSITY integer NULL,
	rule4 integer NULL,
	rule4INTENSITY integer NULL,
	rule5 integer NULL,
	rule5INTENSITY integer NULL,
	PROMPTSC varchar2(4000) NULL,
	PROMPTTC varchar2(4000) NULL,
	PROMPTEN varchar2(4000) NULL,
	PROMPTSC2 varchar2(4000) NULL,
	PROMPTTC2 varchar2(4000) NULL,
	PROMPTEN2 varchar2(4000) NULL,
	PROMPTSC3 varchar2(4000) NULL,
	PROMPTTC3 varchar2(4000) NULL,
	PROMPTEN3 varchar2(4000) NULL,
	PROMPTSC4 varchar2(4000) NULL,
	PROMPTTC4 varchar2(4000) NULL,
	PROMPTEN4 varchar2(4000) NULL,
	PROMPTSC5 varchar2(4000) NULL,
	PROMPTTC5 varchar2(4000) NULL,
	PROMPTEN5 varchar2(4000) NULL, 
	impguid1 varchar2(50)
)
/



ALTER TABLE wf_fna_ffi_imp add fnaWfTypeReverseAdvance integer
/