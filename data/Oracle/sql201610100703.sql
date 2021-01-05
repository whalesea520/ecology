ALTER TABLE DocInstancyLevel ADD showOrder decimal(6,2)
/
UPDATE DocInstancyLevel SET showOrder = 0.0 WHERE showOrder IS NULL
/
UPDATE workflow_browserurl SET browserurl = '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docInstancyLevelBrowser.jsp' WHERE browserurl LIKE '%docInstancyLevelBrowser.jsp%'
/

ALTER TABLE DocSendDocKind ADD showOrder decimal(6,2)
/
UPDATE DocSendDocKind SET showOrder = '0.0' WHERE showOrder IS NULL
/
UPDATE workflow_browserurl SET browserurl = '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docKindBrowser.jsp' WHERE browserurl LIKE '%docKindBrowser.jsp%'
/

ALTER TABLE DocSecretLevel ADD showOrder decimal(6,2)
/
UPDATE DocSecretLevel SET showOrder = '0.0' WHERE showOrder IS NULL
/
UPDATE workflow_browserurl SET browserurl = '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docSecretLevelBrowser.jsp' WHERE browserurl LIKE '%docSecretLevelBrowser.jsp%'
/

ALTER TABLE DocSendDocNumber ADD showOrder decimal(6,2)
/
UPDATE DocSendDocNumber SET showOrder = '0.0' WHERE showOrder IS NULL
/
UPDATE workflow_browserurl SET browserurl = '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docNumberBrowser.jsp' WHERE browserurl LIKE '%docNumberBrowser.jsp%'
/