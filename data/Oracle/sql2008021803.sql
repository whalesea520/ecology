alter table cowork_items 
add coworkmanager integer Null
/

update cowork_items
set coworkmanager=creater
/
