alter PROCEDURE SystemRights_Select 
(@rightdesc_1 varchar(100) , 
 @flag integer output , 
 @msg varchar(80) output 
)
AS 

select * from SystemRights where rightdesc like @rightdesc_1 order by id desc  
GO



alter PROCEDURE SystemRights_Insert 
 ( 
 @rightdesc_2 	varchar(200), 
 @righttype_3 	char(1), 
 @flag integer output , 
 @msg varchar(80) output)  
 AS 
 declare @maxid int
 select @maxid = max(id) + 1 from SystemRights 

 INSERT INTO SystemRights ( id , rightdesc, righttype)  VALUES (  @maxid , @rightdesc_2, @righttype_3)  
 
 select max(id) from SystemRights 
GO



alter PROCEDURE SystemRightDetail_Select 
(@rightdetailname_1 varchar(100) , 
 @flag integer output , 
 @msg varchar(80) output )

AS 

select * from SystemRightDetail where rightdetailname like @rightdetailname_1 order by rightid desc , id desc
GO

alter PROCEDURE SystemRightDetail_Insert 
(@rightdetailname_1 	varchar(100), 
 @rightdetail_2 	varchar(100), 
 @rightid_3 	int, 
 @flag integer output , 
 @msg varchar(80) output)  
AS 
declare @maxid int
select @maxid = max(id) + 1 from SystemRightDetail 

INSERT INTO SystemRightDetail ( id, rightdetailname, rightdetail, rightid)  VALUES ( @maxid , @rightdetailname_1, @rightdetail_2, @rightid_3) 
GO


update HtmlLabelInfo set labelname = '¹Ø¼ü×Ö' where indexid = 2005 and  languageid = 7
GO

update HtmlLabelInfo set labelname = '¹Ø¼ü×Ö' where indexid = 2095 and  languageid = 7
GO

