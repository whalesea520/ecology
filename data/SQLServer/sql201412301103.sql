ALTER TABLE SystemSet ADD fmdetachable INT
GO
ALTER TABLE SystemSet ADD fmdftsubcomid INT
GO
ALTER TABLE workflow_formbase ADD subcompanyid3 INT
GO
ALTER TABLE workflow_bill ADD subcompanyid3 INT
GO
ALTER TABLE modeTreeField ADD subcompanyid INT
GO
ALTER TABLE modeinfo ADD subcompanyid INT
GO