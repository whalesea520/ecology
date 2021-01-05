ALTER PROCEDURE Doc_AddSecidToFather
(@secid_1 int, @flag integer output , @msg varchar(80) output) as 
declare @fatherid_1 int, @fatherid1_1 int
declare @secid_ch_1 varchar(10)
declare @secids_1 varchar(500)

set @secid_ch_1 = convert(varchar, @secid_1)
select @fatherid_1=subcategoryid from DocSecCategory where id = @secid_1
if @fatherid_1 is null set @fatherid_1 = -1
if @fatherid_1 = 0 set @fatherid_1 = -1 

while @fatherid_1 <> -1 begin
    select @fatherid1_1=subcategoryid, @secids_1=seccategoryids from DocSubCategory where id = @fatherid_1
    if (@secids_1 is null) or (@secids_1 = '') begin
        update DocSubCategory set seccategoryids = @secid_ch_1 where id = @fatherid_1
    end
    else if (charindex(','+@secid_ch_1+',', ','+@secids_1+',')=0) begin
        update DocSubCategory set seccategoryids = @secids_1+','+@secid_ch_1 where id = @fatherid_1
    end
    set @fatherid_1 = @fatherid1_1
end

GO