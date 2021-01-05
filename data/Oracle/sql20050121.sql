ALTER TABLE Bill_ExpenseDetail ADD rowno integer NULL
/
create or replace procedure Bill_ExpenseDetail_Insert 
(
	expenseid_1		integer,
	relatedate_1       char,
	feetypeid_1		integer,
	detailremark_1	    varchar2,
	accessory_1		integer,
	relatedcrm_1       integer,
	relatedproject_1   integer,
	feesum_1			number,
	realfeesum_1		number,
	invoicenum_1       varchar2,
    rowno_1            integer, 
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
	insert into bill_expensedetail 
    (expenseid,relatedate,feetypeid,detailremark,accessory,relatedcrm,relatedproject,feesum,realfeesum,invoicenum,rowno)
	values
	(expenseid_1,relatedate_1,feetypeid_1,detailremark_1,accessory_1,relatedcrm_1,relatedproject_1,feesum_1,realfeesum_1,invoicenum_1,rowno_1);
end;
/

CREATE or REPLACE PROCEDURE Bill_ExpenseDetali_SelectByID 
 (id_1 integer,
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
 AS
 begin
 open thecursor for 
 select *  from Bill_ExpenseDetail where expenseid=id_1 order by rowno;
 end;
/
