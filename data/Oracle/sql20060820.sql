create index hpBaseElement_id on hpBaseElement(id)
/
create index hpFieldElement_eid on hpFieldElement(elementid)
/
create index hpFieldElement_eid_ordernum on hpFieldElement(elementid,ordernum)
/
create index hpWhereElement_eid on hpWhereElement(elementid)
/
create index hpSqlElement_eid on hpSqlElement(elementid)
/
create index hpElement_hpid on hpElement(hpid)
/
create index hpSettingDetail_euu on hpElementSettingDetail(eid,userid,usertype)
/
create index hpFieldLength_eeuu on hpFieldLength(eid,efieldid,userid,usertype)
/
create index hplayout_hpid_userid_usertype on hplayout(hpid,userid,usertype)
/