CREATE TABLE expandBaseRightInfo(
	id int IDENTITY(1,1) NOT NULL,
	modeid int NOT NULL,
	expandid int NOT NULL,
	righttype int NOT NULL,
	relatedid int NULL,
	showlevel int NULL,
	showlevel2 int NULL,
	modifytime varchar(32) NULL,
	rolelevel int NULL,
	conditiontype int NULL,
	conditionsql nvarchar(4000) NULL,
	conditiontext nvarchar(4000) NULL,
 CONSTRAINT PK_expandBaseRightInfo PRIMARY KEY CLUSTERED 
(
	id ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE expandBaseRightExpressions(
	id int IDENTITY(1,1) NOT NULL,
	rightid int NOT NULL,
	relation int NOT NULL,
	expids nvarchar(1000) NULL,
	expbaseid int NULL,
 CONSTRAINT PK_expandBaseRightExpressions PRIMARY KEY CLUSTERED 
(
	id ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE expandBaseRightExpressionBase(
	id int IDENTITY(1,1) NOT NULL,
	fieldid int NULL,
	fieldname varchar(100) NULL,
	fieldlabel varchar(200) NULL,
	rightid int NULL,
	compareopion int NULL,
	compareopionlabel varchar(200) NULL,
	htmltype varchar(100) NULL,
	fieldtype varchar(100) NULL,
	fielddbtype varchar(1000) NULL,
	fieldvalue varchar(1000) NULL,
	fieldtext varchar(1000) NULL,
	relationtype int NULL,
	valetype int NULL,
 CONSTRAINT PK_expandBaseRightExpressionBase PRIMARY KEY CLUSTERED 
(
	id ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

insert into expandBaseRightInfo 
       (modeid, expandid, righttype, relatedid, showlevel, modifytime)
select modeid, id, 5, 0, 10, CONVERT(VARCHAR(10),GETDATE(),120)
  from mode_pageexpand where modeid > 0  and isnull(issystemflag,'') not in (1,2,3,4,5,6,8,10,100,101,102,103,104) 
GO
		
			
delete from HtmlLabelIndex where id=125969 
GO
delete from HtmlLabelInfo where indexid=125969 
GO
INSERT INTO HtmlLabelIndex values(125969,'继承建模编辑权限') 
GO
INSERT INTO HtmlLabelInfo VALUES(125969,'继承建模编辑权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125969,'Inheritance modeling edit permissions',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125969,'继承建模编辑权限',9) 
GO

CREATE PROCEDURE _update_expand_condition
AS
DECLARE
	@id int,
	@condition varchar(4000),
	@condition2 varchar(4000),
	@conditioncn varchar(4000)
BEGIN
	DECLARE ids CURSOR FOR
		SELECT id FROM mode_pageexpand 
		 where (len(ltrim(cast(showcondition as varchar) )) > 0 or len(ltrim(cast(showcondition2 as varchar) )) > 0)
		   and isbatch <> 1
          and isnull(issystemflag,'') not in (1,2,3,4,5,6,8,10,100,101,102,103,104)
		
	BEGIN TRANSACTION
		open ids
		FETCH NEXT FROM ids INTO @id
		WHILE @@FETCH_STATUS = 0
		BEGIN
			select @condition=LTRIM(cast(ISNULL(showcondition,'') as varchar(4000))),
				   @condition2=LTRIM(cast(ISNULL(showcondition2,'') as varchar(4000))),
				   @conditioncn=LTRIM(cast(ISNULL(showconditioncn,'')as varchar(4000))) 
			  from mode_pageexpand
			 where id = @id
			IF LEN(@condition) = 0 BEGIN 
				IF LEN(@condition2) > 0 BEGIN
					update expandBaseRightInfo 
					   set conditionsql = @condition2,
					       conditiontype = 2
					 where expandid = @id
				END
			END
			ELSE BEGIN
				IF LEN(@condition2) = 0 BEGIN
					update expandBaseRightInfo
					   set conditionsql = @condition,
					       conditiontype = 2
					 where expandid = @id
				END
				ELSE BEGIN
					update expandBaseRightInfo 
					   set conditionsql = '(' + @condition2 + ') and (' + @condition + ')',
					       conditiontype = 2
					 where expandid = @id
				END
			END
			fetch next from ids into @id
		END
		CLOSE ids
		DEALLOCATE ids
	COMMIT TRANSACTION
END
GO

EXECUTE _update_expand_condition
GO

DROP PROCEDURE _update_expand_condition
GO

delete from HtmlLabelIndex where id=126450 
GO
delete from HtmlLabelInfo where indexid=126450 
GO
INSERT INTO HtmlLabelIndex values(126450,'扩展用途为查询列表设置条件不生效。') 
GO
INSERT INTO HtmlLabelInfo VALUES(126450,'扩展用途为查询列表设置条件不生效。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126450,'The condition does not take effect for search.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126450,'擴展用途為查詢列表設置條件不生效。',9) 
GO

delete from HtmlLabelIndex where id=126564 
GO
delete from HtmlLabelInfo where indexid=126564 
GO
INSERT INTO HtmlLabelIndex values(126564,'扩展权限') 
GO
INSERT INTO HtmlLabelInfo VALUES(126564,'扩展权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126564,'Extended rights',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126564,'擴展權限',9) 
GO

delete from HtmlLabelIndex where id=126574 
GO
delete from HtmlLabelInfo where indexid=126574 
GO
INSERT INTO HtmlLabelIndex values(126574,'扩展用途为查询列表继承建模编辑权限不生效。') 
GO
INSERT INTO HtmlLabelInfo VALUES(126574,'扩展用途为查询列表继承建模编辑权限不生效。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126574,'Inheritance modeling edit permissions do not take effect for the search.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126574,'擴展用途為查詢列表繼承建模編輯權限不生效。',9) 
GO
