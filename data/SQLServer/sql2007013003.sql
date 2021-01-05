DROP TABLE WorkPlanType
GO

CREATE TABLE WorkPlanType
(
   workPlanTypeID         int IDENTITY(0, 1)   PRIMARY KEY NOT NULL,
   workPlanTypeName       varchar(200)         NULL,
   workPlanTypeAttribute  int                  NULL,
   workPlanTypeColor      char(7)              NULL,
   available              char(1)              NULL,
   displayOrder           int                  NULL
)
GO

