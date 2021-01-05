CREATE OR REPLACE PROCEDURE Doc_isUsedCustomSearch
         (id_1      integer,
          flag     out integer,
           msg     out varchar2,
thecursor IN OUT cursor_define.weavercursor) as
begin
  open thecursor for
    select useCustomSearch from docseccategory where id = id_1;
end;
/