alter table workflow_requestLog add remarklocation varchar2(1000)
/
alter table workflow_flownode add isRemarkLocation int default 0
/