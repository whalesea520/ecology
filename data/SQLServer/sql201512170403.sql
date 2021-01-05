alter table social_IMFile add resourcetype int 
GO
update social_IMFile set resourcetype=2 where fileType='img'
GO
update social_IMFile set resourcetype=1 where fileType<>'img'
GO