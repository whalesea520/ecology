alter PROCEDURE docDetailLog_QueryByDate
	(@fromdate_1 	[char](10) ,
	 @todate_1 	[char](10) ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
SELECT docid, SUM(readCount) 
AS COUNT FROM docReadTag
where docid in (select id from docdetail) and 
docid in (SELECT docid FROM DocDetailLog WHERE (operatedate >= @fromdate_1) 
AND (operatedate <= @todate_1))GROUP BY docid ORDER BY COUNT DESC
GO