create or replace procedure int_authorizeRight_Insert ( baseid_1  integer, type_2    varchar2, resourceids_3    varchar2, roleids_4	    varchar2, wfids_5    varchar2, ordernum_6 varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin insert into int_authorizeRight (baseid,type,resourceids,roleids,wfids,ordernum) values (baseid_1,type_2,resourceids_3,roleids_4,wfids_5,ordernum_6);  select MAX(id) into maxid_  from int_authorizeRight; open thecursor for  select maxid_  from dual; end;
 /