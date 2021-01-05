update DocImageFile set docfiletype='7' where imagefilename like '%.docx' and docfiletype='2'
GO
update DocImageFile set docfiletype='8'  where imagefilename like '%.xlsx' and docfiletype='2'
GO
update DocImageFile set docfiletype='9'  where imagefilename like '%.pptx' and docfiletype='2'
GO