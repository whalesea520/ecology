alter table Meeting_Type add catalogpath varchar(255)
GO
alter table meeting add accessorys varchar(2000)
GO

ALTER PROCEDURE Meeting_Type_Insert (@name varchar (255), 
                                      @approver int, 
                                      @desc_n varchar (255),
                                      @subcompanyid int, 
				      @catalogpath varchar (255),
                                      @flag integer output, 
                                      @msg varchar(80) output)  AS 
INSERT INTO Meeting_Type ( name , approver , desc_n ,subcompanyid,catalogpath)  
VALUES( @name, @approver, @desc_n,@subcompanyid,@catalogpath )
set @flag = 1 
set @msg = 'OK!' 

GO

ALTER PROCEDURE Meeting_Type_Update (
                                      @id int , 
                                      @name varchar (255), 
                                      @approver int , 
                                      @desc_n varchar (255),
                                      @subcompanyid int, 
				      @catalogpath varchar (255),
                                      @flag integer output, 
                                      @msg varchar(80) output  )  AS 
    update Meeting_Type   
           set name =@name, 
               approver =@approver, 
               desc_n =@desc_n,
               subcompanyid=@subcompanyid,
	       catalogpath=@catalogpath
            where id=@id 
    set @flag = 1 set @msg = 'OK!' 

GO
