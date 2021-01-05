CREATE OR REPLACE PROCEDURE workflow_groupdetail_SByGroup (id_1 integer, flag OUT integer , msg 
OUT varchar2, thecursor IN OUT cursor_define.weavercursor) AS BEGIN OPEN thecursor
FOR
SELECT id, groupid, TYPE, objid,
                          deptField,
                          subcompanyField,
                          level_n,
                          level2_n,
                          conditions,
                          conditioncn,
                          orders,
                          signorder,
                          CASE
                              WHEN signorder in(3,4) THEN 10000+signorder
                              ELSE 1+orders
                          END AS sort,
                          IsCoadjutant,
                          signtype,
                          issyscoadjutant,
                          issubmitdesc,
                          ispending,
                          isforward,
                          ismodify,
                          coadjutants,
                          coadjutantcn,
                          virtualid
FROM workflow_groupdetail
WHERE groupid=id_1
ORDER BY sort,
         id; END;
/