ALTER TABLE modeinfo ADD isAddRightByWorkFlow int
/
update modeinfo set isAddRightByWorkFlow=1 where isAddRightByWorkFlow is null
/