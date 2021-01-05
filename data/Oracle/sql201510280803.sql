ALTER TABLE Prj_TaskModifyLog MODIFY begindate null
/
ALTER TABLE prj_taskmodifylog MODIFY enddate null
/
update Prj_TaskModifyLog set begindate = '' where begindate='x'
/
update Prj_TaskModifyLog set enddate = '' where enddate='-'
/