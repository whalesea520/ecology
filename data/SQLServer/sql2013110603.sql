create table indexupdatelog 
(
  ID               INT IDENTITY NOT NULL,
  DOCID            INT,
  CTYPE            VARCHAR(30),
  MODTYPE          VARCHAR(30),
  CREATETIME       CHAR(19),
  DOCCREATEDATE    VARCHAR(10),
  DONEFLAG         INT
);
go

CREATE table FullSearch_ViewSet
    (
	id                    INT IDENTITY NOT NULL,
	userid	              INT NULL,
	contentType           VARCHAR(20) NULL,
	canShowField          VARCHAR(1000) NULL,
	showField             VARCHAR(1000) NULL,
	bgimg                 INT NULL,
	numPerPage            INT NULL,
	showContentTypes      VARCHAR(1000) NULL
	)
go

CREATE table FullSearch_HotKeys
    (
	id                    INT IDENTITY NOT NULL,
	userid	              INT NULL,
	hotKey                VARCHAR(1000) NULL,
	intCount              INT NULL,
	updateTime            bigint NULL
	)
GO
