update workplanshareset set sharelevel=1
GO
ALTER table WorkPlanShare add fromuser int
GO
alter table WorkPlanShareDetail add fromuser int 
GO
CREATE TABLE workplansharechange (
workid int  ,
fromuser int  
)
GO