INSERT INTO HrmCompanyVirtual ( companyname , companycode , companydesc ,canceled ,showorder ,virtualType ,virtualtypedesc) VALUES  ( 'lvyi1987' ,'lvyi1987' ,'lvyi1987' ,0 , 0 , 'lvyi1987' ,'lvyi1987' )
GO
DELETE FROM HrmCompanyVirtual WHERE  companyname='lvyi1987' AND companycode = 'lvyi1987' AND companydesc='lvyi1987'
GO
INSERT INTO HrmSubCompanyVirtual( subcompanyname , subcompanycode , subcompanydesc ,supsubcomid ,companyid ,canceled ,showorder ,tlevel ,virtualtypeid , ecology_pinyin_search ) VALUES  ( 'lvyi1987' , 'lvyi1987' ,'lvyi1987' , 0 , 0 , 0 , 0 , 0 , 0 ,  'lvyi1987')
GO
DELETE FROM HrmSubCompanyVirtual WHERE subcompanyname='lvyi1987' AND subcompanycode='lvyi1987' AND subcompanydesc='lvyi1987'
GO
INSERT INTO HrmDepartmentVirtual( departmentname , departmentcode ,departmentmark , supdepid ,allsupdepid ,subcompanyid1 ,canceled ,showorder ,tlevel , ecology_pinyin_search ,virtualtype )
VALUES  ( 'lvyi1987' , 'lvyi1987' ,'lvyi1987' , 0 , '' ,  0 , 0 , 0 , 0 , 'lvyi1987' , 0  )
GO
DELETE FROM HrmDepartmentVirtual WHERE departmentname='lvyi1987' AND departmentcode='lvyi1987' AND departmentmark='lvyi1987'
GO