UPDATE Prj_T_ShareInfo set jobtitleid = 0 where jobtitleid is null 
/
UPDATE Prj_T_ShareInfo set joblevel = 0 where joblevel is null
/
UPDATE Prj_T_ShareInfo set scopeid = '0' where scopeid is null
/
UPDATE Prj_ShareInfo set jobtitleid = 0 where jobtitleid is null
/
UPDATE Prj_ShareInfo set joblevel = 0 where joblevel is null
/
UPDATE Prj_ShareInfo set scopeid = '0' where scopeid is null
/
UPDATE prj_typecreatelist set jobtitleid = 0 where jobtitleid is null
/
UPDATE prj_typecreatelist set joblevel = 0 where joblevel is null
/
UPDATE prj_typecreatelist set scopeid = '0' where scopeid is null
/
UPDATE Prj_TaskShareInfo set jobtitleid = 0 where jobtitleid is null
/
UPDATE Prj_TaskShareInfo set joblevel = 0 where joblevel is null
/
UPDATE Prj_TaskShareInfo set scopeid = '0' where scopeid is null
/
UPDATE CptAssortmentShare set seclevelMax = 100 where seclevelMax is null
/
UPDATE CptAssortmentShare set jobtitleid = 0 where jobtitleid is null
/
UPDATE CptAssortmentShare set joblevel = 0 where joblevel is null
/
UPDATE CptAssortmentShare set scopeid = '0' where scopeid is null
/
UPDATE CptCapitalShareInfo set seclevelMax = 100 where seclevelMax is null
/
UPDATE CptCapitalShareInfo set jobtitleid = 0 where jobtitleid is null
/
UPDATE CptCapitalShareInfo set joblevel = 0 where joblevel is null
/
UPDATE CptCapitalShareInfo set scopeid = '0' where scopeid is null
/