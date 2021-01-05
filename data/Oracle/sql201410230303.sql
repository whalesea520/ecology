ALTER TABLE CRM_ShareInfo ADD  deleted INT DEFAULT 0
/
UPDATE CRM_ShareInfo SET deleted = 0 WHERE relateditemid IN (SELECT id FROM CRM_CustomerInfo WHERE deleted <>1)
/
UPDATE CRM_ShareInfo SET deleted = 1 WHERE relateditemid IN (SELECT id FROM CRM_CustomerInfo WHERE  deleted = 1)
/