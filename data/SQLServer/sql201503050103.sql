ALTER TABLE FnaSystemSet ADD recursiveSubOrg INT
GO
update FnaSystemSet set recursiveSubOrg=0
GO