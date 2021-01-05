update workplanshareset set sharelevel=1
/
ALTER table WorkPlanShare add fromuser int
/
alter table WorkPlanShareDetail add fromuser int 
/
CREATE TABLE workplansharechange (
workid int  ,
fromuser int  
)
/