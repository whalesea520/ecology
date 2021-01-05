ALTER TABLE fnaInvoiceLedger ADD CONSTRAINT u_fnaInvoiceLedger UNIQUE (invoiceCode, invoiceNumber)
GO