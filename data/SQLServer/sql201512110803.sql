alter table workflow_requestLog add remarklocation varchar(1000)
GO
alter table workflow_flownode add isRemarkLocation int default 0
GO