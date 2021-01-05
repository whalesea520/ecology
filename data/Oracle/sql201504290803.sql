CREATE TABLE workflow_TabStyle(
	styleid  NUMBER NOT NULL,
	stylename VARCHAR2(500),
	image_bg VARCHAR2(500),
	image_sep VARCHAR2(500),
	image_sepwidth INTEGER,
	sel_bgleft VARCHAR2(500),
	sel_bgleftwidth INTEGER,
	sel_bgmiddle VARCHAR2(500),
	sel_bgright VARCHAR2(500),
	sel_bgrightwidth INTEGER,
	sel_color VARCHAR2(50),
	sel_fontsize INTEGER,
	sel_family VARCHAR2(50),
	sel_bold INTEGER,
	sel_italic INTEGER,
	unsel_bgleft VARCHAR2(500),
	unsel_bgleftwidth INTEGER,
	unsel_bgmiddle VARCHAR2(500),
	unsel_bgright VARCHAR2(500),
	unsel_bgrightwidth INTEGER,
	unsel_color VARCHAR2(50),
	unsel_fontsize INTEGER,
	unsel_family VARCHAR2(50),
	unsel_bold INTEGER,
	unsel_italic INTEGER
)
/
    create sequence workflow_TabStyle_seq minvalue 1 maxvalue 99999999
    increment by 1
    start with 1
/
create or replace trigger workflow_TabStyle_tri
 before insert on workflow_TabStyle
 for each row      
 begin      
     select workflow_TabStyle_seq.nextval into :new.styleid from DUAL;
 END;
/