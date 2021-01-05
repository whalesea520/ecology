ALTER TABLE hrm_schedule_personnel
ADD field006 INT
/
ALTER TABLE hrm_schedule_personnel
ADD field007 VARCHAR(100)
/
CREATE OR REPLACE TYPE ins_seq_type IS VARRAY(100) OF NUMBER
/
select * from table(ins_seq_type(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20))
/
insert into hrm_schedule_personnel (delflag,creater,create_time,last_modifier,last_modification_time,sn,field001,field002,field003,field004,field005,field006,field007)
SELECT delflag,creater,create_time,last_modifier,last_modification_time,sn,field001,substr(t.field002,instr(t.field002, ';', 1, c.column_value) + 1,instr(t.field002, ';', 1, c.column_value + 1) -(instr(t.field002, ';', 1, c.column_value) + 1)) AS field002,field003,field004,field005,field006,field007
FROM (SELECT delflag,creater,create_time,last_modifier,last_modification_time,sn,field001,';' || field002 || ';' as field002,field003,field004,field005,field006,field007,length(field002 || ';') - nvl(length(REPLACE(field002, ';')), 0) AS cnt FROM hrm_schedule_personnel where instr(field002,';')>0  ) t
INNER JOIN TABLE(ins_seq_type(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)) c ON c.column_value <= t.cnt ORDER BY 1, 2
/
delete from hrm_schedule_personnel where instr(field002,';')>0
/
