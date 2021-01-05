create table FnaInitSetOpLog(
  userId int, 
  ip VARCHAR(100), 
  fnaBkTbName VARCHAR(50), 

  subject int,
  fcc int,
  fnaBudget int,
  fnaExpense int,
  fnaLoan int,
  fnaAdvance int,

  opDate CHAR(10), 
  opTime CHAR(8)
)
GO