ALTER TABLE DocReceiveUnit ADD showorder_new DECIMAL(15,2)
GO
UPDATE DocReceiveUnit SET showorder_new=showOrder
GO
ALTER TABLE DocReceiveUnit DROP COLUMN showOrder
GO
sp_rename 'DocReceiveUnit.showorder_new','showOrder','column'
GO