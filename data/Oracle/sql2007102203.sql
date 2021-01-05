create table outter_account (sysid varchar2(50),
                          userid int,
                          logintype int,
                          account varchar2(20),
                          password varchar2(20)
)
/
create table outter_sys (sysid varchar2(50),
                         name varchar2(50),
                         iurl varchar2(200),
			 ourl varchar2(200),
                         baseparam1 varchar2(50),
                         baseparam2 varchar2(50),
                         basetype1 int,
                         basetype2 int
)
/
create table outter_sysparam (sysid varchar2(50),
                         paramname varchar2(50),
                         paramvalue varchar2(200),
                         labelname varchar2(50),
                         paramtype int,
			             indexid int
)
/
create table outter_params (sysid varchar2(50),
                          userid int,
                          paramname varchar2(20),
			  paramvalue varchar2(20)
)
/
