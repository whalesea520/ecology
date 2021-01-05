create table FnaInitSetOpLog(
  userId integer, 
  ip VARCHAR2(100), 
  fnaBkTbName VARCHAR2(50), 

  subject integer,
  fcc integer,
  fnaBudget integer,
  fnaExpense integer,
  fnaLoan integer,
  fnaAdvance integer,

  opDate CHAR(10), 
  opTime CHAR(8)
)
/