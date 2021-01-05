
UPDATE DocSecCategoryDocProperty SET mustInput = 0 where type in (10,12)
GO
UPDATE DocSecCategoryDocProperty SET mustInput = -1 where type in (1,2,3,4,5,6,7,8,9,11,13,14,15,16,17,18,19,20,21)
GO
