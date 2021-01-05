ALTER TABLE Prj_TaskProcess  alter COLUMN realmandays DECIMAL(15,2)
GO
ALTER TABLE Prj_TaskProcess  alter COLUMN workday DECIMAL(15,2)
GO
ALTER TABLE Prj_TaskProcess ADD begintime VARCHAR(10)
GO
ALTER TABLE Prj_TaskProcess ADD endtime VARCHAR(10)
GO
ALTER TABLE Prj_TaskProcess ADD actualbegintime VARCHAR(10)
GO
ALTER TABLE Prj_TaskProcess ADD actualendtime VARCHAR(10)
GO
UPDATE Prj_TaskProcess SET begintime ='00:00',endtime='23:59',actualbegintime='00:00',actualendtime='23:59'
GO