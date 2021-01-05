DROP TABLE HrmArrangeShiftSet
GO
CREATE TABLE HrmArrangeShiftSet
(
id int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
sharetype int NULL,
level_from tinyint NULL,
level_to tinyint NULL,
relatedId int NULL
) 
GO