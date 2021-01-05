ALTER TABLE DocInstancyLevel ADD showOrder decimal(6,2)
GO
UPDATE DocInstancyLevel SET showOrder = 0.0 WHERE showOrder IS NULL
GO
UPDATE workflow_browserurl SET browserurl = '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docInstancyLevelBrowser.jsp' WHERE browserurl LIKE '%docInstancyLevelBrowser.jsp%'
GO

ALTER TABLE DocSendDocKind ADD showOrder decimal(6,2)
GO
UPDATE DocSendDocKind SET showOrder = '0.0' WHERE showOrder IS NULL
GO
UPDATE workflow_browserurl SET browserurl = '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docKindBrowser.jsp' WHERE browserurl LIKE '%docKindBrowser.jsp%'
GO

ALTER TABLE DocSecretLevel ADD showOrder decimal(6,2)
GO
UPDATE DocSecretLevel SET showOrder = '0.0' WHERE showOrder IS NULL
GO
UPDATE workflow_browserurl SET browserurl = '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docSecretLevelBrowser.jsp' WHERE browserurl LIKE '%docSecretLevelBrowser.jsp%'
GO

ALTER TABLE DocSendDocNumber ADD showOrder decimal(6,2)
GO
UPDATE DocSendDocNumber SET showOrder = '0.0' WHERE showOrder IS NULL
GO
UPDATE workflow_browserurl SET browserurl = '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docNumberBrowser.jsp' WHERE browserurl LIKE '%docNumberBrowser.jsp%'
GO