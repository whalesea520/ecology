CREATE TABLE mobile_ChatResourceShare (
	ID INTEGER PRIMARY KEY,   
	resourceType INTEGER,
	resourceid INTEGER,
	sharer INTEGER,
	sharertype INTEGER,
	shareGroupID integer
)
/
create sequence SEQ_mobile_ChatResourceShare minvalue 1 nomaxvalue start with 1 increment by 1 nocycle nocache
/
CREATE OR REPLACE TRIGGER Tri_U_mobile_ChatResourceShare
BEFORE INSERT ON mobile_ChatResourceShare FOR EACH ROW WHEN (new.id is null) 
begin
	select SEQ_mobile_ChatResourceShare.nextval into:new.id from dual; 
end;
/
CREATE INDEX mobile_ChatResourceShare_index ON mobile_ChatResourceShare (sharer, resourceType, resourceid)
/
CREATE TABLE mobile_ChatResourceShareScope(
	shareid INTEGER, 
	resoueceid INTEGER,
	resouecetype integer
)
/