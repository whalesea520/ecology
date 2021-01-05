create table HrmResource_online( 
    user_id       int,
    date_time     varchar(20),
    online_flag   char(1)
)
go
CREATE NONCLUSTERED INDEX IX_Hrm_Online_TUSERID 
ON HrmResource_online(user_id)  
WITH FILLFACTOR = 30 
GO
CREATE NONCLUSTERED INDEX IX_Hrm_Online_Tflag 
ON HrmResource_online(online_flag)  
WITH FILLFACTOR = 30 
GO
