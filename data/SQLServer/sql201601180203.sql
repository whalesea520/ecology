INSERT INTO SysPoppupInfo( type ,link ,description ,statistic ,typedescription)
VALUES  ( 25 ,'/hrm/HrmTab.jsp?_fromURL=HrmGroupSuggestList' ,'126253' ,'y' , '126253')
GO

CREATE TABLE HrmGroupSuggest(
id INT IDENTITY(1,1) PRIMARY KEY,
suggesttitle VARCHAR(500),
groupid INT,
suggesttype int,
content varchar(4000),
STATUS INT,
creater INT,
createdate VARCHAR(10)
)
GO
