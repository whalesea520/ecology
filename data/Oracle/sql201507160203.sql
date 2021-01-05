CREATE TABLE cloudoa_conf (
id int NOT NULL ,
confname VARCHAR2(50),
confvalue VARCHAR2(50)
)
/

INSERT INTO cloudoa_conf (id,confname,confvalue) VALUES (1,'blockstatus', '1')
/