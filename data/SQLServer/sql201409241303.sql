CREATE PROCEDURE HrmSubCompanyVirtual_Select
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(80) OUTPUT
AS 
    SELECT  *
    FROM    HrmSubCompanyVirtual
    SET @flag = 0
    SET @msg = '�����ɹ����'
GO
CREATE PROCEDURE HrmCompanyVirtual_Select
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(80) OUTPUT
AS 
    SELECT  *
    FROM    HrmCompanyVirtual
    SET @flag = 0
    SET @msg = '�����ɹ����'

GO   
CREATE PROCEDURE HrmDepartmentVirtual_Select
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(80) OUTPUT
AS 
    SELECT  *
    FROM    HrmDepartmentVirtual
    SET @flag = 0
    SET @msg = '�����ɹ����'
GO