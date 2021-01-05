alter TABLE workflow_groupdetail add virtualid VARCHAR2(10)
/

CREATE OR REPLACE PROCEDURE workflow_groupdetail_Insert (groupid_1 integer, type_2 integer, objid_3 integer, level_4 integer, level2_5 integer, conditions_6 varchar2, conditioncn_7 varchar2, orders_8 number, signorder_9 char, IsCoadjutant_10 char, signtype_11 char, issyscoadjutant_12 char, issubmitdesc_13 char, ispending_14 char, isforward_15 char, ismodify_16 char, coadjutants_17 varchar2, coadjutantcn_18 varchar2,virtualid_19 varchar2, flag OUT integer , msg OUT varchar2 , thecursor IN OUT cursor_define.weavercursor) AS BEGIN
INSERT INTO workflow_groupdetail (groupid, TYPE, objid, level_n, level2_n,conditions,conditioncn,orders,signorder,IsCoadjutant,signtype,issyscoadjutant,issubmitdesc,ispending,isforward,ismodify,coadjutants,coadjutantcn,virtualid)
VALUES (groupid_1,
        type_2,
        objid_3,
        level_4,
        level2_5,
        conditions_6,
        conditioncn_7,
        orders_8,
        signorder_9,
        IsCoadjutant_10,
        signtype_11,
        issyscoadjutant_12,
        issubmitdesc_13,
        ispending_14,
        isforward_15,
        ismodify_16,
        coadjutants_17,
        coadjutantcn_18,
        virtualid_19); OPEN thecursor
FOR
SELECT max(id)
FROM workflow_groupdetail; END;
/