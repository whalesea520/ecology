create table user_default_col_bak(
  id          INTEGER not null,
  pageid      VARCHAR2(1000) not null,
  userid      INTEGER not null,
  col_base_id INTEGER,
  orders      INTEGER,
  systemid    INTEGER not null,
  width_      VARCHAR2(640),
  onlywidth   INTEGER
)

/

CREATE TABLE system_default_col_bak(
	id integer  NOT NULL,
	isdefault varchar2(1) NOT NULL,
	pageid varchar2(200) NULL,
	align varchar2(10) NULL,
	name varchar2(32) NULL,
	column_ varchar2(32) NULL,
	orderkey varchar2(200) NULL,
	linkvaluecolumn varchar2(32) NULL,
	linkkey varchar2(32) NULL,
	href varchar2(200) NULL,
	target varchar2(32) NULL,
	transmethod varchar2(100) NULL,
	otherpara varchar2(2000) NULL,
	orders integer NULL,
	width varchar2(30) NULL,
	text_ varchar2(400) NULL,
	labelid varchar2(50) NULL,
	hide_ varchar2(10),
	pkey varchar2(100)
) 
/