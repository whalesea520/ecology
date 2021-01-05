CREATE TABLE odoc_formSignatueConfig (
id int NOT NULL IDENTITY(1,1) ,
workflowId int,
nodeid int,
synchAllNodes VARCHAR(1),
formSignatureWidth int,
formSignatureHeight int,
autoResizeSignImage VARCHAR(1),
defaultSignType VARCHAR(1),
defaultOpenSignType VARCHAR(1),
defaultColor VARCHAR(10),
defaultFontWidth VARCHAR(3),
defaultFont VARCHAR(1),
defaultFontSize VARCHAR(3),
defaultSignatureSource VARCHAR(1),
shortCutButtonConfig VARCHAR(500)
)
GO