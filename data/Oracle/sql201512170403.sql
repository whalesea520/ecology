alter table social_IMFile add resourcetype int 
/
update social_IMFile set resourcetype=2 where fileType='img'
/
update social_IMFile set resourcetype=1 where fileType<>'img'
/