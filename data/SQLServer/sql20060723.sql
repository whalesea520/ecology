create procedure updatenewdepdefault
as
    declare @tempid int
    declare c cursor for select id from HrmDepartment where id not in (select objid from HrmPerformanceCheckFlow where objtype=2)
    open c
    fetch next from c into @tempid
    while @@fetch_status = 0
    begin
        insert into HrmPerformanceCheckFlow (objId,objType) values (@tempid,2)
        insert into HrmPerformanceCheckFlow (objId,objType) values (@tempid,3)
        fetch next from c into @tempid
    end
    close c
    deallocate c
    
    declare c2 cursor for select id from HrmSubCompany where id not in (select objid from HrmPerformanceCheckFlow where objtype=1)
    open c2
    fetch next from c2 into @tempid
    while @@fetch_status = 0
    begin
        insert into HrmPerformanceCheckFlow (objId,objType) values (@tempid,1)
        fetch next from c2 into @tempid
    end
    close c2
    deallocate c2
go

execute updatenewdepdefault
go
drop    procedure updatenewdepdefault
go

CREATE TRIGGER Tri_I_DeptKPICheckFlow ON HrmDepartment
FOR INSERT
AS
Declare 
@deptid 	int,
@countdelete   	int,
@countinsert   	int

SELECT @countdelete = count(*) FROM deleted
SELECT @countinsert = count(*) FROM inserted


IF (@countinsert>0 AND @countdelete=0)
BEGIN
	SELECT @deptid=id FROM inserted
	INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (@deptid,'2')
	INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (@deptid,'3')
END
go

CREATE TRIGGER Tri_I_SubComKPICheckFlow ON HrmSubCompany
FOR INSERT
AS
Declare 
@subcompid 	int,
@countdelete   	int,
@countinsert   	int

SELECT @countdelete = count(*) FROM deleted
SELECT @countinsert = count(*) FROM inserted


IF (@countinsert>0 AND @countdelete=0)
BEGIN
	SELECT @subcompid=id FROM inserted
	INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (@subcompid,'1')
END
go