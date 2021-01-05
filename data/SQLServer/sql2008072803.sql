
alter PROCEDURE Bill_ExpenseDetail_Insert 
@expenseid_1        int, 
@relatedate_1       char(10), 
@feetypeid_1        int, 
@detailremark_1     varchar(250), 
@accessory_1        int, 
@relatedcrm_1       int, 
@relatedproject_1   int, 
@feesum_1           decimal(15,3), 
@realfeesum_1       decimal(15,3), 
@invoicenum_1       varchar(250), 
@rowno_1            int, 
@flag               int             output, 
@msg                varchar(80)     output 
as 
insert into bill_expensedetail 
(expenseid,relatedate,feetypeid,detailremark,accessory,relatedcrm,relatedproject,feesum,realfeesum,invoicenum,rowno) 
values 
(@expenseid_1,@relatedate_1,@feetypeid_1,@detailremark_1,@accessory_1,@relatedcrm_1,@relatedproject_1,@feesum_1,@realfeesum_1,@invoicenum_1,@rowno_1)

GO
