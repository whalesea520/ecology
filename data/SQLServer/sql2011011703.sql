update HrmMessagerAccount set userid=lower(userid)
GO
update HrmMessagerGroupUsers set userloginid = lower(userloginid)
GO
update ofproperty set propvalue = 'SELECT lower(psw) as password FROM HrmMessagerAccount WHERE userid=?' where name = 'jdbcAuthProvider.passwordSQL'
GO
update ofproperty set propvalue = 'SELECT lower(loginid) as loginid FROM hrmresource where loginid!='''' and loginid is not null' where name = 'jdbcUserProvider.allUsersSQL'
GO
update ofproperty set propvalue = 'SELECT lastname,email FROM hrmresource WHERE lower(loginid)=?' where name = 'jdbcUserProvider.loadUserSQL'
GO