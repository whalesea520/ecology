alter table mailresource add(tmpsendto clob)
/
update mailresource set tmpsendto = sendto
/
alter table mailresource rename column sendto to sendto_bak
/
alter table mailresource rename column tmpsendto to sendto
/

alter table mailresource add(tmpsendcc clob)
/
update mailresource set tmpsendcc = sendcc
/
alter table mailresource rename column sendcc to sendcc_bak
/
alter table mailresource rename column tmpsendcc to sendcc
/

alter table mailresource add(tmpsendbcc clob)
/
update mailresource set tmpsendbcc = sendbcc
/
alter table mailresource rename column sendbcc to tmpsendbcc_bak
/
alter table mailresource rename column tmpsendbcc to sendbcc
/