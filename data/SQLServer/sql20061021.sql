drop index hpFieldElement.hpWhereElement_eid
GO

drop index hpextelement.hpextelement_id_clu
GO

create index hpWhereElement_eid on hpWhereElement(elementid)
GO
