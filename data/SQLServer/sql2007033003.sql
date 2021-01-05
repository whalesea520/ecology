ALTER TABLE DocDetail ADD  docCreaterType char(1) null
GO
ALTER TABLE DocDetail ADD  docLastModUserType char(1) null
GO
ALTER TABLE DocDetail ADD  docApproveUserType char(1) null
GO
ALTER TABLE DocDetail ADD  docValidUserType char(1) null
GO
ALTER TABLE DocDetail ADD  docInvalUserType char(1) null
GO
ALTER TABLE DocDetail ADD  docArchiveUserType char(1) null
GO
ALTER TABLE DocDetail ADD  docCancelUserType char(1) null
GO
ALTER TABLE DocDetail ADD  docPubUserType char(1) null
GO
ALTER TABLE DocDetail ADD  docReopenUserType char(1) null
GO
ALTER TABLE DocDetail ADD  ownerType char(1) null
GO
UPDATE DocDetail  SET docCreaterType=usertype
GO
UPDATE DocDetail  SET docLastModUserType=userType
GO
UPDATE DocDetail  SET docApproveUserType=userType
GO
UPDATE DocDetail  SET docValidUserType=userType
GO
UPDATE DocDetail  SET docInvalUserType=userType
GO
UPDATE DocDetail  SET docArchiveUserType=userType
GO
UPDATE DocDetail  SET docCancelUserType=userType
GO
UPDATE DocDetail  SET docPubUserType=userType
GO
UPDATE DocDetail  SET docReopenUserType=userType
GO
UPDATE DocDetail  SET ownerType=userType
GO