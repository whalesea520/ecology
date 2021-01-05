ALTER TABLE cowork_items ADD isApply CHAR(1)
GO


CREATE TABLE cowork_apply_info(
	id INT IDENTITY(1,1),
	coworkid CHAR (10) NULL ,
	status CHAR(2) NULL ,
	resourceid CHAR(10) NULL,
	applydate CHAR(20) NULL ,
	approveid CHAR(10) NULL ,
	approvedate CHAR(20) NULL,
	ipaddress CHAR(15) NULL 

)
GO