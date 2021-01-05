CREATE TABLE mobile_sign ( 
    id NUMBER(38,0) NOT NULL,
    operater integer NOT NULL,
    operate_type VARCHAR(50) NOT NULL,
    operate_date CHAR(50) NOT NULL,
    operate_time CHAR(8) NOT NULL,
    longitude VARCHAR(50) NOT NULL,
    latitude VARCHAR(50) NOT NULL,
    address VARCHAR(500),
    remark VARCHAR(1000),
    attachment VARCHAR(500)
) 
/
create sequence mobile_sign_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mobile_sign_id_trigger
before insert on mobile_sign for each row
begin
select mobile_sign_id.nextval into :new.id from dual;
end;
/