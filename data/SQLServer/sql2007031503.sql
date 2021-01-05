CREATE TABLE DocSecCategoryCusSearch (
	id int IDENTITY(1,1) NOT NULL,
	secCategoryId int NULL,
	docPropertyId int NULL,
	viewindex int NULL,
	visible int NULL,
	DocSecCategoryTemplateId int NULL
)
GO

ALTER TABLE DocSecCategory ADD
	useCustomSearch int NULL
GO


ALTER TABLE DocSecCategoryTemplate ADD
	useCustomSearch int NULL
GO
