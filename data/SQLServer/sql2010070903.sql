CREATE TABLE PluginLicenseUser ( 
    id int IDENTITY PRIMARY KEY,
    plugintype varchar(20),
    sharetype varchar(20),
    sharevalue varchar(200),
    seclevel varchar(50)
) 
GO