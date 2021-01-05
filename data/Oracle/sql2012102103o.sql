CREATE OR REPLACE TRIGGER Tri_I_SubComKPICheckFlow    
AFTER INSERT ON HrmSubCompany 
for   each row   
BEGIN   
     INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (:new.id,'1');  
END; 
/

CREATE OR REPLACE TRIGGER Tri_I_DeptKPICheckFlow    
AFTER INSERT ON HrmDepartment 
for   each row   
BEGIN   
      INSERT INTO HrmPerformanceCheckFlow(objId,objType) VALUES(:new.id,'2');    
      INSERT INTO HrmPerformanceCheckFlow(objId,objType) VALUES(:new.id,'3');     
END;   
/