update HistoryMsg set datetime = TO_CHAR(TO_NUMBER(datetime) / (1000 * 60 * 60 * 24) +  
TO_DATE('1970-01-01 08:00:00', 'YYYY-MM-DD HH:MI:SS'), 'YYYY-MM-DD HH:MI:SS') 
where datetime is not null and translate(replace(datetime,'0',''), '0123456789', '$') is null
/