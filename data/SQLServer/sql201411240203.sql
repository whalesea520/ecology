UPDATE HrmListValidate SET name = '基本信息' WHERE id = 3
GO
UPDATE HrmListValidate SET name = '自定义子信息' WHERE name='自定义自信息'
GO
UPDATE HrmListValidate SET name = '工资调整明细' WHERE name='工资明细调整'
GO
UPDATE HrmListValidate SET name = '权限明细' WHERE name='统计'
GO
INSERT INTO HrmListValidate( id ,name ,validate_n ,parentid ,TAB_url ,tab_type , tab_index)
VALUES  (36,'照片',1,3,NULL,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 0,'jobactivity',1915,'int',3,24,7,1,1,1,1)
GO