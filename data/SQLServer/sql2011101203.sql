update DocSecCategoryDocProperty set mustinput=-1 where (mustinput=0 or mustinput=1) and iscustom=0 and type not in (10,12,22,24,25)
GO
