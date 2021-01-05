create table FnaBudgetfeeTypeUsed(
  subjectId integer, 
  userId integer, 
  orderId integer 
)
/

create index idx_FnaBudgetfeeTypeUsed1 on FnaBudgetfeeTypeUsed (subjectId)
/

create index idx_FnaBudgetfeeTypeUsed2 on FnaBudgetfeeTypeUsed (userId)
/

create index idx_FnaBudgetfeeTypeUsed3 on FnaBudgetfeeTypeUsed (orderId)
/


create table FnaBudgetfeeTypeBwTab(
  bwTabId integer, 
  userId integer 
)
/

create index idx_FnaBudgetfeeTypeBwTab1 on FnaBudgetfeeTypeBwTab (bwTabId)
/

create index idx_FnaBudgetfeeTypeBwTab2 on FnaBudgetfeeTypeBwTab (userId)
/
