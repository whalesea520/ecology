delete from mode_custompagedetail where mainid not in ( select id from mode_custompage )
go