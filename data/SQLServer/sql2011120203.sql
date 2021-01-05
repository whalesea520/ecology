create index blog_discuss_index on blog_discuss (userid,workdate)
GO
create index blog_share_index on blog_share(blogid)
GO
create index blog_attention_index on blog_attention(userid)
GO
create index blog_read_index on blog_read(userid)
GO
create index blog_appDatas_index on blog_appDatas(discussid)
GO