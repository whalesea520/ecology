drop table HrmOtherSettings
GO
create table HrmOtherSettings(remindperiod char(4),
                              valid char(1),
                              birthremindperiod char(4), 
                              birthvalid char(1),
                              congratulation varchar(50),
                              birthremindmode char(1))
GO
                                 
insert HrmOtherSettings values('30','1','3','1', '×£$ÉúÈÕ¿ìÀÖ', '1')
GO

create table HrmRemindHistory(type int,
                              reminddate char(10),
                              remindedresourceid int)    
GO
