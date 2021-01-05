update DocDetail set istop=0 where istop!=1
GO
update DocDetail set topdate = null ,topenddate = null where istop=0
GO
