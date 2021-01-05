DECLARE @id INT
SELECT  @id = MAX(fieldid)+1 FROM hrm_formfield
BEGIN
INSERT INTO hrm_formfield( fieldid ,fielddbtype ,fieldname ,fieldlabel ,fieldhtmltype ,type ,
          fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem ,dmlUrl)
VALUES  ( @id , 'varchar(60)' , 'loginid' , '16126' , '1' , 1 , 1 , '1' , '1' , 1 , -1 , NULL , NULL , NULL , NULL , NULL)
END
GO