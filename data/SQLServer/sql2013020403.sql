alter table HrmSchedule alter column totaltime char(6)
GO

ALTER PROCEDURE HrmSchedule_Update
(
@id_1 	int, 
@relatedId_2 	int, 
@monstarttime1_3 	char(5), 
@monendtime1_4 	char(5), 
@monstarttime2_5 	char(5), 
@monendtime2_6 	char(5), 
@tuestarttime1_7 	char(5), 
@tueendtime1_8 	char(5), 
@tuestarttime2_9 	char(5), 
@tueendtime2_10 	char(5), 
@wedstarttime1_11 	char(5), 
@wedendtime1_12 	char(5), 
@wedstarttime2_13 	char(5), 
@wedendtime2_14 	char(5), 
@thustarttime1_15 	char(5), 
@thuendtime1_16 	char(5), 
@thustarttime2_17 	char(5), 
@thuendtime2_18 	char(5), 
@fristarttime1_19 	char(5), 
@friendtime1_20 	char(5), 
@fristarttime2_21 	char(5), 
@friendtime2_22 	char(5), 
@satstarttime1_23 	char(5), 
@satendtime1_24 	char(5), 
@satstarttime2_25 	char(5), 
@satendtime2_26 	char(5), 
@sunstarttime1_27 	char(5), 
@sunendtime1_28 	char(5), 
@sunstarttime2_29 	char(5), 
@sunendtime2_30 	char(5), 
@totaltime_31    char(6), 
@validedatefrom_32 	char(10), 
@validedateto_33 	char(10), 
@scheduleType_34 	char, 
@flag        integer output, 
@msg         varchar(80) output
) 
AS 
UPDATE HrmSchedule SET relatedId= @relatedId_2, monstarttime1= @monstarttime1_3, monendtime1	 = @monendtime1_4, monstarttime2= @monstarttime2_5, monendtime2	 = @monendtime2_6, tuestarttime1= @tuestarttime1_7, tueendtime1	 = @tueendtime1_8, tuestarttime2= @tuestarttime2_9, tueendtime2	 = @tueendtime2_10, wedstarttime1= @wedstarttime1_11, wedendtime1	 = @wedendtime1_12, wedstarttime2= @wedstarttime2_13, wedendtime2	 = @wedendtime2_14, thustarttime1= @thustarttime1_15, thuendtime1	 = @thuendtime1_16, thustarttime2= @thustarttime2_17, thuendtime2	 = @thuendtime2_18, fristarttime1= @fristarttime1_19, friendtime1	 = @friendtime1_20, fristarttime2= @fristarttime2_21, friendtime2	 = @friendtime2_22, satstarttime1= @satstarttime1_23, satendtime1	 = @satendtime1_24, satstarttime2= @satstarttime2_25, satendtime2	 = @satendtime2_26, sunstarttime1= @sunstarttime1_27, sunendtime1	 = @sunendtime1_28, sunstarttime2= @sunstarttime2_29, sunendtime2	 = @sunendtime2_30, totaltime    = @totaltime_31, validedatefrom= @validedatefrom_32, validedateto= @validedateto_33 , scheduleType= @scheduleType_34 
WHERE ( id	 = @id_1)

GO