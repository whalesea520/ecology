create table wsregiste
(
				id int IDENTITY (1, 1) NOT NULL ,
        customcode varchar(100),
        customname varchar(100),
				webserviceurl varchar(2000)
)
GO
create table wsregistemethod
(
	      id int IDENTITY (1, 1) NOT NULL ,
        mainid int,
        methodname varchar(200),
	      methoddesc varchar(200),
	      methodreturntype varchar(200)
)
GO
create table wsregistemethodparam
(
	      id int IDENTITY (1, 1) NOT NULL ,
        methodid int,
        paramname varchar(200),
        paramtype varchar(200),
	      isarray char(1)
)
GO

create table wsmethodparamvalue
(
	      id int IDENTITY (1, 1) NOT NULL ,
	      contentid int,
	      contenttype int,
        	methodid int,
        paramname varchar(200),
        paramtype varchar(200),
	      isarray char(1),
	      paramsplit varchar(10),
	      paramvalue varchar(4000)
)
GO
alter table financesetparam add transql varchar(4000)
GO