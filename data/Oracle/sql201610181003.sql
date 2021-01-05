update outerdatawfset set outerdetailwheres = replace(outerdetailwheres, ',', '$@|@$')
where outerdetailwheres is not null 
and instr(outerdetailwheres, ',') > 0 
and instr(outerdetailwheres, '$@|@$') = 0
/