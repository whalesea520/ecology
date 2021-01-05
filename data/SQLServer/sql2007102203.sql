create table outter_account (sysid varchar(50),
                          userid int,
                          logintype int,
                          account varchar(20),
                          password varchar(20)
)
GO
create table outter_sys (sysid varchar(50),
                         name varchar(50),
                         iurl varchar(200),
			             ourl varchar(200),
                         baseparam1 varchar(50),
                         baseparam2 varchar(50),
                         basetype1 int,
                         basetype2 int
)
GO
create table outter_sysparam (sysid varchar(50),
                         paramname varchar(50),
                         paramvalue varchar(200),
                         labelname varchar(50),
                         paramtype int,
			             indexid int
)
GO
create table outter_params (sysid varchar(50),
                          userid int,
                          paramname varchar(20),
						  paramvalue varchar(20)
)
GO