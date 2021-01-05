alter table docmailmould add tempdata clob
/
update docmailmould set tempdata = mouldtext 
/
alter table docmailmould drop column mouldtext
/
alter table docmailmould rename column tempdata to mouldtext   
/