create table HrmMessagerAccount(
    userid varchar2(20),     
    psw varchar2(50)
)
/

update ofproperty  set propvalue='SELECT lower(psw) as password FROM HrmMessagerAccount WHERE userid=?' where name='jdbcAuthProvider.passwordSQL'
/
