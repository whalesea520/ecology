alter TABLE rule_base rename column condit to condit_temp
/
alter TABLE rule_base add condit clob
/
update rule_base set condit = condit_temp
/
alter table RULE_EXPRESSIONBASE modify elementvalue1 varchar2(4000)
/