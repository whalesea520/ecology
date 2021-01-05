Create PROCEDURE outter_encryptclassIni
AS
BEGIN
declare  @str1 varchar(1000)
declare   @str2 varchar(1000)
declare  @sysid varchar(1000) 
declare   @id int
DECLARE  cur CURSOR FOR SELECT sysid,encryptclass,encryptmethod FROM outter_sys
OPEN cur  FETCH NEXT FROM cur INTO @sysid,@str1,@str2

WHILE @@FETCH_STATUS = 0
    BEGIN 
       if @str1 <>'' 
         BEGIN
          insert into outter_encryptclass(encryptclass,encryptmethod) values(@str1,@str2);
          select @id=max(id) from outter_encryptclass;
          update outter_sys set  encryptclass='',encryptmethod='',encryptclassId=@id where sysid=@sysid;
         END                
         FETCH NEXT FROM cur INTO @sysid,@str1,@str2
     END
  CLOSE cur 
  DEALLOCATE cur

END
GO
exec  outter_encryptclassIni
GO