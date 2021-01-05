ALTER TABLE wfec_indatasetdetail ADD detailindex INTEGER
GO
ALTER TABLE wfec_indatasetdetail ADD outfielddbtype VARCHAR(100) 
GO
ALTER TABLE wfec_outdatasetdetail ADD detailindex INTEGER
GO
ALTER TABLE wfec_outdatasetdetail ADD outfielddbtype VARCHAR(100) 
GO
ALTER TABLE wfec_outdatasetdetail ADD dsporder INTEGER
GO