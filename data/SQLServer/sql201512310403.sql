update HistoryMsg set datetime = CONVERT(VARCHAR(100), datetime, 120) 
where datetime is not null and ISNUMERIC(datetime) = 1
GO