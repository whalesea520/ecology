SELECT * INTO HrmResourceSysBak FROM HrmResource
GO
ALTER TABLE HrmResource 
ADD jobtitlename VARCHAR(1000)
GO
ALTER TABLE HrmResource 
ADD jobactivityid INT
GO
UPDATE hrmresource SET jobtitlename=(SELECT jobtitlename FROM HrmJobTitlesSysBak WHERE HrmResource.jobtitle=HrmJobTitlesSysBak.id)
GO
UPDATE hrmresource SET jobactivityid=(SELECT jobactivityid FROM HrmJobTitlesSysBak WHERE HrmResource.jobtitle=HrmJobTitlesSysBak.id)
GO
delete FROM HrmJobTitles
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
GO    
UPDATE hrmresource SET jobtitle=(SELECT id FROM HrmJobTitles WHERE HrmResource.jobtitlename=HrmJobTitles.jobtitlename AND HrmResource.jobactivityid=HrmJobTitles.jobactivityid)
GO
ALTER TABLE HrmResource 
DROP COLUMN jobtitlename
GO
ALTER TABLE HrmResource 
DROP COLUMN jobactivityid
GO   
UPDATE HrmGroupShare SET seclevelto = 100 WHERE sharetype IN(2,3,4,5) OR sharetype<0
GO
