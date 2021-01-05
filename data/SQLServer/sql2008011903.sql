ALTER PROCEDURE CptCapital_Delete 
	(@id_1 	[int],
	@flag integer output,
	 @msg varchar(80) output)

AS 
declare @count int
declare @isdata int
select @count=count(*) from CptCapital where datatype = @id_1
begin
	if @count<>0
	begin
		select -1
		return
	end
end
select @isdata = isdata from CptCapital where id = @id_1
if(@isdata = 1)
update CptCapitalAssortment set capitalcount = capitalcount-1 
where id in (select capitalgroupid from CptCapital where id = @id_1 )

DELETE [CptCapital] 

WHERE 
	( [id]	 = @id_1)

select max(id) from CptCapital

GO

ALTER PROCEDURE CptCapital_ForcedDelete (
@id_1 [int], @flag integer output, @msg varchar(80) output)  
AS
declare @isdata int
select @isdata = isdata from CptCapital where id = @id_1
if(@isdata = 1) 
UPDATE CptCapitalAssortment SET capitalcount = capitalcount-1 
WHERE id IN (SELECT capitalgroupid FROM CptCapital WHERE id = @id_1)  
DELETE [CptCapital] WHERE [id] = @id_1 
GO

update CptCapitalAssortment set capitalcount = (select count(*) from CptCapital t1 where isdata = 1 and CptCapitalAssortment.id = t1.capitalgroupid )
GO
