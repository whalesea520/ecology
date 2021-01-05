create table HrmResourceSysBak as select * from HrmResource
/ 
ALTER TABLE HrmResource 
ADD jobtitlename VARCHAR(1000)
/
ALTER TABLE HrmResource 
ADD jobactivityid int
/
UPDATE hrmresource SET jobtitlename=(SELECT jobtitlename FROM HrmJobTitlesSysBak WHERE HrmResource.jobtitle=HrmJobTitlesSysBak.id)
/
UPDATE hrmresource SET jobactivityid=(SELECT jobactivityid FROM HrmJobTitlesSysBak WHERE HrmResource.jobtitle=HrmJobTitlesSysBak.id)
/
DELETE FROM HrmJobTitles
WHERE   jobtitlename IN ( SELECT  a.jobtitlename
                    FROM    HrmJobTitles a
                    WHERE HrmJobTitles.jobactivityid=a.jobactivityid
                    GROUP BY a.jobtitlename,a.jobactivityid
                    HAVING  COUNT(a.jobtitlename) > 1 )
        AND id NOT IN ( SELECT  MIN(a.id)
                        FROM    HrmJobTitles a
                        WHERE HrmJobTitles.jobactivityid=a.jobactivityid
                        GROUP BY a.jobtitlename,a.jobactivityid
                        HAVING  COUNT(a.jobtitlename) > 1 )      
/    
UPDATE hrmresource SET jobtitle=(SELECT id FROM HrmJobTitles WHERE HrmResource.jobtitlename=HrmJobTitles.jobtitlename and HrmResource.jobactivityid=HrmJobTitles.jobactivityid)
/
ALTER TABLE HrmResource 
DROP COLUMN jobtitlename
/   
ALTER TABLE HrmResource 
DROP COLUMN jobactivityid
/
UPDATE HrmGroupShare SET seclevelto = 100 WHERE sharetype IN(2,3,4,5) OR sharetype<0
/
