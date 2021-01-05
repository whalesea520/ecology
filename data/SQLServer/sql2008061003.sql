ALTER TABLE workflow_base ADD  titleFieldId integer null
GO
ALTER TABLE workflow_base ADD  keywordFieldId integer null
GO

CREATE TABLE Workflow_Keyword(
	id int identity (1, 1) NOT NULL ,
	keywordName varchar(60) NULL ,
	keywordDesc varchar(200) NULL ,
	parentId int NULL ,
	isLast char(1) NULL ,
	isKeyword char(1) NULL ,
	showOrder decimal(6,2) NULL 
)
GO


insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('综合经济','综合经济',-1,'0','0',1.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('工交、能源、邮电','工交、能源、邮电',-1,'0','0',2.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('旅游、城乡建设、环保','旅游、城乡建设、环保',-1,'0','0',3.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('农业、林业、水利、气象','农业、林业、水利、气象',-1,'0','0',4.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('财政、金融','财政、金融',-1,'0','0',5.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('贸易','贸易',-1,'0','0',6.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('外事','外事',-1,'0','0',7.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('公安、司法、监察','公安、司法、监察',-1,'0','0',8.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('民政、劳动人事','民政、劳动人事',-1,'0','0',9.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('科、教、文、卫、体','科、教、文、卫、体',-1,'0','0',10.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('国防','国防',-1,'0','0',11.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('秘书、行政','秘书、行政',-1,'0','0',12.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('综合党团','综合党团',-1,'0','0',13.00)
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
select '计划','计划',id,'0','1',14.00
  from  Workflow_Keyword
  where keywordName='综合经济'
GO
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
select '规划','规划',id,'1','1',15.00
  from  Workflow_Keyword
  where keywordName='计划'
GO

update Workflow_Keyword set parentId=0 where parentId<0
GO
