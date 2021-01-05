CREATE OR REPLACE PROCEDURE workflow_groupdetail_SByGroup 
(id_1 	integer, 	 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS begin open thecursor for 
SELECT id, groupid, type, objid,deptField,subcompanyField, level_n, level2_n, conditions, conditioncn, orders, signorder,case when signorder in(3,4) then 10000+signorder else 1+orders  end as sort,IsCoadjutant,signtype,issyscoadjutant,issubmitdesc,ispending,isforward,ismodify,coadjutants,coadjutantcn from workflow_groupdetail where groupid=id_1 order by sort,id;
end;
/
