ALTER TABLE DocDetail ADD  docCreaterType char(1) null
/
ALTER TABLE DocDetail ADD  docLastModUserType char(1) null
/
ALTER TABLE DocDetail ADD  docApproveUserType char(1) null
/
ALTER TABLE DocDetail ADD  docValidUserType char(1) null
/
ALTER TABLE DocDetail ADD  docInvalUserType char(1) null
/
ALTER TABLE DocDetail ADD  docArchiveUserType char(1) null
/
ALTER TABLE DocDetail ADD  docCancelUserType char(1) null
/
ALTER TABLE DocDetail ADD  docPubUserType char(1) null
/
ALTER TABLE DocDetail ADD  docReopenUserType char(1) null
/
ALTER TABLE DocDetail ADD  ownerType char(1) null
/
UPDATE DocDetail  SET docCreaterType=usertype
/
UPDATE DocDetail  SET docLastModUserType=userType
/
UPDATE DocDetail  SET docApproveUserType=userType
/
UPDATE DocDetail  SET docValidUserType=userType
/
UPDATE DocDetail  SET docInvalUserType=userType
/
UPDATE DocDetail  SET docArchiveUserType=userType
/
UPDATE DocDetail  SET docCancelUserType=userType
/
UPDATE DocDetail  SET docPubUserType=userType
/
UPDATE DocDetail  SET docReopenUserType=userType
/
UPDATE DocDetail  SET ownerType=userType
/