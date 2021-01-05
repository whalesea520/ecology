/* td:1005 当客户的名称太长，则客户审批流程中不能关联客户经理和相关客户*/
ALTER TABLE bill_ApproveCustomer MODIFY (approvedesc varchar2(200))
/