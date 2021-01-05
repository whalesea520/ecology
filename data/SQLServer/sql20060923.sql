alter PROCEDURE HrmResource_Fire
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 text,
 @changecontractid_4 int,
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),  
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @changecontractid_4,
 @infoman_5,
 @oldjobtitleid_7 ,
 @type_n_8 )
UPDATE HrmResource SET 
 enddate = @changedate_2
WHERE
 id = @id_1
GO

alter PROCEDURE HrmResource_Hire
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 text,
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),  
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory
(resourceid,
 changedate,
 changereason,
 infoman,
 oldjobtitleid,
 type_n  )
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @infoman_5,
 @oldjobtitleid_7 ,
 @type_n_8   )
GO


alter PROCEDURE HrmResource_Extend 
(@id_1 int, 
 @changedate_2 char(10), 
 @changeenddate_3 char(10), 
 @changereason_4 text, 
 @changecontractid_5 int, 
 @infoman_6 varchar(255), 
 @oldjobtitleid_7 int, 
 @type_n_8 char(1),
 @status_9 int,
 @flag int output, 
 @msg varchar(60) output) 
AS INSERT INTO HrmStatusHistory 
(resourceid, 
 changedate, 
 changeenddate, 
 changereason, 
 changecontractid, 
 infoman, 
 oldjobtitleid, 
 type_n,
 status) 
VALUES 
(@id_1, 
 @changedate_2, 
 @changeenddate_3, 
 @changereason_4, 
 @changecontractid_5, 
 @infoman_6, 
 @oldjobtitleid_7 , 
 @type_n_8,
 @status_9) 
UPDATE HrmResource SET enddate = @changeenddate_3 WHERE id = @id_1
GO


alter PROCEDURE HrmResource_Redeploy 
(@id_1 int, 
 @changedate_2 char(10), 
 @changereason_4 text, 
 @oldjobtitleid_7 int, 
 @oldjoblevel_8 int, 
 @newjobtitleid_9 int, 
 @newjoblevel_10 int, 
 @infoman_6 varchar(255), 
 @type_n_11 int, 
 @ischangesalary_12 int,
 @flag int output, @msg varchar(60) output) 
AS INSERT INTO HrmStatusHistory 
(resourceid, 
 changedate, 
 changereason, 
 oldjobtitleid, 
 oldjoblevel, 
 newjobtitleid, 
 newjoblevel, 
 infoman, 
 type_n,
 ischangesalary) 
VALUES 
(@id_1, 
 @changedate_2, 
 @changereason_4, 
 @oldjobtitleid_7, 
 @oldjoblevel_8, 
 @newjobtitleid_9, 
 @newjoblevel_10, 
 @infoman_6, 
 @type_n_11,
 @ischangesalary_12)
GO


alter procedure HrmResource_Dismiss
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 text,
 @changecontractid_4 int,
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1), 
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @changecontractid_4,
 @infoman_5,
 @oldjobtitleid_7,
 @type_n_8)
UPDATE HrmResource SET 
 enddate = @changedate_2
WHERE
 id = @id_1
GO


alter PROCEDURE HrmResource_Retire
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 text,
 @changecontractid_4 int,
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @changecontractid_4,
 @infoman_5,
 @oldjobtitleid_7,
 @type_n_8)
UPDATE HrmResource SET
 enddate = @changedate_2
WHERE
 id = @id_1
GO


alter PROCEDURE HrmResource_Rehire
(@id_1 int,
 @changedate_2 char(10),
 @changeenddate_3 char(10),
 @changereason_4 text,
 @changecontractid_5 int,
 @infoman_6 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n
)
VALUES
(@id_1, 
 @changedate_2,
 @changeenddate_3,
 @changereason_4,
 @changecontractid_5,
 @infoman_6,
 @oldjobtitleid_7 ,
 @type_n_8
 )
UPDATE HrmResource SET 
 startdate = @changedate_2,
 enddate = @changeenddate_3
WHERE
 id = @id_1
GO
