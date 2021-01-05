alter table WX_SCANLOG drop column receiveusers
/
alter table WX_SCANLOG drop column content
/
alter table WX_SCANLOG drop column resultcontent
/

alter table WX_SCANLOG add receiveusers clob
/
alter table WX_SCANLOG add content clob
/
alter table WX_SCANLOG add resultcontent clob
/
