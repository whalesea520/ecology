/* 删除一个用户-资源访问许可（仅限存储过程调用） */
alter PROCEDURE Doc_DirAccessPermission_Delete(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @operationcode_1 int)  AS

declare @count_1 int

if @operationcode_1 = 0 begin
  set @count_1 = (select top 1 createdoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if not (@count_1 is null) and (@count_1 > 0) begin
    update DirAccessPermission set createdoc = (@count_1-1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  end
end
else if @operationcode_1 = 1 begin
  set @count_1 = (select top 1 createdir from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if not (@count_1 is null) and (@count_1 > 0) begin
    update DirAccessPermission set createdir = (@count_1-1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  end
end
else if @operationcode_1 = 2 begin
  set @count_1 = (select top 1 movedoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if not (@count_1 is null) and (@count_1 > 0) begin
    update DirAccessPermission set movedoc = (@count_1-1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  end
end
else if @operationcode_1 = 3 begin
  set @count_1 = (select top 1  copydoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if not (@count_1 is null) and (@count_1 > 0) begin
    update DirAccessPermission set copydoc = (@count_1-1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  end
end


GO

/* 增加一个用户-资源访问许可（仅限存储过程调用） */
alter PROCEDURE Doc_DirAccessPermission_Insert(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @operationcode_1 int)  AS

declare @count_1 int

if @operationcode_1 = 0 begin
  set @count_1 = (select top 1 createdoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if @count_1 is null
      insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(@dirid_1, @dirtype_1, @userid_1, @usertype_1, 1, 0, 0, 0)
  else
      update DirAccessPermission set createdoc = (@count_1+1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
end
else if @operationcode_1 = 1 begin
    set @count_1 = (select top 1 createdir from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    if @count_1 is null
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(@dirid_1, @dirtype_1, @userid_1, @usertype_1, 0, 1, 0, 0)
    else
        update DirAccessPermission set createdir = (@count_1+1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
end
else if @operationcode_1 = 2 begin
    set @count_1 = (select top 1 movedoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    if @count_1 is null
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(@dirid_1, @dirtype_1, @userid_1, @usertype_1, 0, 0, 1, 0)
    else
        update DirAccessPermission set movedoc = (@count_1+1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
end
else if @operationcode_1 = 3 begin
    set  @count_1 = (select top 1 copydoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    if @count_1 is null
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(@dirid_1, @dirtype_1, @userid_1, @usertype_1, 0, 0, 0, 1)
    else
        update DirAccessPermission set copydoc = (@count_1+1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
end


GO

