update extendHomepage set extendName='ecology7主题模板', extenddesc='ecology7主题模板',extendurl='/portal/plugin/homepage/ecology7theme' where id=3
/
CREATE TABLE extandHpTheme (
	id integer,
	templateId integer,
	subcompanyid integer
)
/
CREATE TABLE extandHpThemeItem (
	id integer,
	extandHpThemeId integer,
	theme nvarchar2(100),
	skin nvarchar2(100),
	logoTop nvarchar2(100),
	logoBottom nvarchar2(100),
	isopen integer,
	islock integer
)
/

CREATE SEQUENCE extandHpThemeId MINVALUE 1 MAXVALUE 99999999999999 START WITH 1 INCREMENT BY 1 CACHE 20 ORDER
/

CREATE OR REPLACE TRIGGER extandHpTheme_TG 
BEFORE INSERT ON extandHpTheme FOR EACH ROW 
BEGIN 
    SELECT extandHpThemeId.NEXTVAL INTO :NEW.ID FROM DUAL; 
END; 
/
CREATE SEQUENCE extandHpThemeItemId MINVALUE 1 MAXVALUE 99999999999999 START WITH 1 INCREMENT BY 1 CACHE 20 ORDER
/

CREATE OR REPLACE TRIGGER extandHpThemeItem_TG 
BEFORE INSERT ON extandHpThemeItem FOR EACH ROW 
BEGIN 
    SELECT extandHpThemeItemId.NEXTVAL INTO :NEW.ID FROM DUAL; 
END; 
/
