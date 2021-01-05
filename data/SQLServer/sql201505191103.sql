alter TABLE workflow_groupdetail add virtualid VARCHAR(10)
GO

ALTER PROCEDURE [workflow_groupdetail_Insert] (@groupid_1 int, @type_2 int, @objid_3 int, @level_4 int, @level2_5 int,@conditions text,@conditioncn text,@orders varchar(4000) ,@signorder char(1),@IsCoadjutant char(1),@signtype char(1),@issyscoadjutant char(1),@issubmitdesc char(1),@ispending char(1),@isforward char(1),@ismodify char(1),@coadjutants varchar(4000),@coadjutantcn varchar(4000),@virtualid varchar(10), @flag integer OUTPUT , @msg varchar(4000) OUTPUT) AS
INSERT INTO workflow_groupdetail (groupid, TYPE, objid, level_n, level2_n,conditions,conditioncn,orders,signorder,IsCoadjutant,signtype,issyscoadjutant,issubmitdesc,ispending,isforward,ismodify,coadjutants,coadjutantcn,virtualid)
VALUES (@groupid_1,
        @type_2,
        @objid_3,
        @level_4,
        @level2_5,
        @conditions,
        @conditioncn,
        @orders,
        @signorder,
        @IsCoadjutant,
        @signtype,
        @issyscoadjutant,
        @issubmitdesc,
        @ispending,
        @isforward,
        @ismodify,
        @coadjutants,
        @coadjutantcn,
        @virtualid)
SELECT max(id)
FROM workflow_groupdetail
SET @flag = 0
SET @msg = 'ok' 
GO