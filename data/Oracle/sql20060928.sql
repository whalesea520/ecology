INSERT INTO HtmlLabelIndex values(19756,'速算扣除数') 
/
INSERT INTO HtmlLabelInfo VALUES(19756,'速算扣除数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19756,'Subtract Number',8) 
/
alter table HrmSalaryTaxrate add subtractnum integer
/


create or replace  PROCEDURE HrmSalaryTaxrate_Insert
	(benchid_1 	integer,
	 ranknum_2 	integer,
	 ranklow_3 	integer,
	 rankhigh_4 	integer,
	 taxrate_5 	integer,
     subtractnum_6 	integer,
     flag out          integer, 
     msg  out         varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO HrmSalaryTaxrate 
	 ( benchid,
	 ranknum,
	 ranklow,
	 rankhigh,
	 taxrate,
     subtractnum) 
 
VALUES 
	( benchid_1,
	 ranknum_2,
	 ranklow_3,
	 rankhigh_4,
	 taxrate_5,
     subtractnum_6);
end;

/