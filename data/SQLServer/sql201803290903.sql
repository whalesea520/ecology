update meeting set repeatbegindate=begindate where repeatbegindate is null
GO
update meeting set repeatenddate=enddate where repeatenddate is null
GO