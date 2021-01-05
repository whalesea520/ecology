CREATE OR REPLACE TRIGGER delTargetToMain    
AFTER DELETE ON HrmPerformanceTargetDetail 
for   each row   
BEGIN   
      update hrmPerformanceTargetType set num=num-1 where id=:new.targetId;     
END;   
/

CREATE OR REPLACE TRIGGER AddTargetToMain    
AFTER INSERT ON HrmPerformanceTargetDetail 
for   each row   
BEGIN   
      update hrmPerformanceTargetType set num=num+1 where id=:new.targetId;     
END;   
/