UPDATE WorkPlan 
SET description = REPLACE(description, chr(10), '<br>') 
WHERE description LIKE '%'||chr(10)||'%'
/

UPDATE WorkPlan 
SET description = REPLACE(description, chr(13), '') 
WHERE description LIKE '%'||chr(13)||'%'
/
