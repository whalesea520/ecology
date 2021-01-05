update HrmMessagerAccount set userid=lower(userid)
/
update HrmMessagerGroupUsers set userloginid = lower(userloginid)
/
update ofproperty set propvalue = 'SELECT lower(psw) as password FROM HrmMessagerAccount WHERE userid=?' where name = 'jdbcAuthProvider.passwordSQL'
/
update ofproperty set propvalue = 'SELECT lower(loginid) as loginid FROM hrmresource where loginid!='''' and loginid is not null' where name = 'jdbcUserProvider.allUsersSQL'
/
update ofproperty set propvalue = 'SELECT lastname,email FROM hrmresource WHERE lower(loginid)=?' where name = 'jdbcUserProvider.loadUserSQL'
/