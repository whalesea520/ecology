create table WorkPlanSet(
id int primary key not null,
timeRangeStart int,
timeRangeEnd int,
amAndPm int,
amStart VARCHAR(8),
amEnd VARCHAR(8),
pmStart VARCHAR(8),
pmEnd VARCHAR(8),
dataSplit int,
showPerson int,
showInfo VARCHAR(50),
tooltipInfo varchar(50),
dataRule int
)
/
INSERT into WorkPlanSet(id,timeRangeStart,timeRangeEnd,amAndPm,amStart,amEnd,pmStart,pmEnd,dataSplit,showPerson,showInfo,tooltipInfo,dataRule)
values(1,0,23,0,'','','','',0,0,'1^0^1^0','1^1^1^1^1^0^1',2)
/