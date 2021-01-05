create table session_table(
sessionId varchar(200) PRIMARY KEY,
accessTime number NOT NULL,
userId int NOT NULL
)
/
CREATE TABLE session_item_table(
sessionId varchar(200) NOT NULL,
sessionKey varchar(200) NOT NULL,
sessionVal blob NULL,
createTime number NOT NULL)
/
alter table session_item_table add constraints session_item_table_pk primary key (sessionId,sessionKey)
/