create table CRM_Common_Attention (
   id                   int                  identity,
   operatetype          int                  null,
   objid                int                  null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   constraint PK_CRM_COMMON_ATTENTION primary key (id)
)
GO

ALTER TABLE CRM_CustomerContacter ADD  imcode varchar(50)
GO

ALTER TABLE CRM_CustomerContacter ADD  status int
GO

ALTER TABLE CRM_CustomerContacter ADD  isneedcontact int
GO
