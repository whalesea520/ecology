ALTER TABLE modeinfo ADD isAddRightByWorkFlow int
GO
update modeinfo set isAddRightByWorkFlow=1 where isAddRightByWorkFlow is null
GO