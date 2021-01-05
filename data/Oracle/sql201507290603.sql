DECLARE fieldidnext integer;
begin
select MAX(fieldid)+1 into fieldidnext FROM hrm_formfield;
INSERT INTO hrm_formfield( fieldid ,fielddbtype ,fieldname ,fieldlabel ,fieldhtmltype ,type ,
          fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem ,dmlUrl)
VALUES  ( fieldidnext , 'varchar(60)' , 'loginid' , '16126' , '1' , 1 , 1 , '1' , '1' , 1 , -1 , NULL , NULL , NULL , NULL , NULL);
END;
/