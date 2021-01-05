update outerdatawfset set outerdetailwheres = replace(outerdetailwheres, ',', '$@|@$')
where outerdetailwheres is not null 
and outerdetailwheres like '%,%' 
and outerdetailwheres not like '%$@|@$%'
GO