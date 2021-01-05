alter table mode_workflowtomodeset add maintableopttype varchar(1),maintableupdatecondition varchar(256)
GO
create table mode_workflowtomodesetopt(
	id int IDENTITY(1,1) NOT NULL,
	mainid int,
	detailtablename varchar(256),
	opttype varchar(1),
	updatecondition varchar(256)
	CONSTRAINT PK_MODE_WORKFLOWTOMODESETOPT PRIMARY KEY (id)
)
GO