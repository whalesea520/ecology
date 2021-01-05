create index hpBaseElement_id on hpBaseElement(id)
GO
create index hpFieldElement_eid on hpFieldElement(elementid)
GO
create index hpFieldElement_eid_ordernum on hpFieldElement(elementid,ordernum)
GO
create index hpWhereElement_eid on hpFieldElement(elementid)
GO
create index hpSqlElement_eid on hpSqlElement(elementid)
GO
create index hpextelement_id on hpextelement(id)
GO
create index hpElement_hpid on hpElement(hpid)
GO
create index hpElementSettingDetailt_eid_userid_usertype on hpElementSettingDetail(eid,userid,usertype)
GO
create index hpFieldLength_eid_efieldid_userid_usertype on hpFieldLength(eid,efieldid,userid,usertype)
GO
create index hplayout_hpid_userid_usertype on hplayout(hpid,userid,usertype)
GO