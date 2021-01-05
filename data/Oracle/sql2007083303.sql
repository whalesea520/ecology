update workflow_browserurl set fieldDbType='varchar2(4000)' where id=142
/

alter   table   DocReceiveUnit   modify(receiverIds   varchar2(4000))
/

update workflow_formdict set fieldDbType='varchar2(4000)' where fieldHtmlType='3' and type=142
/


CREATE OR REPLACE PROCEDURE DocReceiveUnit_UpdateInfo
AS
        fieldName varchar2(40);
	str_sql varchar2(400);
begin
         for fieldName_cursor in(select fieldName from workflow_formdict where fieldHtmlType='3' and type=142)
         loop
              fieldName := fieldName_cursor.fieldName;
	      str_sql :='alter table workflow_form modify('||fieldName||' varchar2(4000))';
	      execute immediate str_sql;
         end loop;
end;
/

call DocReceiveUnit_UpdateInfo()
/

drop PROCEDURE DocReceiveUnit_UpdateInfo
/