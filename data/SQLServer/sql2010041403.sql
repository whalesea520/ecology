alter table outerdatawfset add datasourceid varchar(30)
GO

update outerdatawfset set datasourceid='outdatabase'
GO
