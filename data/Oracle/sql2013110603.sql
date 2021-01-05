create sequence indexupdatelog_Id minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/

create table indexupdatelog 
(
  ID               INTEGER,
  DOCID            INTEGER,
  CTYPE            VARCHAR2(30),
  MODTYPE          VARCHAR2(30),
  CREATETIME       CHAR(19),
  DOCCREATEDATE    VARCHAR2(10),
  DONEFLAG         INTEGER
)
/

CREATE table FullSearch_ViewSet
    (
	id                    INTEGER  NULL,
	userid	              INTEGER NULL,
	contentType           VARCHAR(20) NULL,
	canShowField          VARCHAR(1000) NULL,
	showField             VARCHAR(1000) NULL,
	bgimg                 INTEGER NULL,
	numPerPage            INTEGER NULL,
	showContentTypes      VARCHAR(1000) NULL
	)
/

CREATE table FullSearch_HotKeys
    (
	id                    INTEGER  NULL,
	userid	              INTEGER NULL,
	hotKey                VARCHAR(1000) NULL,
	intCount              INTEGER NULL,
	updateTime            NUMBER(19) NULL
	)
/
