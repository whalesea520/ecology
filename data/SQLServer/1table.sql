CREATE TABLE [Base_FreeField] (
	[tablename] [varchar] (2)  NULL ,
	[dff01name] [varchar] (100)  NULL ,
	[dff01use] [tinyint] NULL ,
	[dff02name] [varchar] (100)  NULL ,
	[dff02use] [tinyint] NULL ,
	[dff03name] [varchar] (100)  NULL ,
	[dff03use] [tinyint] NULL ,
	[dff04name] [varchar] (100)  NULL ,
	[dff04use] [tinyint] NULL ,
	[dff05name] [varchar] (100)  NULL ,
	[dff05use] [tinyint] NULL ,
	[nff01name] [varchar] (100)  NULL ,
	[nff01use] [tinyint] NULL ,
	[nff02name] [varchar] (100)  NULL ,
	[nff02use] [tinyint] NULL ,
	[nff03name] [varchar] (100)  NULL ,
	[nff03use] [tinyint] NULL ,
	[nff04name] [varchar] (100)  NULL ,
	[nff04use] [tinyint] NULL ,
	[nff05name] [varchar] (100)  NULL ,
	[nff05use] [tinyint] NULL ,
	[tff01name] [varchar] (100)  NULL ,
	[tff01use] [tinyint] NULL ,
	[tff02name] [varchar] (100)  NULL ,
	[tff02use] [tinyint] NULL ,
	[tff03name] [varchar] (100)  NULL ,
	[tff03use] [tinyint] NULL ,
	[tff04name] [varchar] (100)  NULL ,
	[tff04use] [tinyint] NULL ,
	[tff05name] [varchar] (100)  NULL ,
	[tff05use] [tinyint] NULL ,
	[bff01name] [varchar] (100)  NULL ,
	[bff01use] [tinyint] NULL ,
	[bff02name] [varchar] (100)  NULL ,
	[bff02use] [tinyint] NULL ,
	[bff03name] [varchar] (100)  NULL ,
	[bff03use] [tinyint] NULL ,
	[bff04name] [varchar] (100)  NULL ,
	[bff04use] [tinyint] NULL ,
	[bff05name] [varchar] (100)  NULL ,
	[bff05use] [tinyint] NULL 
)
GO

CREATE TABLE [Bill_ExpenseDetail] (
	[expenseid] [int] NULL ,
	[relatedate] [char] (10)  NULL ,
	[detailremark] [varchar] (250)  NULL ,
	[feetypeid] [int] NULL ,
	[feesum] [decimal](10, 2) NULL ,
	[accessory] [int] NULL ,
	[invoicenum] [varchar] (250)  NULL ,
	[feerule] [decimal](10, 2) NULL 
)
GO

CREATE TABLE [Bill_HrmResourceAbsense] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[absenseremark] [text]  NULL ,
	[startdate] [char] (10)  NULL ,
	[starttime] [char] (8)  NULL ,
	[enddate] [char] (10)  NULL ,
	[endtime] [char] (8)  NULL ,
	[absenseday] [decimal](10, 2) NULL ,
	[workflowid] [int] NULL ,
	[workflowname] [varchar] (100)  NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL ,
	[usestatus] [char] (1)  NULL 
) 
GO

CREATE TABLE [Bill_Meetingroom] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[meetingroomid] [int] NULL ,
	[begindate] [varchar] (10)  NULL ,
	[begintime] [varchar] (5)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[endtime] [varchar] (5)  NULL ,
	[reason] [text]  NULL ,
	[relatecpt] [int] NULL ,
	[relatecrm] [int] NULL ,
	[relatedoc] [int] NULL ,
	[relatereq] [int] NULL ,
	[relatemeeting] [int] NULL 
) 
GO

CREATE TABLE [CRM_AddressType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL ,
	[candelete] [char] (1)  NULL 
)
GO

CREATE TABLE [CRM_ContactLog] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[customerid] [int] NULL ,
	[contacterid] [int] NULL ,
	[resourceid] [int] NULL ,
	[contactway] [int] NULL ,
	[ispassive] [tinyint] NULL ,
	[subject] [varchar] (100)  NULL ,
	[contacttype] [int] NULL ,
	[contactdate] [varchar] (10)  NULL ,
	[contacttime] [varchar] (8)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[endtime] [varchar] (8)  NULL ,
	[contactinfo] [text]  NULL ,
	[documentid] [int] NULL ,
	[submitdate] [varchar] (10)  NULL ,
	[submittime] [varchar] (8)  NULL ,
	[issublog] [tinyint] NULL ,
	[parentid] [int] NULL ,
	[isprocessed] [tinyint] NULL ,
	[processdate] [varchar] (10)  NULL ,
	[processtime] [varchar] (8)  NULL ,
	[isfinished] [tinyint] NULL ,
	[agentid] [int] NULL 
) 
GO

CREATE TABLE [CRM_ContactWay] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [CRM_ContacterTitle] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL ,
	[usetype] [char] (1)  NULL ,
	[language] [int] NULL ,
	[abbrev] [varchar] (50)  NULL 
)
GO

CREATE TABLE [CRM_CreditInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[creditamount] [money] NULL 
)
GO

CREATE TABLE [CRM_CustomerAddress] (
	[typeid] [int] NOT NULL ,
	[customerid] [int] NOT NULL ,
	[isequal] [tinyint] NULL ,
	[address1] [varchar] (250)  NULL ,
	[address2] [varchar] (250)  NULL ,
	[address3] [varchar] (250)  NULL ,
	[zipcode] [varchar] (10)  NULL ,
	[city] [int] NULL ,
	[country] [int] NULL ,
	[province] [int] NULL ,
	[county] [varchar] (50)  NULL ,
	[phone] [varchar] (50)  NULL ,
	[fax] [varchar] (50)  NULL ,
	[email] [varchar] (150)  NULL ,
	[contacter] [int] NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL 
)
GO

CREATE TABLE [CRM_CustomerContacter] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[customerid] [int] NULL ,
	[title] [int] NULL ,
	[fullname] [varchar] (50)  NULL ,
	[lastname] [varchar] (50)  NULL ,
	[firstname] [varchar] (50)  NULL ,
	[jobtitle] [varchar] (100)  NULL ,
	[email] [varchar] (150)  NULL ,
	[phoneoffice] [varchar] (20)  NULL ,
	[phonehome] [varchar] (20)  NULL ,
	[mobilephone] [varchar] (20)  NULL ,
	[fax] [varchar] (20)  NULL ,
	[language] [int] NULL ,
	[manager] [int] NULL ,
	[main] [tinyint] NULL ,
	[picid] [int] NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL 
)
GO

CREATE TABLE [CRM_CustomerDesc] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [CRM_CustomerInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50)  NULL ,
	[language] [int] NULL ,
	[engname] [varchar] (50)  NULL ,
	[address1] [varchar] (250)  NULL ,
	[address2] [varchar] (250)  NULL ,
	[address3] [varchar] (250)  NULL ,
	[zipcode] [varchar] (10)  NULL ,
	[city] [int] NULL ,
	[country] [int] NULL ,
	[province] [int] NULL ,
	[county] [varchar] (50)  NULL ,
	[phone] [varchar] (50)  NULL ,
	[fax] [varchar] (50)  NULL ,
	[email] [varchar] (150)  NULL ,
	[website] [varchar] (150)  NULL ,
	[source] [int] NULL ,
	[sector] [int] NULL ,
	[size_n] [int] NULL ,
	[manager] [int] NULL ,
	[agent] [int] NULL ,
	[parentid] [int] NULL ,
	[department] [int] NULL ,
	[fincode] [int] NULL ,
	[currency] [int] NULL ,
	[contractlevel] [int] NULL ,
	[creditlevel] [int] NULL ,
	[creditoffset] [money] NULL ,
	[discount] [real] NULL ,
	[taxnumber] [varchar] (50)  NULL ,
	[bankacount] [varchar] (50)  NULL ,
	[invoiceacount] [int] NULL ,
	[deliverytype] [int] NULL ,
	[paymentterm] [int] NULL ,
	[paymentway] [int] NULL ,
	[saleconfirm] [int] NULL ,
	[creditcard] [varchar] (50)  NULL ,
	[creditexpire] [varchar] (10)  NULL ,
	[documentid] [int] NULL ,
	[picid] [int] NULL ,
	[type] [int] NULL ,
	[typebegin] [varchar] (10)  NULL ,
	[description] [int] NULL ,
	[status] [int] NULL ,
	[rating] [int] NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL ,
	[deleted] [tinyint] NULL ,
	[subcompanyid1] [int] NULL ,
	[seclevel] [int] NULL ,
	[PortalLoginid] [varchar] (60)  NULL ,
	[PortalPassword] [varchar] (100)  NULL ,
	[PortalStatus] [tinyint] NULL ,
	[createdate] [varchar] (10)  NULL 
)
GO

CREATE TABLE [CRM_CustomerRating] (
	[id] [int] NOT NULL ,
	[fullname] [varchar] (60)  NULL ,
	[description] [varchar] (150)  NULL ,
	[workflow11] [int] NULL ,
	[workflow12] [int] NULL ,
	[workflow21] [int] NULL ,
	[workflow22] [int] NULL ,
	[workflow31] [int] NULL ,
	[workflow32] [int] NULL ,
	[canupgrade] [char] (1)  NULL 
)
GO

CREATE TABLE [CRM_CustomerSize] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [CRM_CustomerStatus] (
	[id] [int] NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [CRM_CustomerType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL ,
	[candelete] [char] (1)  NULL ,
	[canedit] [char] (1)  NULL 
)
GO

CREATE TABLE [CRM_Customize] (
	[userid] [int] NULL ,
	[row1col1] [int] NULL ,
	[row1col2] [int] NULL ,
	[row1col3] [int] NULL ,
	[row1col4] [int] NULL ,
	[row1col5] [int] NULL ,
	[row1col6] [int] NULL ,
	[row2col1] [int] NULL ,
	[row2col2] [int] NULL ,
	[row2col4] [int] NULL ,
	[row2col3] [int] NULL ,
	[row2col5] [int] NULL ,
	[row2col6] [int] NULL ,
	[row3col1] [int] NULL ,
	[row3col2] [int] NULL ,
	[row3col3] [int] NULL ,
	[row3col4] [int] NULL ,
	[row3col5] [int] NULL ,
	[row3col6] [int] NULL ,
	[logintype] [tinyint] NULL 
)
GO

CREATE TABLE [CRM_CustomizeOption] (
	[id] [int] NOT NULL ,
	[tabledesc] [int] NULL ,
	[fieldname] [varchar] (50)  NULL ,
	[labelid] [int] NULL ,
	[labelname] [varchar] (100)  NULL 
)
GO

CREATE TABLE [CRM_DeliveryType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL ,
	[sendtype] [varchar] (150)  NULL ,
	[shipment] [varchar] (150)  NULL ,
	[receive] [varchar] (150)  NULL 
)
GO

CREATE TABLE [CRM_Log] (
	[customerid] [int] NULL ,
	[logtype] [char] (2)  NULL ,
	[documentid] [int] NULL ,
	[logcontent] [text]  NULL ,
	[submitdate] [varchar] (10)  NULL ,
	[submittime] [varchar] (8)  NULL ,
	[submiter] [int] NULL ,
	[clientip] [char] (15)  NULL ,
	[submitertype] [tinyint] NULL 
) 
GO

CREATE TABLE [CRM_LoginLog] (
	[id] [int] NOT NULL ,
	[logindate] [char] (10)  NULL ,
	[logintime] [char] (8)  NULL ,
	[ipaddress] [char] (15)  NULL 
)
GO

CREATE TABLE [CRM_Modify] (
	[customerid] [int] NULL ,
	[tabledesc] [char] (1)  NULL ,
	[type] [int] NULL ,
	[addresstype] [int] NULL ,
	[fieldname] [varchar] (100)  NULL ,
	[modifydate] [varchar] (10)  NULL ,
	[modifytime] [varchar] (8)  NULL ,
	[original] [varchar] (255)  NULL ,
	[modified] [varchar] (255)  NULL ,
	[modifier] [int] NULL ,
	[clientip] [char] (15)  NULL ,
	[submitertype] [tinyint] NULL 
)
GO

CREATE TABLE [CRM_PaymentTerm] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [CRM_SectorInfo] (
	[id] [int]  NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL ,
	[parentid] [int] NULL ,
	[seclevel] [int] NULL ,
	[sectors] [varchar] (255)  NULL 
)
GO

CREATE TABLE [CRM_ShareInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[relateditemid] [int] NULL ,
	[sharetype] [tinyint] NULL ,
	[seclevel] [tinyint] NULL ,
	[rolelevel] [tinyint] NULL ,
	[sharelevel] [tinyint] NULL ,
	[userid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [tinyint] NULL ,
	[crmid] [int] NULL 
)
GO

CREATE TABLE [CRM_TradeInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[rangelower] [money] NULL ,
	[rangeupper] [money] NULL 
)
GO

CREATE TABLE [CRM_ViewLog] (
	[customerid] [int] NULL ,
	[type] [int] NULL ,
	[modifydate] [varchar] (10)  NULL ,
	[modifytime] [varchar] (8)  NULL ,
	[modifier] [int] NULL ,
	[clientip] [char] (15)  NULL 
)
GO

CREATE TABLE [CRM_ViewLog1] (
	[id] [int] NOT NULL ,
	[viewer] [int] NULL ,
	[viewdate] [char] (10)  NULL ,
	[viewtime] [char] (8)  NULL ,
	[ipaddress] [char] (15)  NULL ,
	[submitertype] [tinyint] NULL 
)
GO

CREATE TABLE [CRM_ledgerinfo] (
	[customerid] [int] NOT NULL ,
	[customercode] [varchar] (10)  NULL ,
	[tradetype] [char] (1)  NOT NULL ,
	[ledger1] [int] NULL ,
	[ledger2] [int] NULL 
)
GO

CREATE TABLE [CptAssortmentShare] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[assortmentid] [int] NULL ,
	[sharetype] [tinyint] NULL ,
	[seclevel] [tinyint] NULL ,
	[rolelevel] [tinyint] NULL ,
	[sharelevel] [tinyint] NULL ,
	[userid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [tinyint] NULL ,
	[crmid] [int] NULL 
)
GO

CREATE TABLE [CptCapital] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mark] [varchar] (60)  NULL ,
	[name] [varchar] (60)  NULL ,
	[barcode] [varchar] (30)  NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[seclevel] [tinyint] NULL ,
	[departmentid] [int] NULL ,
	[costcenterid] [int] NULL ,
	[resourceid] [int] NULL ,
	[crmid] [int] NULL ,
	[sptcount] [char] (1)  NULL ,
	[currencyid] [int] NULL ,
	[capitalcost] [decimal](18, 2) NULL ,
	[startprice] [decimal](18, 2) NULL ,
	[depreendprice] [decimal](18, 2) NULL ,
	[capitalspec] [varchar] (60)  NULL ,
	[capitallevel] [varchar] (30)  NULL ,
	[manufacturer] [varchar] (100)  NULL ,
	[manudate] [char] (10)  NULL ,
	[capitaltypeid] [int] NULL ,
	[capitalgroupid] [int] NULL ,
	[unitid] [int] NULL ,
	[capitalnum] [int] NULL ,
	[currentnum] [int] NULL ,
	[replacecapitalid] [int] NULL ,
	[version] [varchar] (60)  NULL ,
	[itemid] [int] NULL ,
	[remark] [text]  NULL ,
	[capitalimageid] [int] NULL ,
	[depremethod1] [int] NULL ,
	[depremethod2] [int] NULL ,
	[deprestartdate] [char] (10)  NULL ,
	[depreenddate] [char] (10)  NULL ,
	[customerid] [int] NULL ,
	[attribute] [tinyint] NULL ,
	[stateid] [int] NULL ,
	[location] [varchar] (100)  NULL ,
	[usedhours] [decimal](18, 3) NULL ,
	[datefield1] [char] (10)  NULL ,
	[datefield2] [char] (10)  NULL ,
	[datefield3] [char] (10)  NULL ,
	[datefield4] [char] (10)  NULL ,
	[datefield5] [char] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [char] (1)  NULL ,
	[tinyintfield2] [char] (1)  NULL ,
	[tinyintfield3] [char] (1)  NULL ,
	[tinyintfield4] [char] (1)  NULL ,
	[tinyintfield5] [char] (1)  NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL ,
	[isdata] [char] (1)  NULL ,
	[datatype] [int] NULL ,
	[relatewfid] [int] NULL ,
	[fnamark] [varchar] (60)  NULL ,
	[alertnum] [int] NULL ,
	[counttype] [char] (1)  NULL ,
	[isinner] [char] (1)  NULL 
) 
GO

CREATE TABLE [CptCapitalAssortment] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[assortmentname] [varchar] (60)  NULL ,
	[assortmentremark] [text]  NULL ,
	[supassortmentid] [int] NULL ,
	[supassortmentstr] [varchar] (200)  NULL ,
	[subassortmentcount] [int] NULL ,
	[capitalcount] [int] NULL ,
	[assortmentmark] [varchar] (30)  NULL 
) 
GO

CREATE TABLE [CptCapitalGroup] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (200)  NULL ,
	[parentid] [int] NULL 
)
GO

CREATE TABLE [CptCapitalShareInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[relateditemid] [int] NULL ,
	[sharetype] [tinyint] NULL ,
	[seclevel] [tinyint] NULL ,
	[rolelevel] [tinyint] NULL ,
	[sharelevel] [tinyint] NULL ,
	[userid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [tinyint] NULL ,
	[crmid] [int] NULL ,
	[sharefrom] [int] NULL 
)
GO

CREATE TABLE [CptCapitalState] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (200)  NULL ,
	[issystem] [char] (1)  NULL 
)
GO

CREATE TABLE [CptCapitalType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (200)  NULL 
)
GO

CREATE TABLE [CptCheckStock] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[checkstockno] [varchar] (20)  NULL ,
	[checkstockdesc] [varchar] (200)  NULL ,
	[departmentid] [int] NULL ,
	[location] [varchar] (200)  NULL ,
	[checkerid] [int] NULL ,
	[approverid] [int] NULL ,
	[createdate] [varchar] (10)  NULL ,
	[approvedate] [varchar] (10)  NULL ,
	[checkstatus] [char] (1)  NULL 
)
GO

CREATE TABLE [CptCheckStockList] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[checkstockid] [int] NULL ,
	[capitalid] [int] NULL ,
	[theorynumber] [int] NULL ,
	[realnumber] [int] NULL ,
	[price] [decimal](10, 2) NULL ,
	[remark] [varchar] (200)  NULL 
)
GO

CREATE TABLE [CptDepreMethod1] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (200)  NULL ,
	[depretype] [char] (1)  NULL ,
	[timelimit] [decimal](18, 3) NULL ,
	[startunit] [decimal](5, 3) NULL ,
	[endunit] [decimal](5, 3) NULL ,
	[deprefunc] [varchar] (200)  NULL 
)
GO

CREATE TABLE [CptDepreMethod2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[depreid] [int] NULL ,
	[time] [decimal](9, 3) NULL ,
	[depreunit] [decimal](5, 3) NULL 
)
GO

CREATE TABLE [CptRelateWorkflow] (
	[id] [int] NOT NULL ,
	[name] [varchar] (60)  NULL 
)
GO

CREATE TABLE [CptSearchMould] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mouldname] [varchar] (200)  NULL ,
	[userid] [int] NULL ,
	[mark] [varchar] (60)  NULL ,
	[name] [varchar] (60)  NULL ,
	[startdate] [char] (10)  NULL ,
	[startdate1] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[enddate1] [char] (10)  NULL ,
	[seclevel] [tinyint] NULL ,
	[seclevel1] [tinyint] NULL ,
	[departmentid] [int] NULL ,
	[costcenterid] [int] NULL ,
	[resourceid] [int] NULL ,
	[currencyid] [int] NULL ,
	[capitalcost] [varchar] (30)  NULL ,
	[capitalcost1] [varchar] (30)  NULL ,
	[startprice] [varchar] (30)  NULL ,
	[startprice1] [varchar] (30)  NULL ,
	[depreendprice] [varchar] (30)  NULL ,
	[depreendprice1] [varchar] (30)  NULL ,
	[capitalspec] [varchar] (60)  NULL ,
	[capitallevel] [varchar] (30)  NULL ,
	[manufacturer] [varchar] (100)  NULL ,
	[manudate] [char] (10)  NULL ,
	[manudate1] [char] (10)  NULL ,
	[capitaltypeid] [int] NULL ,
	[capitalgroupid] [int] NULL ,
	[unitid] [int] NULL ,
	[capitalnum] [varchar] (30)  NULL ,
	[capitalnum1] [varchar] (30)  NULL ,
	[currentnum] [varchar] (30)  NULL ,
	[currentnum1] [varchar] (30)  NULL ,
	[replacecapitalid] [int] NULL ,
	[version] [varchar] (60)  NULL ,
	[itemid] [int] NULL ,
	[depremethod1] [int] NULL ,
	[depremethod2] [int] NULL ,
	[deprestartdate] [char] (10)  NULL ,
	[deprestartdate1] [char] (10)  NULL ,
	[depreenddate] [char] (10)  NULL ,
	[depreenddate1] [char] (10)  NULL ,
	[customerid] [int] NULL ,
	[attribute] [char] (1)  NULL ,
	[stateid] [int] NULL ,
	[location] [varchar] (100)  NULL ,
	[isdata] [char] (1)  NULL ,
	[isinner] [char] (1)  NULL ,
	[counttype] [char] (1)  NULL 
)
GO

CREATE TABLE [CptShareDetail] (
	[cptid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [int] NULL ,
	[sharelevel] [int] NULL 
)
GO

CREATE TABLE [CptUseLog] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[capitalid] [int] NULL ,
	[usedate] [char] (10)  NULL ,
	[usedeptid] [int] NULL ,
	[useresourceid] [int] NULL ,
	[usecount] [decimal](18, 2) NULL ,
	[useaddress] [varchar] (200)  NULL ,
	[userequest] [int] NULL ,
	[maintaincompany] [varchar] (100)  NULL ,
	[fee] [decimal](10, 2) NULL ,
	[usestatus] [varchar] (2)  NULL ,
	[remark] [text]  NULL ,
	[olddeptid] [int] NULL 
) 
GO

CREATE TABLE [CrmShareDetail] (
	[crmid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [int] NULL ,
	[sharelevel] [int] NULL 
)
GO

CREATE TABLE [DocApproveRemark] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[docid] [int] NULL ,
	[approveremark] [varchar] (2000)  NULL ,
	[approverid] [int] NULL ,
	[approvedate] [char] (10)  NULL ,
	[approvetime] [char] (8)  NULL ,
	[isapprover] [char] (1)  NULL 
)
GO

CREATE TABLE [DocDetail] (
	[id] [int] NOT NULL ,
	[maincategory] [int] NULL ,
	[subcategory] [int] NULL ,
	[seccategory] [int] NULL ,
	[doctype] [int] NULL ,
	[doclangurage] [tinyint] NULL ,
	[docapprovable] [char] (1)  NULL ,
	[docreplyable] [char] (1)  NULL ,
	[isreply] [char] (1)  NULL ,
	[replydocid] [int] NULL ,
	[docsubject] [varchar] (200)  NULL ,
	[doccontent] [text]  NULL ,
	[docsharetype] [char] (1)  NULL ,
	[shareroleid] [int] NULL ,
	[docpublishtype] [char] (1)  NULL ,
	[itemid] [int] NULL ,
	[itemmaincategoryid] [int] NULL ,
	[hrmresid] [int] NULL ,
	[crmid] [int] NULL ,
	[projectid] [int] NULL ,
	[financeid] [int] NULL ,
	[financerefenceid1] [int] NULL ,
	[financerefenceid2] [int] NULL ,
	[doccreaterid] [int] NULL ,
	[docdepartmentid] [int] NULL ,
	[doccreatedate] [char] (10)  NULL ,
	[doccreatetime] [char] (8)  NULL ,
	[doclastmoduserid] [int] NULL ,
	[doclastmoddate] [char] (10)  NULL ,
	[doclastmodtime] [char] (8)  NULL ,
	[docapproveuserid] [int] NULL ,
	[docapprovedate] [char] (10)  NULL ,
	[docapprovetime] [char] (8)  NULL ,
	[docarchiveuserid] [int] NULL ,
	[docarchivedate] [char] (10)  NULL ,
	[docarchivetime] [char] (8)  NULL ,
	[docstatus] [char] (1)  NULL ,
	[parentids] [varchar] (255)  NULL ,
	[assetid] [int] NULL ,
	[ownerid] [int] NULL ,
	[keyword] [varchar] (255)  NULL ,
	[accessorycount] [int] NULL ,
	[replaydoccount] [int] NULL ,
	[usertype] [char] (1)  NULL ,
	[docno] [varchar] (100)  NULL 
) 
GO

CREATE TABLE [DocDetailLog] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[docid] [int] NULL ,
	[docsubject] [varchar] (200)  NULL ,
	[doccreater] [int] NULL ,
	[operatetype] [varchar] (2)  NULL ,
	[operatedesc] [varchar] (200)  NULL ,
	[operateuserid] [int] NULL ,
	[operatedate] [char] (10)  NULL ,
	[operatetime] [char] (8)  NULL ,
	[clientaddress] [char] (15)  NULL 
)
GO

CREATE TABLE [DocFrontpage] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[frontpagename] [varchar] (200)  NULL ,
	[frontpagedesc] [varchar] (200)  NULL ,
	[isactive] [char] (1)  NULL ,
	[departmentid] [int] NULL ,
	[linktype] [varchar] (2)  NULL ,
	[hasdocsubject] [char] (1)  NULL ,
	[hasfrontpagelist] [char] (1)  NULL ,
	[newsperpage] [tinyint] NULL ,
	[titlesperpage] [tinyint] NULL ,
	[defnewspicid] [int] NULL ,
	[backgroundpicid] [int] NULL ,
	[importdocid] [int] NULL ,
	[headerdocid] [int] NULL ,
	[footerdocid] [int] NULL ,
	[secopt] [varchar] (2)  NULL ,
	[seclevelopt] [tinyint] NULL ,
	[departmentopt] [int] NULL ,
	[dateopt] [int] NULL ,
	[languageopt] [int] NULL ,
	[clauseopt] [text]  NULL ,
	[newsclause] [text]  NULL ,
	[languageid] [int] NULL ,
	[publishtype] [int] NULL 
) 
GO

CREATE TABLE [DocImageFile] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[docid] [int] NULL ,
	[imagefileid] [int] NULL ,
	[imagefilename] [varchar] (200)  NULL ,
	[imagefiledesc] [varchar] (200)  NULL ,
	[imagefilewidth] [smallint] NULL ,
	[imagefileheight] [smallint] NULL ,
	[imagefielsize] [smallint] NULL ,
	[docfiletype] [char] (1)  NULL 
)
GO

CREATE TABLE [DocMailMould] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mouldname] [varchar] (200)  NULL ,
	[mouldtext] [text]  NULL ,
	[isdefault] [char] (1)  NULL 
) 
GO

CREATE TABLE [DocMainCategory] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[categoryname] [varchar] (200)  NULL ,
	[categoryiconid] [int] NULL ,
	[categoryorder] [int] NULL 
)
GO

CREATE TABLE [DocMould] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mouldname] [varchar] (200)  NULL ,
	[mouldtext] [text]  NULL ,
	[issysdefault] [char] (1)  NULL ,
	[isuserdefault] [char] (1)  NULL ,
	[ismaildefault] [char] (1)  NULL 
) 
GO

CREATE TABLE [DocMouldFile] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mouldname] [varchar] (200)  NULL ,
	[mouldtext] [text]  NULL 
) 
GO

CREATE TABLE [DocPicUpload] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[picname] [varchar] (200)  NULL ,
	[pictype] [char] (1)  NULL ,
	[imagefilename] [varchar] (200)  NULL ,
	[imagefileid] [int] NULL ,
	[imagefilewidth] [smallint] NULL ,
	[imagefileheight] [smallint] NULL ,
	[imagefilesize] [int] NULL ,
	[imagefilescale] [real] NULL 
)
GO

CREATE TABLE [DocSearchDefine] (
	[userid] [int] NULL ,
	[subjectdef] [char] (1)  NULL ,
	[contentdef] [char] (1)  NULL ,
	[replydef] [char] (1)  NULL ,
	[dociddef] [char] (1)  NULL ,
	[createrdef] [char] (1)  NULL ,
	[categorydef] [char] (1)  NULL ,
	[doctypedef] [char] (1)  NULL ,
	[departmentdef] [char] (1)  NULL ,
	[languragedef] [char] (1)  NULL ,
	[hrmresdef] [char] (1)  NULL ,
	[itemdef] [char] (1)  NULL ,
	[itemmaincategorydef] [char] (1)  NULL ,
	[crmdef] [char] (1)  NULL ,
	[projectdef] [char] (1)  NULL ,
	[financedef] [char] (1)  NULL ,
	[financerefdef1] [char] (1)  NULL ,
	[financerefdef2] [char] (1)  NULL ,
	[publishdef] [char] (1)  NULL ,
	[statusdef] [char] (1)  NULL ,
	[keyworddef] [varchar] (255)  NULL ,
	[ownerdef] [int] NULL 
)
GO

CREATE TABLE [DocSearchMould] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mouldname] [varchar] (200)  NULL ,
	[userid] [int] NULL ,
	[docsubject] [varchar] (200)  NULL ,
	[doccontent] [varchar] (200)  NULL ,
	[containreply] [char] (1)  NULL ,
	[maincategory] [int] NULL ,
	[subcategory] [int] NULL ,
	[seccategory] [int] NULL ,
	[docid] [int] NULL ,
	[createrid] [int] NULL ,
	[departmentid] [int] NULL ,
	[doclangurage] [tinyint] NULL ,
	[hrmresid] [int] NULL ,
	[itemid] [int] NULL ,
	[itemmaincategoryid] [int] NULL ,
	[crmid] [int] NULL ,
	[projectid] [int] NULL ,
	[financeid] [int] NULL ,
	[docpublishtype] [char] (1)  NULL ,
	[docstatus] [char] (1)  NULL ,
	[keyword] [varchar] (255)  NULL ,
	[ownerid] [int] NULL ,
	[docno] [varchar] (60)  NULL ,
	[doclastmoddatefrom] [char] (10)  NULL ,
	[doclastmoddateto] [char] (10)  NULL ,
	[docarchivedatefrom] [char] (10)  NULL ,
	[docarchivedateto] [char] (10)  NULL ,
	[doccreatedatefrom] [char] (10)  NULL ,
	[doccreatedateto] [char] (10)  NULL ,
	[docapprovedatefrom] [char] (10)  NULL ,
	[docapprovedateto] [char] (10)  NULL ,
	[replaydoccountfrom] [int] NULL ,
	[replaydoccountto] [int] NULL ,
	[accessorycountfrom] [int] NULL ,
	[accessorycountto] [int] NULL ,
	[doclastmoduserid] [int] NULL ,
	[docarchiveuserid] [int] NULL ,
	[docapproveuserid] [int] NULL ,
	[assetid] [int] NULL 
)
GO

CREATE TABLE [DocSecCategory] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[subcategoryid] [int] NULL ,
	[categoryname] [varchar] (200)  NULL ,
	[docmouldid] [int] NULL ,
	[publishable] [char] (1)  NULL ,
	[replyable] [char] (1)  NULL ,
	[shareable] [char] (1)  NULL ,
	[cusertype] [char] (1)  NULL ,
	[cuserseclevel] [tinyint] NULL ,
	[cdepartmentid1] [int] NULL ,
	[cdepseclevel1] [tinyint] NULL ,
	[cdepartmentid2] [int] NULL ,
	[cdepseclevel2] [tinyint] NULL ,
	[croleid1] [int] NULL ,
	[crolelevel1] [char] (1)  NULL ,
	[croleid2] [int] NULL ,
	[crolelevel2] [char] (1)  NULL ,
	[croleid3] [int] NULL ,
	[crolelevel3] [char] (1)  NULL ,
	[hasaccessory] [char] (1)  NULL ,
	[accessorynum] [tinyint] NULL ,
	[hasasset] [char] (1)  NULL ,
	[assetlabel] [varchar] (200)  NULL ,
	[hasitems] [char] (1)  NULL ,
	[itemlabel] [varchar] (200)  NULL ,
	[hashrmres] [char] (1)  NULL ,
	[hrmreslabel] [varchar] (200)  NULL ,
	[hascrm] [char] (1)  NULL ,
	[crmlabel] [varchar] (200)  NULL ,
	[hasproject] [char] (1)  NULL ,
	[projectlabel] [varchar] (200)  NULL ,
	[hasfinance] [char] (1)  NULL ,
	[financelabel] [varchar] (200)  NULL ,
	[approveworkflowid] [int] NULL 
)
GO

CREATE TABLE [DocSecCategoryShare] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[seccategoryid] [int] NULL ,
	[sharetype] [int] NULL ,
	[seclevel] [tinyint] NULL ,
	[rolelevel] [tinyint] NULL ,
	[sharelevel] [tinyint] NULL ,
	[userid] [int] NULL ,
	[subcompanyid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [tinyint] NULL 
)
GO

CREATE TABLE [DocSecCategoryType] (
	[seccategoryid] [int] NULL ,
	[typeid] [int] NULL 
)
GO

CREATE TABLE [DocShare] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[docid] [int] NULL ,
	[sharetype] [int] NULL ,
	[seclevel] [tinyint] NULL ,
	[rolelevel] [tinyint] NULL ,
	[sharelevel] [tinyint] NULL ,
	[userid] [int] NULL ,
	[subcompanyid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [tinyint] NULL ,
	[crmid] [int] NULL 
)
GO

CREATE TABLE [DocShareDetail] (
	[docid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [int] NULL ,
	[sharelevel] [int] NULL 
)
GO

CREATE TABLE [DocSubCategory] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[maincategoryid] [int] NULL ,
	[categoryname] [varchar] (200)  NULL 
)
GO

CREATE TABLE [DocSysDefault] (
	[fgpicwidth] [smallint] NULL ,
	[fgpicfixtype] [char] (1)  NULL ,
	[docdefmouldid] [int] NULL ,
	[docapprovewfid] [int] NULL 
)
GO

CREATE TABLE [DocType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typename] [varchar] (200)  NULL ,
	[isactive] [char] (1)  NULL ,
	[hasaccessory] [char] (1)  NULL ,
	[accessorynum] [tinyint] NULL ,
	[hasitems] [char] (1)  NULL ,
	[itemclause] [varchar] (200)  NULL ,
	[itemlabel] [varchar] (200)  NULL ,
	[hasitemmaincategory] [char] (1)  NULL ,
	[itemmaincategorylabel] [varchar] (200)  NULL ,
	[hashrmres] [char] (1)  NULL ,
	[hrmresclause] [varchar] (200)  NULL ,
	[hrmreslabel] [varchar] (200)  NULL ,
	[hascrm] [char] (1)  NULL ,
	[crmclause] [varchar] (200)  NULL ,
	[crmlabel] [varchar] (200)  NULL ,
	[hasproject] [char] (1)  NULL ,
	[projectclause] [varchar] (200)  NULL ,
	[projectlabel] [varchar] (200)  NULL ,
	[hasfinance] [char] (1)  NULL ,
	[financeclause] [varchar] (200)  NULL ,
	[financelabel] [varchar] (200)  NULL ,
	[hasrefence1] [char] (1)  NULL ,
	[hasrefence2] [char] (1)  NULL 
)
GO

CREATE TABLE [DocUserCategory] (
	[secid] [int] NULL ,
	[mainid] [int] NULL ,
	[subid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [char] (1)  NULL 
)
GO

CREATE TABLE [DocUserDefault] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[userid] [int] NULL ,
	[hascreater] [char] (1)  NULL ,
	[hascreatedate] [char] (1)  NULL ,
	[hascreatetime] [char] (1)  NULL ,
	[hasdocid] [char] (1)  NULL ,
	[hascategory] [char] (1)  NULL ,
	[numperpage] [tinyint] NULL ,
	[selectedcategory] [text]  NULL ,
	[hasreplycount] [char] (1)  NULL ,
	[hasaccessorycount] [char] (1)  NULL 
) 
GO

CREATE TABLE [DocUserView] (
	[docid] [int] NULL ,
	[userid] [int] NULL 
)
GO

CREATE TABLE [ErrorMsgIndex] (
	[id] [int] NOT NULL ,
	[indexdesc] [varchar] (40)  NULL 
)
GO

CREATE TABLE [ErrorMsgInfo] (
	[indexid] [int] NULL ,
	[msgname] [varchar] (200)  NULL ,
	[languageid] [tinyint] NULL 
)
GO

CREATE TABLE [FnaAccount] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ledgerid] [int] NULL ,
	[tranperiods] [char] (6)  NULL ,
	[trandaccount] [decimal](18, 3) NULL ,
	[trancaccount] [decimal](18, 3) NULL ,
	[tranremain] [decimal](18, 3) NULL ,
	[tranbalance] [char] (1)  NULL 
)
GO

CREATE TABLE [FnaAccountCostcenter] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ledgerid] [int] NULL ,
	[costcenterid] [int] NULL ,
	[tranperiods] [char] (6)  NULL ,
	[tranaccount] [decimal](18, 3) NULL ,
	[tranbalance] [char] (1)  NULL 
)
GO

CREATE TABLE [FnaAccountDepartment] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ledgerid] [int] NULL ,
	[departmentid] [int] NULL ,
	[tranperiods] [char] (6)  NULL ,
	[tranaccount] [decimal](18, 3) NULL ,
	[tranbalance] [char] (1)  NULL 
)
GO

CREATE TABLE [FnaAccountList] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ledgerid] [int] NULL ,
	[tranid] [int] NULL ,
	[tranperiods] [char] (6)  NULL ,
	[tranmark] [int] NULL ,
	[trandate] [char] (10)  NULL ,
	[tranremark] [varchar] (200)  NULL ,
	[tranaccount] [decimal](18, 3) NULL ,
	[tranbalance] [char] (1)  NULL ,
	[tranremain] [decimal](18, 3) NULL 
)
GO

CREATE TABLE [FnaBudget] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[budgetmoduleid] [int] NULL ,
	[budgetperiods] [char] (6)  NULL ,
	[budgetdepartmentid] [int] NULL ,
	[budgetcostercenterid] [int] NULL ,
	[budgetresourceid] [int] NULL ,
	[budgetcurrencyid] [int] NULL ,
	[budgetdefcurrencyid] [int] NULL ,
	[budgetexchangerate] [varchar] (20)  NULL ,
	[budgetremark] [varchar] (250)  NULL ,
	[budgetstatus] [char] (1)  NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[approverid] [int] NULL ,
	[approverdate] [char] (10)  NULL 
)
GO

CREATE TABLE [FnaBudgetCostcenter] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ledgerid] [int] NULL ,
	[costcenterid] [int] NULL ,
	[budgetmoduleid] [int] NULL ,
	[budgetperiods] [char] (6)  NULL ,
	[budgetaccount] [decimal](18, 3) NULL 
)
GO

CREATE TABLE [FnaBudgetDepartment] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ledgerid] [int] NULL ,
	[departmentid] [int] NULL ,
	[budgetmoduleid] [int] NULL ,
	[budgetperiods] [char] (6)  NULL ,
	[budgetaccount] [decimal](18, 3) NULL 
)
GO

CREATE TABLE [FnaBudgetDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[budgetid] [int] NULL ,
	[ledgerid] [int] NULL ,
	[budgetcrmid] [int] NULL ,
	[budgetitemid] [int] NULL ,
	[budgetdocid] [int] NULL ,
	[budgetprojectid] [int] NULL ,
	[budgetaccount] [decimal](18, 3) NULL ,
	[budgetdefaccount] [decimal](18, 3) NULL ,
	[budgetremark] [varchar] (200)  NULL 
)
GO

CREATE TABLE [FnaBudgetList] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ledgerid] [int] NULL ,
	[budgetid] [int] NULL ,
	[budgetmoduleid] [int] NULL ,
	[budgetperiods] [char] (6)  NULL ,
	[budgetdepartmentid] [int] NULL ,
	[budgetcostcenterid] [int] NULL ,
	[budgetresourceid] [int] NULL ,
	[budgetremark] [varchar] (200)  NULL ,
	[budgetaccount] [decimal](18, 3) NULL 
)
GO

CREATE TABLE [FnaBudgetModule] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[budgetname] [varchar] (60)  NULL ,
	[budgetdesc] [varchar] (200)  NULL ,
	[fnayear] [char] (4)  NULL ,
	[periodsidfrom] [int] NULL ,
	[periodsidto] [int] NULL 
)
GO

CREATE TABLE [FnaBudgetfeeType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50)  NULL ,
	[description] [varchar] (250)  NULL 
)
GO

CREATE TABLE [FnaCurrency] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[currencyname] [varchar] (60)  NULL ,
	[currencydesc] [varchar] (200)  NULL ,
	[activable] [char] (1)  NULL ,
	[isdefault] [char] (1)  NULL 
)
GO

CREATE TABLE [FnaCurrencyExchange] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[defcurrencyid] [int] NULL ,
	[thecurrencyid] [int] NULL ,
	[fnayear] [char] (4)  NULL ,
	[periodsid] [int] NULL ,
	[fnayearperiodsid] [char] (6)  NULL ,
	[avgexchangerate] [varchar] (20)  NULL ,
	[endexchangerage] [varchar] (20)  NULL 
)
GO

CREATE TABLE [FnaDptToKingdee] (
	[departmentid] [int] NULL ,
	[kingdeecode] [varchar] (20)  NULL 
)
GO

CREATE TABLE [FnaExpensefeeRules] (
	[feeid] [int] NULL ,
	[resourceid] [int] NULL ,
	[standardfee] [decimal](10, 3) NULL 
)
GO

CREATE TABLE [FnaExpensefeeType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50)  NULL ,
	[remark] [varchar] (250)  NULL 
)
GO

CREATE TABLE [FnaIndicator] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[indicatorname] [varchar] (60)  NULL ,
	[indicatordesc] [varchar] (200)  NULL ,
	[indicatortype] [char] (1)  NULL ,
	[indicatorbalance] [char] (1)  NULL ,
	[haspercent] [char] (1)  NULL ,
	[indicatoridfirst] [int] NULL ,
	[indicatoridlast] [int] NULL 
)
GO

CREATE TABLE [FnaIndicatordetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[indicatorid] [int] NULL ,
	[ledgerid] [int] NULL 
)
GO

CREATE TABLE [FnaLedger] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ledgermark] [varchar] (60)  NULL ,
	[ledgername] [varchar] (200)  NULL ,
	[ledgertype] [char] (1)  NULL ,
	[ledgergroup] [char] (1)  NULL ,
	[ledgerbalance] [char] (1)  NULL ,
	[autosubledger] [char] (1)  NULL ,
	[ledgercurrency] [char] (1)  NULL ,
	[supledgerid] [int] NULL ,
	[subledgercount] [int] NULL ,
	[categoryid] [int] NULL ,
	[initaccount] [decimal](18, 3) NULL ,
	[supledgerall] [varchar] (100)  NULL 
)
GO

CREATE TABLE [FnaLedgerCategory] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[categoryname] [varchar] (60)  NULL ,
	[categorydesc] [varchar] (200)  NULL 
)
GO

CREATE TABLE [FnaTransaction] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[tranmark] [int] NULL ,
	[trandate] [char] (10)  NULL ,
	[tranperiods] [char] (6)  NULL ,
	[trandepartmentid] [int] NULL ,
	[trancostercenterid] [int] NULL ,
	[trancurrencyid] [int] NULL ,
	[trandefcurrencyid] [int] NULL ,
	[tranexchangerate] [varchar] (20)  NULL ,
	[tranaccessories] [tinyint] NULL ,
	[tranresourceid] [int] NULL ,
	[trancrmid] [int] NULL ,
	[tranitemid] [int] NULL ,
	[trandocid] [int] NULL ,
	[tranprojectid] [int] NULL ,
	[trandaccount] [decimal](18, 3) NULL ,
	[trancaccount] [decimal](18, 3) NULL ,
	[trandefdaccount] [decimal](18, 3) NULL ,
	[trandefcaccount] [decimal](18, 3) NULL ,
	[tranremark] [varchar] (250)  NULL ,
	[transtatus] [char] (1)  NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[approverid] [int] NULL ,
	[approverdate] [char] (10)  NULL ,
	[manual] [char] (1)  NULL 
)
GO

CREATE TABLE [FnaTransactionDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[tranid] [int] NULL ,
	[ledgerid] [int] NULL ,
	[tranaccount] [decimal](18, 3) NULL ,
	[trandefaccount] [decimal](18, 3) NULL ,
	[tranbalance] [char] (1)  NULL ,
	[tranremark] [varchar] (200)  NULL 
)
GO

CREATE TABLE [FnaYearsPeriods] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fnayear] [char] (4)  NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[budgetid] [int] NULL 
)
GO

CREATE TABLE [FnaYearsPeriodsList] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fnayearid] [int] NULL ,
	[Periodsid] [int] NULL ,
	[fnayear] [char] (4)  NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[isclose] [char] (1)  NULL ,
	[isactive] [char] (1)  NULL ,
	[fnayearperiodsid] [char] (6)  NULL 
)
GO

CREATE TABLE [HrmActivitiesCompetency] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[jobactivityid] [int] NULL ,
	[competencyid] [int] NULL 
)
GO

CREATE TABLE [HrmApplyRemark] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[applyid] [int] NULL ,
	[remark] [varchar] (200)  NULL ,
	[resourceid] [int] NULL ,
	[date_n] [char] (10)  NULL ,
	[time] [char] (8)  NULL 
)
GO

CREATE TABLE [HrmBank] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[bankname] [varchar] (60)  NULL ,
	[bankdesc] [varchar] (200)  NULL ,
	[checkstr] [varchar] (100)  NULL 
)
GO

CREATE TABLE [HrmCareerApply] (
	[id] [int] NOT NULL ,
	[ischeck] [char] (1)  NULL ,
	[ishire] [char] (1)  NULL ,
	[loginid] [varchar] (60)  NULL ,
	[password] [varchar] (100)  NULL ,
	[firstname] [varchar] (60)  NULL ,
	[lastname] [varchar] (60)  NULL ,
	[aliasname] [varchar] (60)  NULL ,
	[titleid] [int] NULL ,
	[sex] [char] (1)  NULL ,
	[birthday] [char] (10)  NULL ,
	[nationality] [int] NULL ,
	[defaultlanguage] [int] NULL ,
	[systemlanguage] [int] NULL ,
	[certificatecategory] [varchar] (30)  NULL ,
	[certificatenum] [varchar] (60)  NULL ,
	[nativeplace] [varchar] (100)  NULL ,
	[educationlevel] [char] (1)  NULL ,
	[bememberdate] [char] (10)  NULL ,
	[bepartydate] [char] (10)  NULL ,
	[bedemocracydate] [char] (10)  NULL ,
	[regresidentplace] [varchar] (60)  NULL ,
	[healthinfo] [char] (1)  NULL ,
	[residentplace] [varchar] (60)  NULL ,
	[policy] [varchar] (30)  NULL ,
	[degree] [varchar] (30)  NULL ,
	[height] [varchar] (10)  NULL ,
	[homepage] [varchar] (100)  NULL ,
	[maritalstatus] [char] (1)  NULL ,
	[marrydate] [char] (10)  NULL ,
	[train] [text]  NULL ,
	[resourceimageid] [int] NULL ,
	[officephone] [varchar] (60)  NULL ,
	[mobile] [varchar] (60)  NULL ,
	[mobilecall] [varchar] (60)  NULL ,
	[email] [varchar] (60)  NULL ,
	[countryid] [int] NULL ,
	[locationid] [int] NULL ,
	[workroom] [varchar] (60)  NULL ,
	[homeaddress] [varchar] (100)  NULL ,
	[homepostcode] [varchar] (20)  NULL ,
	[homephone] [varchar] (60)  NULL ,
	[timezone] [int] NULL ,
	[worktype] [varchar] (60)  NULL ,
	[usekind] [int] NULL ,
	[workcode] [varchar] (60)  NULL ,
	[contractbegintime] [char] (10)  NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[contractdate] [char] (10)  NULL ,
	[resourcetype] [char] (1)  NULL ,
	[jobtitle] [int] NULL ,
	[jobgroup] [int] NULL ,
	[jobright] [varchar] (100)  NULL ,
	[jobcall] [int] NULL ,
	[jobtype] [int] NULL ,
	[jobactivity] [int] NULL ,
	[jobactivitydesc] [varchar] (200)  NULL ,
	[joblevel] [tinyint] NULL ,
	[seclevel] [tinyint] NULL ,
	[departmentid] [int] NULL ,
	[subcompanyid1] [int] NULL ,
	[subcompanyid2] [int] NULL ,
	[subcompanyid3] [int] NULL ,
	[subcompanyid4] [int] NULL ,
	[costcenterid] [int] NULL ,
	[managerid] [int] NULL ,
	[assistantid] [int] NULL ,
	[purchaselimit] [decimal](10, 3) NULL ,
	[currencyid] [int] NULL ,
	[bankid1] [int] NULL ,
	[accountid1] [varchar] (100)  NULL ,
	[bankid2] [int] NULL ,
	[accountid2] [varchar] (100)  NULL ,
	[securityno] [varchar] (100)  NULL ,
	[accumfundaccount] [varchar] (30)  NULL ,
	[creditcard] [varchar] (100)  NULL ,
	[expirydate] [char] (10)  NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[lastmodid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastlogindate] [char] (10)  NULL ,
	[careerid] [int] NULL 
) 
GO

CREATE TABLE [HrmCareerApplyOtherInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[applyid] [int] NULL ,
	[category] [char] (1)  NULL ,
	[contactor] [varchar] (30)  NULL ,
	[major] [varchar] (60)  NULL ,
	[salarynow] [varchar] (60)  NULL ,
	[worktime] [varchar] (10)  NULL ,
	[salaryneed] [varchar] (60)  NULL ,
	[currencyid] [int] NULL ,
	[reason] [varchar] (200)  NULL ,
	[otherrequest] [varchar] (200)  NULL ,
	[selfcomment] [text]  NULL 
) 
GO

CREATE TABLE [HrmCareerInvite] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[careername] [varchar] (80)  NULL ,
	[careerpeople] [char] (4)  NULL ,
	[careerage] [varchar] (60)  NULL ,
	[careersex] [char] (1)  NULL ,
	[careeredu] [char] (1)  NULL ,
	[careermode] [varchar] (60)  NULL ,
	[careeraddr] [varchar] (100)  NULL ,
	[careerclass] [varchar] (60)  NULL ,
	[careerdesc] [text]  NULL ,
	[careerrequest] [text]  NULL ,
	[careerremark] [text]  NULL ,
	[careertype] [char] (1)  NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[lastmodid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL 
) 
GO

CREATE TABLE [HrmCareerWorkexp] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ftime] [char] (10)  NULL ,
	[ttime] [char] (10)  NULL ,
	[company] [varchar] (100)  NULL ,
	[jobtitle] [varchar] (100)  NULL ,
	[workdesc] [text]  NULL ,
	[applyid] [int] NULL 
) 
GO

CREATE TABLE [HrmCertification] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[datefrom] [char] (10)  NULL ,
	[dateto] [char] (10)  NULL ,
	[certname] [varchar] (60)  NULL ,
	[awardfrom] [varchar] (100)  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL 
)
GO

CREATE TABLE [HrmCity] (
	[id] [int] NOT NULL ,
	[cityname] [varchar] (60)  NULL ,
	[citylongitude] [numeric](8, 3) NULL ,
	[citylatitude] [numeric](8, 3) NULL ,
	[provinceid] [int] NULL ,
	[countryid] [int] NULL 
)
GO

CREATE TABLE [HrmCompany] (
	[id] [tinyint] NOT NULL ,
	[companyname] [varchar] (200)  NULL 
)
GO

CREATE TABLE [HrmCompetency] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[competencymark] [varchar] (60)  NULL ,
	[competencyname] [varchar] (200)  NULL ,
	[competencyremark] [text]  NULL 
) 
GO

CREATE TABLE [HrmComponentStat] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[salarystat] [decimal](10, 3) NULL ,
	[periodyear] [char] (4)  NULL ,
	[periodmonth] [char] (2)  NULL 
)
GO

CREATE TABLE [HrmCostcenter] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[costcentermark] [varchar] (60)  NULL ,
	[costcentername] [varchar] (200)  NULL ,
	[activable] [char] (1)  NULL ,
	[departmentid] [int] NULL ,
	[ccsubcategory1] [int] NULL ,
	[ccsubcategory2] [int] NULL ,
	[ccsubcategory3] [int] NULL ,
	[ccsubcategory4] [int] NULL 
)
GO

CREATE TABLE [HrmCostcenterMainCategory] (
	[id] [tinyint] NOT NULL ,
	[ccmaincategoryname] [varchar] (200)  NULL 
)
GO

CREATE TABLE [HrmCostcenterSubCategory] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ccsubcategoryname] [varchar] (60)  NULL ,
	[ccsubcategorydesc] [varchar] (200)  NULL ,
	[ccmaincategoryid] [tinyint] NULL ,
	[isdefault] [char] (1)  NULL 
)
GO

CREATE TABLE [HrmCountry] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[countryname] [varchar] (60)  NULL ,
	[countrydesc] [varchar] (200)  NULL 
)
GO

CREATE TABLE [HrmDepartment] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[departmentmark] [varchar] (60)  NULL ,
	[departmentname] [varchar] (200)  NULL ,
	[countryid] [int] NULL ,
	[addedtax] [varchar] (50)  NULL ,
	[website] [varchar] (200)  NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[currencyid] [int] NULL ,
	[seclevel] [tinyint] NULL ,
	[subcompanyid1] [int] NULL ,
	[subcompanyid2] [int] NULL ,
	[subcompanyid3] [int] NULL ,
	[subcompanyid4] [int] NULL ,
	[createrid] [int] NULL ,
	[createrdate] [char] (10)  NULL ,
	[lastmoduserid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL 
)
GO

CREATE TABLE [HrmEducationInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[school] [varchar] (100)  NULL ,
	[speciality] [varchar] (60)  NULL ,
	[educationlevel] [char] (1)  NULL ,
	[studydesc] [text]  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL 
) 
GO

CREATE TABLE [HrmFamilyInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[member] [varchar] (30)  NULL ,
	[title] [varchar] (30)  NULL ,
	[company] [varchar] (100)  NULL ,
	[jobtitle] [varchar] (100)  NULL ,
	[address] [varchar] (100)  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL 
)
GO

CREATE TABLE [HrmJobActivities] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[jobactivitymark] [varchar] (60)  NULL ,
	[jobactivityname] [varchar] (200)  NULL ,
	[docid] [int] NULL ,
	[jobactivityremark] [text]  NULL ,
	[jobgroupid] [int] NULL 
) 
GO

CREATE TABLE [HrmJobCall] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (60)  NULL 
)
GO

CREATE TABLE [HrmJobGroups] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[jobgroupmark] [varchar] (60)  NULL ,
	[jobgroupname] [varchar] (200)  NULL ,
	[docid] [int] NULL ,
	[jobgroupremark] [text]  NULL 
) 
GO

CREATE TABLE [HrmJobTitles] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[jobtitlemark] [varchar] (60)  NULL ,
	[jobtitlename] [varchar] (200)  NULL ,
	[seclevel] [tinyint] NULL ,
	[joblevelfrom] [tinyint] NULL ,
	[joblevelto] [tinyint] NULL ,
	[docid] [int] NULL ,
	[jobtitleremark] [text]  NULL ,
	[jobgroupid] [int] NULL ,
	[jobactivityid] [int] NULL 
) 
GO

CREATE TABLE [HrmJobType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (60)  NULL 
)
GO

CREATE TABLE [HrmLanguageAbility] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[language] [varchar] (30)  NULL ,
	[level_n] [char] (1)  NULL ,
	[memo] [text]  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL 
) 
GO

CREATE TABLE [HrmListValidate] (
	[id] [int] NOT NULL ,
	[name] [varchar] (50)  NULL ,
	[validate_n] [int] NULL 
)
GO

CREATE TABLE [HrmLocations] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[locationname] [varchar] (200)  NULL ,
	[locationdesc] [varchar] (200)  NULL ,
	[address1] [varchar] (200)  NULL ,
	[address2] [varchar] (200)  NULL ,
	[locationcity] [varchar] (200)  NULL ,
	[postcode] [varchar] (20)  NULL ,
	[countryid] [int] NULL ,
	[telephone] [varchar] (60)  NULL ,
	[fax] [varchar] (60)  NULL 
)
GO

CREATE TABLE [HrmOtherInfoType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typename] [varchar] (60)  NULL ,
	[typeremark] [varchar] (200)  NULL 
)
GO

CREATE TABLE [HrmPeriod] (
	[departmentid] [int] NULL ,
	[periodyear] [char] (4)  NULL ,
	[periodmonth] [char] (2)  NULL 
)
GO

CREATE TABLE [HrmPlanColor] (
	[resourceid] [int] NULL ,
	[basictype] [int] NULL ,
	[colorid1] [varchar] (6)  NULL ,
	[colorid2] [varchar] (6)  NULL 
)
GO

CREATE TABLE [HrmProvince] (
	[id] [int] NOT NULL ,
	[provincename] [varchar] (60)  NULL ,
	[provincedesc] [varchar] (200)  NULL ,
	[countryid] [int] NULL 
)
GO

CREATE TABLE [HrmPubHoliday] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[countryid] [int] NULL ,
	[holidaydate] [char] (10)  NULL ,
	[holidayname] [varchar] (200)  NULL 
)
GO

CREATE TABLE [HrmResource] (
	[id] [int] NOT NULL ,
	[loginid] [varchar] (60)  NULL ,
	[password] [varchar] (100)  NULL ,
	[firstname] [varchar] (60)  NULL ,
	[lastname] [varchar] (60)  NULL ,
	[aliasname] [varchar] (60)  NULL ,
	[titleid] [int] NULL ,
	[sex] [char] (1)  NULL ,
	[birthday] [char] (10)  NULL ,
	[nationality] [int] NULL ,
	[defaultlanguage] [int] NULL ,
	[systemlanguage] [int] NULL ,
	[maritalstatus] [char] (1)  NULL ,
	[marrydate] [char] (10)  NULL ,
	[telephone] [varchar] (60)  NULL ,
	[mobile] [varchar] (60)  NULL ,
	[mobilecall] [varchar] (60)  NULL ,
	[email] [varchar] (60)  NULL ,
	[countryid] [int] NULL ,
	[locationid] [int] NULL ,
	[timezone] [int] NULL ,
	[workroom] [varchar] (60)  NULL ,
	[homeaddress] [varchar] (100)  NULL ,
	[homepostcode] [varchar] (20)  NULL ,
	[homephone] [varchar] (60)  NULL ,
	[resourcetype] [char] (1)  NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[contractdate] [char] (10)  NULL ,
	[jobtitle] [int] NULL ,
	[jobgroup] [int] NULL ,
	[jobactivity] [int] NULL ,
	[jobactivitydesc] [varchar] (200)  NULL ,
	[joblevel] [tinyint] NULL ,
	[seclevel] [tinyint] NULL ,
	[departmentid] [int] NULL ,
	[subcompanyid1] [int] NULL ,
	[subcompanyid2] [int] NULL ,
	[subcompanyid3] [int] NULL ,
	[subcompanyid4] [int] NULL ,
	[costcenterid] [int] NULL ,
	[managerid] [int] NULL ,
	[assistantid] [int] NULL ,
	[purchaselimit] [decimal](10, 3) NULL ,
	[currencyid] [int] NULL ,
	[bankid1] [int] NULL ,
	[accountid1] [varchar] (100)  NULL ,
	[bankid2] [int] NULL ,
	[accountid2] [varchar] (100)  NULL ,
	[securityno] [varchar] (100)  NULL ,
	[creditcard] [varchar] (100)  NULL ,
	[expirydate] [char] (10)  NULL ,
	[resourceimageid] [int] NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[lastmodid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastlogindate] [char] (10)  NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL ,
	[certificatecategory] [varchar] (30)  NULL ,
	[certificatenum] [varchar] (60)  NULL ,
	[nativeplace] [varchar] (100)  NULL ,
	[educationlevel] [char] (1)  NULL ,
	[bememberdate] [char] (10)  NULL ,
	[bepartydate] [char] (10)  NULL ,
	[bedemocracydate] [char] (10)  NULL ,
	[workcode] [varchar] (60)  NULL ,
	[regresidentplace] [varchar] (60)  NULL ,
	[healthinfo] [char] (1)  NULL ,
	[residentplace] [varchar] (60)  NULL ,
	[policy] [varchar] (30)  NULL ,
	[degree] [varchar] (30)  NULL ,
	[height] [varchar] (10)  NULL ,
	[homepage] [varchar] (100)  NULL ,
	[train] [text]  NULL ,
	[worktype] [varchar] (60)  NULL ,
	[usekind] [int] NULL ,
	[contractbegintime] [char] (10)  NULL ,
	[jobright] [varchar] (100)  NULL ,
	[jobcall] [int] NULL ,
	[jobtype] [int] NULL ,
	[accumfundaccount] [varchar] (30)  NULL ,
	[birthplace] [varchar] (60)  NULL ,
	[folk] [varchar] (30)  NULL ,
	[residentphone] [varchar] (60)  NULL ,
	[residentpostcode] [varchar] (60)  NULL ,
	[extphone] [varchar] (50)  NULL ,
	[dsporder] [int] NULL 
) 
GO

CREATE TABLE [HrmResourceCompetency] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[competencyid] [int] NULL ,
	[lastgrade] [float] NULL ,
	[lastdate] [char] (10)  NULL ,
	[currentgrade] [float] NULL ,
	[currentdate] [char] (10)  NULL ,
	[countgrade] [float] NULL ,
	[counttimes] [int] NULL 
)
GO

CREATE TABLE [HrmResourceComponent] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[componentid] [int] NULL ,
	[componentmark] [varchar] (60)  NULL ,
	[ledgerid] [int] NULL ,
	[componentperiod] [char] (1)  NULL ,
	[selbank] [char] (1)  NULL ,
	[bankid] [int] NULL ,
	[salarysum] [decimal](10, 3) NULL ,
	[canedit] [char] (1)  NULL ,
	[currencyid] [int] NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[hasused] [char] (1)  NULL ,
	[remark] [text]  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL 
) 
GO

CREATE TABLE [HrmResourceOtherInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[infoname] [varchar] (100)  NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[docid] [int] NULL ,
	[inforemark] [text]  NULL ,
	[infotype] [int] NULL ,
	[seclevel] [tinyint] NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL 
) 
GO

CREATE TABLE [HrmResourceSkill] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[skilldesc] [varchar] (200)  NULL 
)
GO

CREATE TABLE [HrmRewardsRecord] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[rewardsdate] [char] (10)  NULL ,
	[rewardstype] [int] NULL ,
	[remark] [text]  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL 
) 
GO

CREATE TABLE [HrmRewardsType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[flag] [char] (1)  NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (60)  NULL 
)
GO

CREATE TABLE [HrmRoleMembers] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[roleid] [int] NULL ,
	[resourceid] [int] NULL ,
	[rolelevel] [char] (1)  NULL 
)
GO

CREATE TABLE [HrmRoles] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[rolesmark] [varchar] (60)  NULL ,
	[rolesname] [varchar] (200)  NULL ,
	[docid] [int] NULL 
)
GO

CREATE TABLE [HrmSalaryComponent] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[componentname] [varchar] (200)  NULL ,
	[countryid] [int] NULL ,
	[jobactivityid] [int] NULL ,
	[componenttype] [char] (1)  NULL ,
	[componentperiod] [char] (1)  NULL ,
	[currencyid] [int] NULL ,
	[ledgerid] [int] NULL ,
	[docid] [int] NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[includetex] [char] (1)  NULL ,
	[componenttypeid] [int] NULL 
)
GO

CREATE TABLE [HrmSalaryComponentDetail] (
	[componentid] [int] NULL ,
	[detailmark] [varchar] (60)  NULL ,
	[joblevel] [tinyint] NULL ,
	[salarysum] [decimal](10, 3) NULL ,
	[editable] [char] (1)  NULL 
)
GO

CREATE TABLE [HrmSalaryComponentTypes] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typemark] [varchar] (60)  NULL ,
	[typename] [varchar] (200)  NULL ,
	[colorid] [varchar] (6)  NULL ,
	[typeorder] [int] NULL 
)
GO

CREATE TABLE [HrmSchedule] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[relatedid] [int] NULL ,
	[monstarttime1] [char] (5)  NULL ,
	[monendtime1] [char] (5)  NULL ,
	[monstarttime2] [char] (5)  NULL ,
	[monendtime2] [char] (5)  NULL ,
	[tuestarttime1] [char] (5)  NULL ,
	[tueendtime1] [char] (5)  NULL ,
	[tuestarttime2] [char] (5)  NULL ,
	[tueendtime2] [char] (5)  NULL ,
	[wedstarttime1] [char] (5)  NULL ,
	[wedendtime1] [char] (5)  NULL ,
	[wedstarttime2] [char] (5)  NULL ,
	[wedendtime2] [char] (5)  NULL ,
	[thustarttime1] [char] (5)  NULL ,
	[thuendtime1] [char] (5)  NULL ,
	[thustarttime2] [char] (5)  NULL ,
	[thuendtime2] [char] (5)  NULL ,
	[fristarttime1] [char] (5)  NULL ,
	[friendtime1] [char] (5)  NULL ,
	[fristarttime2] [char] (5)  NULL ,
	[friendtime2] [char] (5)  NULL ,
	[satstarttime1] [char] (5)  NULL ,
	[satendtime1] [char] (5)  NULL ,
	[satstarttime2] [char] (5)  NULL ,
	[satendtime2] [char] (5)  NULL ,
	[sunstarttime1] [char] (5)  NULL ,
	[sunendtime1] [char] (5)  NULL ,
	[sunstarttime2] [char] (5)  NULL ,
	[sunendtime2] [char] (5)  NULL ,
	[totaltime] [char] (5)  NULL ,
	[scheduletype] [char] (1)  NULL 
)
GO

CREATE TABLE [HrmScheduleDiff] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[diffname] [varchar] (60)  NULL ,
	[diffdesc] [varchar] (200)  NULL ,
	[difftype] [char] (1)  NULL ,
	[difftime] [char] (1)  NULL ,
	[mindifftime] [smallint] NULL ,
	[workflowid] [int] NULL ,
	[salaryable] [char] (1)  NULL ,
	[counttype] [char] (1)  NULL ,
	[countnum] [decimal](10, 3) NULL ,
	[currencyid] [int] NULL ,
	[docid] [int] NULL ,
	[diffremark] [text]  NULL 
) 
GO

CREATE TABLE [HrmSearchMould] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mouldname] [varchar] (200)  NULL ,
	[userid] [int] NULL ,
	[resourceid] [int] NULL ,
	[resourcename] [varchar] (60)  NULL ,
	[jobtitle] [int] NULL ,
	[activitydesc] [varchar] (200)  NULL ,
	[jobgroup] [int] NULL ,
	[jobactivity] [int] NULL ,
	[costcenter] [int] NULL ,
	[competency] [int] NULL ,
	[resourcetype] [char] (1)  NULL ,
	[status] [char] (1)  NULL ,
	[subcompany1] [int] NULL ,
	[subcompany2] [int] NULL ,
	[subcompany3] [int] NULL ,
	[subcompany4] [int] NULL ,
	[department] [int] NULL ,
	[location] [int] NULL ,
	[manager] [int] NULL ,
	[assistant] [int] NULL ,
	[roles] [int] NULL ,
	[seclevel] [tinyint] NULL ,
	[joblevel] [tinyint] NULL ,
	[workroom] [varchar] (60)  NULL ,
	[telephone] [varchar] (60)  NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[contractdate] [char] (10)  NULL ,
	[birthday] [char] (10)  NULL ,
	[sex] [char] (1)  NULL ,
	[seclevelTo] [tinyint] NULL ,
	[joblevelTo] [tinyint] NULL ,
	[startdateTo] [char] (10)  NULL ,
	[enddateTo] [char] (10)  NULL ,
	[contractdateTo] [char] (10)  NULL ,
	[birthdayTo] [char] (10)  NULL ,
	[age] [int] NULL ,
	[ageTo] [int] NULL 
)
GO

CREATE TABLE [HrmSpeciality] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (60)  NULL 
)
GO

CREATE TABLE [HrmSubCompany] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[subcompanyname] [varchar] (200)  NULL ,
	[subcompanydesc] [varchar] (200)  NULL ,
	[companyid] [tinyint] NULL ,
	[isdefault] [char] (1)  NULL 
)
GO

CREATE TABLE [HrmTrainRecord] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[trainstartdate] [char] (10)  NULL ,
	[trainenddate] [char] (10)  NULL ,
	[traintype] [int] NULL ,
	[trainrecord] [text]  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL ,
	[trainhour] [decimal](18, 3) NULL ,
	[trainunit] [varchar] (100)  NULL 
) 
GO

CREATE TABLE [HrmTrainType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (60)  NULL 
)
GO

CREATE TABLE [HrmUseKind] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (60)  NULL 
)
GO

CREATE TABLE [HrmUserDefine] (
	[userid] [int] NULL ,
	[hasresourceid] [char] (1)  NULL ,
	[hasresourcename] [char] (1)  NULL ,
	[hasjobtitle] [char] (1)  NULL ,
	[hasactivitydesc] [char] (1)  NULL ,
	[hasjobgroup] [char] (1)  NULL ,
	[hasjobactivity] [char] (1)  NULL ,
	[hascostcenter] [char] (1)  NULL ,
	[hascompetency] [char] (1)  NULL ,
	[hasresourcetype] [char] (1)  NULL ,
	[hasstatus] [char] (1)  NULL ,
	[hassubcompany] [char] (1)  NULL ,
	[hasdepartment] [char] (1)  NULL ,
	[haslocation] [char] (1)  NULL ,
	[hasmanager] [char] (1)  NULL ,
	[hasassistant] [char] (1)  NULL ,
	[hasroles] [char] (1)  NULL ,
	[hasseclevel] [char] (1)  NULL ,
	[hasjoblevel] [char] (1)  NULL ,
	[hasworkroom] [char] (1)  NULL ,
	[hastelephone] [char] (1)  NULL ,
	[hasstartdate] [char] (1)  NULL ,
	[hasenddate] [char] (1)  NULL ,
	[hascontractdate] [char] (1)  NULL ,
	[hasbirthday] [char] (1)  NULL ,
	[hassex] [char] (1)  NULL ,
	[projectable] [char] (1)  NULL ,
	[crmable] [char] (1)  NULL ,
	[itemable] [char] (1)  NULL ,
	[docable] [char] (1)  NULL ,
	[workflowable] [char] (1)  NULL ,
	[subordinateable] [char] (1)  NULL ,
	[trainable] [char] (1)  NULL ,
	[budgetable] [char] (1)  NULL ,
	[fnatranable] [char] (1)  NULL ,
	[dspperpage] [tinyint] NULL ,
	[hasage] [char] (1)  NULL 
)
GO

CREATE TABLE [HrmWelfare] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[datefrom] [char] (10)  NULL ,
	[dateto] [char] (10)  NULL ,
	[basesalary] [decimal](18, 2) NULL ,
	[homesub] [decimal](18, 2) NULL ,
	[vehiclesub] [decimal](18, 2) NULL ,
	[mealsub] [decimal](18, 2) NULL ,
	[othersub] [decimal](18, 2) NULL ,
	[adjustreason] [varchar] (200)  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL 
)
GO

CREATE TABLE [HrmWorkResume] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[company] [varchar] (100)  NULL ,
	[companystyle] [int] NULL ,
	[jobtitle] [varchar] (30)  NULL ,
	[workdesc] [text]  NULL ,
	[leavereason] [varchar] (200)  NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL 
) 
GO

CREATE TABLE [HrmWorkResumeIn] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[datefrom] [char] (10)  NULL ,
	[dateto] [char] (10)  NULL ,
	[departmentid] [int] NULL ,
	[jobtitle] [int] NULL ,
	[joblevel] [tinyint] NULL ,
	[createid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[lastmodtime] [char] (8)  NULL 
)
GO

CREATE TABLE [HtmlLabelIndex] (
	[id] [int] NOT NULL ,
	[indexdesc] [varchar] (100)  NULL 
)
GO

CREATE TABLE [HtmlLabelInfo] (
	[indexid] [int] NULL ,
	[labelname] [varchar] (100)  NULL ,
	[languageid] [tinyint] NULL 
)
GO

CREATE TABLE [HtmlNoteIndex] (
	[id] [int] NOT NULL ,
	[indexdesc] [varchar] (40)  NULL 
)
GO

CREATE TABLE [HtmlNoteInfo] (
	[indexid] [int] NULL ,
	[notename] [varchar] (200)  NULL ,
	[languageid] [tinyint] NULL 
)
GO

CREATE TABLE [IT] (
	[inner1] [varchar] (255)  NULL ,
	[lx1] [varchar] (255)  NULL ,
	[lx2] [varchar] (255)  NULL ,
	[mc] [varchar] (255)  NULL ,
	[bh] [varchar] (255)  NULL ,
	[bm] [varchar] (255)  NULL ,
	[syr] [varchar] (255)  NULL ,
	[zt] [varchar] (255)  NULL ,
	[ggxh] [varchar] (255)  NULL ,
	[jg] [float] NULL ,
	[rq] [varchar] (255)  NULL ,
	[bz] [varchar] (255)  NULL 
)
GO

CREATE TABLE [ImageFile] (
	[imagefileid] [int] NOT NULL ,
	[imagefilename] [varchar] (200)  NULL ,
	[imagefiletype] [varchar] (50)  NULL ,
	[imagefile] [image] NULL ,
	[imagefileused] [int] NULL 
) 
GO

CREATE TABLE [LgcAsset] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[assetmark] [varchar] (60)  NULL ,
	[barcode] [varchar] (30)  NULL ,
	[seclevel] [tinyint] NULL ,
	[assetimageid] [int] NULL ,
	[assettypeid] [int] NULL ,
	[assetunitid] [int] NULL ,
	[replaceassetid] [int] NULL ,
	[assetversion] [varchar] (20)  NULL ,
	[assetattribute] [varchar] (100)  NULL ,
	[counttypeid] [int] NULL ,
	[assortmentid] [int] NULL ,
	[assortmentstr] [varchar] (200)  NULL ,
	[relatewfid] [int] NULL 
)
GO

CREATE TABLE [LgcAssetAssortment] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[assortmentmark] [varchar] (60)  NULL ,
	[assortmentname] [varchar] (60)  NULL ,
	[seclevel] [tinyint] NULL ,
	[resourceid] [int] NULL ,
	[assortmentimageid] [int] NULL ,
	[assortmentremark] [text]  NULL ,
	[supassortmentid] [int] NULL ,
	[supassortmentstr] [varchar] (200)  NULL ,
	[subassortmentcount] [int] NULL ,
	[assetcount] [int] NULL ,
	[dff01name] [varchar] (100)  NULL ,
	[dff01use] [tinyint] NULL ,
	[dff02name] [varchar] (100)  NULL ,
	[dff02use] [tinyint] NULL ,
	[dff03name] [varchar] (100)  NULL ,
	[dff03use] [tinyint] NULL ,
	[dff04name] [varchar] (100)  NULL ,
	[dff04use] [tinyint] NULL ,
	[dff05name] [varchar] (100)  NULL ,
	[dff05use] [tinyint] NULL ,
	[nff01name] [varchar] (100)  NULL ,
	[nff01use] [tinyint] NULL ,
	[nff02name] [varchar] (100)  NULL ,
	[nff02use] [tinyint] NULL ,
	[nff03name] [varchar] (100)  NULL ,
	[nff03use] [tinyint] NULL ,
	[nff04name] [varchar] (100)  NULL ,
	[nff04use] [tinyint] NULL ,
	[nff05name] [varchar] (100)  NULL ,
	[nff05use] [tinyint] NULL ,
	[tff01name] [varchar] (100)  NULL ,
	[tff01use] [tinyint] NULL ,
	[tff02name] [varchar] (100)  NULL ,
	[tff02use] [tinyint] NULL ,
	[tff03name] [varchar] (100)  NULL ,
	[tff03use] [tinyint] NULL ,
	[tff04name] [varchar] (100)  NULL ,
	[tff04use] [tinyint] NULL ,
	[tff05name] [varchar] (100)  NULL ,
	[tff05use] [tinyint] NULL ,
	[bff01name] [varchar] (100)  NULL ,
	[bff01use] [tinyint] NULL ,
	[bff02name] [varchar] (100)  NULL ,
	[bff02use] [tinyint] NULL ,
	[bff03name] [varchar] (100)  NULL ,
	[bff03use] [tinyint] NULL ,
	[bff04name] [varchar] (100)  NULL ,
	[bff04use] [tinyint] NULL ,
	[bff05name] [varchar] (100)  NULL ,
	[bff05use] [tinyint] NULL 
) 
GO

CREATE TABLE [LgcAssetCountry] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[assetid] [int] NULL ,
	[assetname] [varchar] (60)  NULL ,
	[assetcountyid] [int] NULL ,
	[startdate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[assetremark] [text]  NULL ,
	[currencyid] [int] NULL ,
	[salesprice] [decimal](18, 3) NULL ,
	[costprice] [decimal](18, 3) NULL ,
	[datefield1] [char] (10)  NULL ,
	[datefield2] [char] (10)  NULL ,
	[datefield3] [char] (10)  NULL ,
	[datefield4] [char] (10)  NULL ,
	[datefield5] [char] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [char] (1)  NULL ,
	[tinyintfield2] [char] (1)  NULL ,
	[tinyintfield3] [char] (1)  NULL ,
	[tinyintfield4] [char] (1)  NULL ,
	[tinyintfield5] [char] (1)  NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL ,
	[isdefault] [char] (1)  NULL 
) 
GO

CREATE TABLE [LgcAssetCrm] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[assetid] [int] NULL ,
	[crmid] [int] NULL ,
	[countryid] [int] NULL ,
	[ismain] [char] (1)  NULL ,
	[assetcode] [char] (60)  NULL ,
	[currencyid] [int] NULL ,
	[purchaseprice] [decimal](18, 3) NULL ,
	[taxrate] [int] NULL ,
	[unitid] [int] NULL ,
	[packageunit] [varchar] (100)  NULL ,
	[supplyremark] [text]  NULL ,
	[docid] [int] NULL ,
	[contractid] [int] NULL 
) 
GO

CREATE TABLE [LgcAssetPrice] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[assetid] [int] NULL ,
	[assetcountyid] [int] NULL ,
	[pricedesc] [varchar] (200)  NULL ,
	[numfrom] [int] NULL ,
	[numto] [int] NULL ,
	[currencyid] [int] NULL ,
	[unitprice] [decimal](18, 3) NULL ,
	[taxrate] [int] NULL 
)
GO

CREATE TABLE [LgcAssetRelationType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typename] [varchar] (60)  NULL ,
	[typedesc] [varchar] (200)  NULL ,
	[typekind] [char] (1)  NULL ,
	[shopadvice] [char] (1)  NULL ,
	[contractlimit] [char] (1)  NULL 
)
GO

CREATE TABLE [LgcAssetStock] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[warehouseid] [int] NOT NULL ,
	[assetid] [int] NOT NULL ,
	[stocknum] [float] NULL ,
	[unitprice] [decimal](18, 3) NULL 
)
GO

CREATE TABLE [LgcAssetType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typemark] [varchar] (60)  NULL ,
	[typename] [varchar] (60)  NULL ,
	[typedesc] [varchar] (200)  NULL 
)
GO

CREATE TABLE [LgcAssetUnit] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[unitmark] [varchar] (60)  NULL ,
	[unitname] [varchar] (60)  NULL ,
	[unitdesc] [varchar] (200)  NULL 
)
GO

CREATE TABLE [LgcCatalogs] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[catalogname] [varchar] (60)  NULL ,
	[catalogdesc] [varchar] (200)  NULL ,
	[catalogorder] [int] NULL ,
	[perpage] [int] NULL ,
	[seclevelfrom] [tinyint] NULL ,
	[seclevelto] [tinyint] NULL ,
	[navibardsp] [char] (1)  NULL ,
	[navibarbgcolor] [char] (6)  NULL ,
	[navibarfontcolor] [char] (6)  NULL ,
	[navibarfontsize] [varchar] (20)  NULL ,
	[navibarfonttype] [varchar] (20)  NULL ,
	[toolbardsp] [char] (1)  NULL ,
	[toolbarwidth] [int] NULL ,
	[toolbarbgcolor] [char] (6)  NULL ,
	[toolbarfontcolor] [char] (6)  NULL ,
	[toolbarlinkbgcolor] [char] (6)  NULL ,
	[toolbarlinkfontcolor] [char] (6)  NULL ,
	[toolbarfontsize] [varchar] (20)  NULL ,
	[toolbarfonttype] [varchar] (20)  NULL ,
	[countrydsp] [char] (1)  NULL ,
	[countrydeftype] [char] (1)  NULL ,
	[countryid] [int] NULL ,
	[searchbyname] [char] (1)  NULL ,
	[searchbycrm] [char] (1)  NULL ,
	[searchadv] [char] (1)  NULL ,
	[assortmentdsp] [char] (1)  NULL ,
	[assortmentname] [varchar] (60)  NULL ,
	[assortmentsql] [text]  NULL ,
	[attributedsp] [char] (1)  NULL ,
	[attributecol] [int] NULL ,
	[attributefontsize] [varchar] (20)  NULL ,
	[attributefonttype] [varchar] (20)  NULL ,
	[assetsql] [text]  NULL ,
	[assetcol1] [varchar] (40)  NULL ,
	[assetcol2] [varchar] (40)  NULL ,
	[assetcol3] [varchar] (40)  NULL ,
	[assetcol4] [varchar] (40)  NULL ,
	[assetcol5] [varchar] (40)  NULL ,
	[assetcol6] [varchar] (40)  NULL ,
	[assetfontsize] [varchar] (40)  NULL ,
	[assetfonttype] [varchar] (40)  NULL ,
	[webshopdap] [char] (1)  NULL ,
	[webshoptype] [char] (1)  NULL ,
	[webshopreturn] [char] (1)  NULL ,
	[webshopmanageid] [int] NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[lastmoderid] [int] NULL ,
	[lastmoddate] [char] (10)  NULL 
) 
GO

CREATE TABLE [LgcConfiguration] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[supassetid] [int] NULL ,
	[subassetid] [int] NULL ,
	[relationtypeid] [int] NULL 
)
GO

CREATE TABLE [LgcCountType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typename] [varchar] (60)  NULL ,
	[typedesc] [varchar] (200)  NULL ,
	[salesinid] [int] NULL ,
	[salescostid] [int] NULL ,
	[salestaxid] [int] NULL ,
	[purchasetaxid] [int] NULL ,
	[stockid] [int] NULL ,
	[stockdiffid] [int] NULL ,
	[producecostid] [int] NULL 
)
GO

CREATE TABLE [LgcPaymentType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typename] [varchar] (60)  NULL ,
	[typedesc] [varchar] (200)  NULL ,
	[paymentid] [int] NULL 
)
GO

CREATE TABLE [LgcRelateWorkflow] (
	[id] [int] NULL ,
	[name] [varchar] (80)  NULL 
)
GO

CREATE TABLE [LgcSearchDefine] (
	[userid] [int] NULL ,
	[hasassetmark] [char] (1)  NULL ,
	[hasassetname] [char] (1)  NULL ,
	[hasassetcountry] [char] (1)  NULL ,
	[hasassetassortment] [char] (1)  NULL ,
	[hasassetstatus] [char] (1)  NULL ,
	[hasassettype] [char] (1)  NULL ,
	[hasassetversion] [char] (1)  NULL ,
	[hasassetattribute] [char] (1)  NULL ,
	[hasassetsalesprice] [char] (1)  NULL ,
	[hasdepartment] [char] (1)  NULL ,
	[hasresource] [char] (1)  NULL ,
	[hascrm] [char] (1)  NULL ,
	[perpage] [int] NULL ,
	[assetcol1] [varchar] (40)  NULL ,
	[assetcol2] [varchar] (40)  NULL ,
	[assetcol3] [varchar] (40)  NULL ,
	[assetcol4] [varchar] (40)  NULL ,
	[assetcol5] [varchar] (40)  NULL ,
	[assetcol6] [varchar] (40)  NULL 
)
GO

CREATE TABLE [LgcSearchMould] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mouldname] [varchar] (200)  NULL ,
	[userid] [int] NULL ,
	[assetmark] [varchar] (60)  NULL ,
	[assetname] [varchar] (60)  NULL ,
	[assetcountry] [int] NULL ,
	[assetassortment] [int] NULL ,
	[assetstatus] [char] (1)  NULL ,
	[assettype] [int] NULL ,
	[assetversion] [varchar] (20)  NULL ,
	[assetattribute] [varchar] (100)  NULL ,
	[assetsalespricefrom] [decimal](18, 3) NULL ,
	[assetsalespriceto] [decimal](18, 3) NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[crmid] [int] NULL 
)
GO

CREATE TABLE [LgcStockInOut] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[instockno] [int] NULL ,
	[outstockno] [int] NULL ,
	[warehouseid] [int] NULL ,
	[stockdate] [char] (10)  NULL ,
	[departmentid] [int] NULL ,
	[costcenterid] [int] NULL ,
	[resourceid] [int] NULL ,
	[crmid] [int] NULL ,
	[projectid] [int] NULL ,
	[docid] [int] NULL ,
	[stockmodeid] [int] NULL ,
	[modetype] [char] (1)  NULL ,
	[relativeid] [int] NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[currencyid] [int] NULL ,
	[defcurrencyid] [int] NULL ,
	[exchangerate] [decimal](18, 3) NULL ,
	[defcountprice] [decimal](18, 3) NULL ,
	[defcounttax] [decimal](18, 3) NULL ,
	[countprice] [decimal](18, 3) NULL ,
	[counttax] [decimal](18, 3) NULL ,
	[stockremark] [varchar] (200)  NULL ,
	[status] [char] (1)  NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL 
)
GO

CREATE TABLE [LgcStockInOutDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[inoutid] [int] NULL ,
	[assetid] [int] NULL ,
	[batchmark] [varchar] (20)  NULL ,
	[number_n] [float] NULL ,
	[currencyid] [int] NULL ,
	[defcurrencyid] [int] NULL ,
	[exchangerate] [decimal](18, 3) NULL ,
	[defunitprice] [decimal](18, 3) NULL ,
	[unitprice] [decimal](18, 3) NULL ,
	[taxrate] [int] NULL 
)
GO

CREATE TABLE [LgcStockMode] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[modename] [varchar] (60)  NULL ,
	[modetype] [char] (1)  NULL ,
	[modestatus] [char] (1)  NULL ,
	[modedesc] [varchar] (200)  NULL 
)
GO

CREATE TABLE [LgcWarehouse] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[warehousename] [varchar] (40)  NULL ,
	[warehousedesc] [varchar] (200)  NULL ,
	[roleid] [int] NULL 
)
GO

CREATE TABLE [LgcWebShop] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[usertype] [tinyint] NULL ,
	[userid] [int] NULL ,
	[username] [varchar] (60)  NULL ,
	[usercountry] [int] NULL ,
	[useremail] [varchar] (60)  NULL ,
	[receiveaddress] [varchar] (200)  NULL ,
	[receivetype] [int] NULL ,
	[postcode] [varchar] (10)  NULL ,
	[telephone1] [varchar] (20)  NULL ,
	[telephone2] [varchar] (20)  NULL ,
	[paymentmode] [varchar] (2)  NULL ,
	[currencyid] [int] NULL ,
	[purchasecount] [decimal](18, 3) NULL ,
	[purchaseremark] [text]  NULL ,
	[purchasedate] [char] (10)  NULL ,
	[purchasestatus] [char] (1)  NULL ,
	[manageid] [int] NULL 
) 
GO

CREATE TABLE [LgcWebShopDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[webshopid] [int] NULL ,
	[assetid] [int] NULL ,
	[countryid] [int] NULL ,
	[currencyid] [int] NULL ,
	[assetprice] [decimal](18, 3) NULL ,
	[taxrate] [int] NULL ,
	[purchasenum] [float] NULL 
)
GO

CREATE TABLE [LgcWebShopReceiveType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typename] [varchar] (60)  NULL ,
	[typeesc] [text]  NULL ,
	[typecountry] [int] NULL 
) 
GO

CREATE TABLE [MailPassword] (
	[resourceid] [int] NOT NULL ,
	[resourcemail] [varchar] (60)  NULL ,
	[password] [varchar] (40)  NULL 
)
GO

CREATE TABLE [MailResource] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NULL ,
	[priority] [char] (1)  NULL ,
	[sendfrom] [varchar] (200)  NULL ,
	[sendcc] [varchar] (200)  NULL ,
	[sendbcc] [varchar] (200)  NULL ,
	[sendto] [varchar] (200)  NULL ,
	[senddate] [varchar] (30)  NULL ,
	[size_n] [int] NULL ,
	[subject] [varchar] (250)  NULL ,
	[content] [text]  NULL ,
	[mailtype] [char] (1)  NULL 
) 
GO

CREATE TABLE [MailResourceFile] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mailid] [int] NULL ,
	[filename] [varchar] (100)  NULL ,
	[attachfile] [image] NULL ,
	[filetype] [varchar] (60)  NULL 
) 
GO

CREATE TABLE [MailShare] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mailgroupid] [int] NULL ,
	[sharetype] [tinyint] NULL ,
	[seclevel] [tinyint] NULL ,
	[rolelevel] [tinyint] NULL ,
	[sharelevel] [tinyint] NULL ,
	[userid] [int] NULL ,
	[subcompanyid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [tinyint] NULL ,
	[sharedcrm] [int] NULL 
)
GO

CREATE TABLE [MailUser] (
	[mailgroupid] [int] NULL ,
	[resourceid] [int] NULL 
)
GO

CREATE TABLE [MailUserAddress] (
	[mailgroupid] [int] NULL ,
	[mailaddress] [varchar] (255)  NULL ,
	[maildesc] [varchar] (255)  NULL 
)
GO

CREATE TABLE [MailUserGroup] (
	[mailgroupid] [int] IDENTITY (1, 1) NOT NULL ,
	[mailgroupname] [varchar] (200)  NULL ,
	[operatedesc] [varchar] (255)  NULL ,
	[createrid] [int] NULL ,
	[createrdate] [char] (10)  NULL 
)
GO

CREATE TABLE [MailUserShare] (
	[mailgroupid] [int] NULL ,
	[userid] [int] NULL 
)
GO

CREATE TABLE [Meeting] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingtype] [int] NULL ,
	[name] [varchar] (255)  NULL ,
	[caller] [int] NULL ,
	[contacter] [int] NULL ,
	[address] [int] NULL ,
	[begindate] [varchar] (10)  NULL ,
	[begintime] [varchar] (8)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[endtime] [varchar] (8)  NULL ,
	[desc_n] [varchar] (255)  NULL ,
	[creater] [int] NULL ,
	[createdate] [varchar] (10)  NULL ,
	[createtime] [varchar] (8)  NULL ,
	[approver] [int] NULL ,
	[approvedate] [varchar] (10)  NULL ,
	[approvetime] [varchar] (8)  NULL ,
	[isapproved] [tinyint] NULL ,
	[isdecision] [tinyint] NULL ,
	[decision] [text]  NULL ,
	[decisiondocid] [int] NULL ,
	[decisiondate] [varchar] (10)  NULL ,
	[decisiontime] [varchar] (8)  NULL ,
	[decisionhrmid] [int] NULL ,
	[projectid] [int] NULL ,
	[totalmember] [int] NULL ,
	[othermembers] [text]  NULL ,
	[othersremark] [text]  NULL ,
	[addressdesc] [varchar] (255)  NULL 
) 
GO

CREATE TABLE [MeetingCaller] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingtype] [int] NULL ,
	[callertype] [int] NULL ,
	[seclevel] [int] NULL ,
	[rolelevel] [int] NULL ,
	[userid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [int] NULL 
)
GO

CREATE TABLE [Meeting_Address] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingtype] [int] NULL ,
	[addressid] [int] NULL ,
	[desc_n] [varchar] (255)  NULL 
)
GO

CREATE TABLE [Meeting_Decision] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingid] [int] NULL ,
	[requestid] [int] NULL ,
	[coding] [varchar] (100)  NULL ,
	[subject] [varchar] (255)  NULL ,
	[hrmid01] [varchar] (255)  NULL ,
	[hrmid02] [int] NULL ,
	[begindate] [varchar] (10)  NULL ,
	[begintime] [varchar] (8)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[endtime] [varchar] (8)  NULL 
)
GO

CREATE TABLE [Meeting_Member] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingtype] [int] NULL ,
	[membertype] [tinyint] NULL ,
	[memberid] [int] NULL ,
	[desc_n] [varchar] (255)  NULL 
)
GO

CREATE TABLE [Meeting_Member2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingid] [int] NULL ,
	[membertype] [tinyint] NULL ,
	[memberid] [int] NULL ,
	[membermanager] [int] NULL ,
	[isattend] [varchar] (50)  NULL ,
	[begindate] [varchar] (10)  NULL ,
	[begintime] [varchar] (8)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[endtime] [varchar] (8)  NULL ,
	[bookroom] [varchar] (50)  NULL ,
	[roomstander] [varchar] (50)  NULL ,
	[bookticket] [varchar] (50)  NULL ,
	[ticketstander] [varchar] (50)  NULL ,
	[othermember] [varchar] (255)  NULL 
)
GO

CREATE TABLE [Meeting_MemberCrm] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingid] [int] NULL ,
	[memberrecid] [int] NULL ,
	[name] [varchar] (100)  NULL ,
	[sex] [tinyint] NULL ,
	[occupation] [varchar] (100)  NULL ,
	[tel] [varchar] (100)  NULL ,
	[handset] [varchar] (100)  NULL ,
	[desc_n] [varchar] (255)  NULL 
)
GO

CREATE TABLE [Meeting_Service] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingtype] [int] NULL ,
	[hrmid] [int] NULL ,
	[name] [varchar] (255)  NULL ,
	[desc_n] [varchar] (255)  NULL 
)
GO

CREATE TABLE [Meeting_Service2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingid] [int] NULL ,
	[hrmid] [int] NULL ,
	[name] [varchar] (255)  NULL ,
	[desc_n] [varchar] (255)  NULL 
)
GO

CREATE TABLE [Meeting_Topic] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingid] [int] NULL ,
	[subject] [varchar] (255)  NULL ,
	[hrmid] [int] NULL ,
	[isopen] [tinyint] NULL ,
	[hrmids] [varchar] (255)  NULL ,
	[projid] [int] NULL ,
	[crmid] [int] NULL 
)
GO

CREATE TABLE [Meeting_TopicDate] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingid] [int] NULL ,
	[topicid] [int] NULL ,
	[begindate] [varchar] (10)  NULL ,
	[begintime] [varchar] (8)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[endtime] [varchar] (8)  NULL 
)
GO

CREATE TABLE [Meeting_TopicDoc] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[meetingid] [int] NULL ,
	[topicid] [int] NULL ,
	[docid] [int] NULL ,
	[hrmid] [int] NULL 
)
GO

CREATE TABLE [Meeting_Type] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (255)  NULL ,
	[approver] [int] NULL ,
	[desc_n] [varchar] (255)  NULL 
)
GO

CREATE TABLE [NewDocFrontpage] (
	[usertype] [int] NULL ,
	[userid] [int] NULL ,
	[docid] [int] NULL 
)
GO

CREATE TABLE [PrjShareDetail] (
	[prjid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [int] NULL ,
	[sharelevel] [int] NULL 
)
GO

CREATE TABLE [Prj_Cpt] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[isactived] [tinyint] NULL ,
	[version] [tinyint] NULL ,
	[requestid] [int] NULL ,
	[type] [tinyint] NULL 
)
GO

CREATE TABLE [Prj_Customer] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[customerid] [int] NULL ,
	[powerlevel] [tinyint] NULL ,
	[reasondesc] [varchar] (100)  NULL 
)
GO

CREATE TABLE [Prj_Doc] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[isactived] [tinyint] NULL ,
	[version] [tinyint] NULL ,
	[docid] [int] NULL ,
	[type] [tinyint] NULL 
)
GO

CREATE TABLE [Prj_Jianbao] (
	[projectid] [int] NULL ,
	[type] [char] (2)  NULL ,
	[documentid] [int] NULL ,
	[content] [varchar] (255)  NULL ,
	[submitdate] [varchar] (10)  NULL ,
	[submittime] [varchar] (8)  NULL ,
	[submiter] [int] NULL ,
	[clientip] [char] (15)  NULL ,
	[submitertype] [tinyint] NULL 
)
GO

CREATE TABLE [Prj_Log] (
	[projectid] [int] NULL ,
	[logtype] [char] (2)  NULL ,
	[documentid] [int] NULL ,
	[logcontent] [varchar] (255)  NULL ,
	[submitdate] [varchar] (10)  NULL ,
	[submittime] [varchar] (8)  NULL ,
	[submiter] [int] NULL ,
	[clientip] [char] (15)  NULL ,
	[submitertype] [tinyint] NULL 
)
GO

CREATE TABLE [Prj_Material] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[material] [varchar] (100)  NULL ,
	[unit] [varchar] (10)  NULL ,
	[version] [varchar] (200)  NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[quantity] [int] NULL ,
	[cost] [decimal](10, 2) NULL 
)
GO

CREATE TABLE [Prj_MaterialProcess] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[material] [varchar] (100)  NULL ,
	[unit] [varchar] (10)  NULL ,
	[isactived] [tinyint] NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[quantity] [int] NULL ,
	[cost] [decimal](10, 2) NULL 
)
GO

CREATE TABLE [Prj_Member] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[relateid] [int] NOT NULL ,
	[version] [varchar] (200)  NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[workday] [decimal](10, 1) NULL ,
	[cost] [decimal](10, 2) NULL 
)
GO

CREATE TABLE [Prj_MemberProcess] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[relateid] [int] NOT NULL ,
	[isactived] [tinyint] NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[workday] [decimal](10, 1) NULL ,
	[cost] [decimal](10, 2) NULL 
)
GO

CREATE TABLE [Prj_Modify] (
	[projectid] [int] NULL ,
	[type] [char] (20)  NULL ,
	[fieldname] [varchar] (100)  NULL ,
	[modifydate] [varchar] (10)  NULL ,
	[modifytime] [varchar] (8)  NULL ,
	[original] [varchar] (255)  NULL ,
	[modified] [varchar] (255)  NULL ,
	[modifier] [int] NULL ,
	[clientip] [char] (15)  NULL ,
	[submitertype] [tinyint] NULL 
)
GO

CREATE TABLE [Prj_PlanInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[subject] [varchar] (50)  NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[begintime] [varchar] (8)  NULL ,
	[endtime] [varchar] (8)  NULL ,
	[resourceid] [int] NULL ,
	[content] [varchar] (255)  NULL ,
	[budgetmoney] [varchar] (50)  NULL ,
	[docid] [int] NULL ,
	[plansort] [int] NULL ,
	[plantype] [int] NULL ,
	[updatedate] [varchar] (10)  NULL ,
	[updatetime] [varchar] (5)  NULL ,
	[updater] [int] NULL ,
	[validate_n] [int] NULL 
)
GO

CREATE TABLE [Prj_PlanSort] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [Prj_PlanType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [Prj_Processing] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[planid] [int] NULL ,
	[title] [varchar] (50)  NULL ,
	[content] [varchar] (255)  NULL ,
	[type] [int] NULL ,
	[docid] [int] NULL ,
	[parentids] [varchar] (255)  NULL ,
	[submitdate] [varchar] (10)  NULL ,
	[submittime] [varchar] (5)  NULL ,
	[submiter] [int] NULL ,
	[updatedate] [varchar] (10)  NULL ,
	[updatetime] [varchar] (5)  NULL ,
	[updater] [int] NULL ,
	[isprocessed] [tinyint] NULL ,
	[processdate] [varchar] (10)  NULL ,
	[processtime] [varchar] (8)  NULL ,
	[processor] [int] NULL 
)
GO

CREATE TABLE [Prj_ProcessingType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (30)  NULL ,
	[description] [varchar] (150)  NULL ,
	[isdefault] [tinyint] NULL 
)
GO

CREATE TABLE [Prj_ProjectInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50)  NULL ,
	[description] [varchar] (250)  NULL ,
	[prjtype] [int] NULL ,
	[worktype] [int] NULL ,
	[securelevel] [int] NULL ,
	[status] [int] NULL ,
	[isblock] [tinyint] NULL ,
	[managerview] [tinyint] NULL ,
	[parentview] [tinyint] NULL ,
	[budgetmoney] [money] NULL ,
	[moneyindeed] [money] NULL ,
	[budgetincome] [money] NULL ,
	[imcomeindeed] [money] NULL ,
	[planbegindate] [varchar] (10)  NULL ,
	[planbegintime] [varchar] (5)  NULL ,
	[planenddate] [varchar] (10)  NULL ,
	[planendtime] [varchar] (5)  NULL ,
	[truebegindate] [varchar] (10)  NULL ,
	[truebegintime] [varchar] (5)  NULL ,
	[trueenddate] [varchar] (10)  NULL ,
	[trueendtime] [varchar] (5)  NULL ,
	[planmanhour] [int] NULL ,
	[truemanhour] [int] NULL ,
	[picid] [int] NULL ,
	[intro] [varchar] (255)  NULL ,
	[parentid] [int] NULL ,
	[envaluedoc] [int] NULL ,
	[confirmdoc] [int] NULL ,
	[proposedoc] [int] NULL ,
	[manager] [int] NULL ,
	[department] [int] NULL ,
	[creater] [int] NULL ,
	[createdate] [varchar] (10)  NULL ,
	[createtime] [varchar] (8)  NULL ,
	[isprocessed] [tinyint] NULL ,
	[processer] [int] NULL ,
	[processdate] [varchar] (10)  NULL ,
	[processtime] [varchar] (8)  NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL ,
	[subcompanyid1] [int] NULL 
)
GO

CREATE TABLE [Prj_ProjectStatus] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [Prj_ProjectType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL ,
	[wfid] [int] NULL 
)
GO

CREATE TABLE [Prj_Request] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[isactived] [tinyint] NULL ,
	[version] [tinyint] NULL ,
	[requestid] [int] NULL ,
	[type] [tinyint] NULL 
)
GO

CREATE TABLE [Prj_SearchMould] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[mouldname] [varchar] (200)  NULL ,
	[userid] [int] NULL ,
	[prjid] [int] NULL ,
	[status] [varchar] (60)  NULL ,
	[prjtype] [varchar] (60)  NULL ,
	[worktype] [varchar] (60)  NULL ,
	[nameopt] [int] NULL ,
	[name] [varchar] (60)  NULL ,
	[description] [varchar] (250)  NULL ,
	[customer] [int] NULL ,
	[parent] [int] NULL ,
	[securelevel] [int] NULL ,
	[department] [int] NULL ,
	[manager] [int] NULL ,
	[member] [int] NULL 
)
GO

CREATE TABLE [Prj_ShareInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[relateditemid] [int] NULL ,
	[sharetype] [tinyint] NULL ,
	[seclevel] [tinyint] NULL ,
	[rolelevel] [tinyint] NULL ,
	[sharelevel] [tinyint] NULL ,
	[userid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [tinyint] NULL ,
	[crmid] [int] NULL 
)
GO

CREATE TABLE [Prj_TaskInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[wbscoding] [varchar] (20)  NULL ,
	[subject] [varchar] (80)  NULL ,
	[version] [tinyint] NULL ,
	[isactived] [tinyint] NULL ,
	[workday] [decimal](10, 1) NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[content] [varchar] (255)  NULL ,
	[fixedcost] [decimal](10, 2) NULL ,
	[parentid] [int] NULL ,
	[parentids] [varchar] (255)  NULL ,
	[level_n] [tinyint] NULL ,
	[hrmid] [int] NULL ,
	[parenthrmids] [varchar] (255)  NULL ,
	[isdelete] [tinyint] NULL ,
	[childnum] [int] NULL 
)
GO

CREATE TABLE [Prj_TaskProcess] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[isactived] [tinyint] NULL ,
	[version] [tinyint] NULL ,
	[workday] [decimal](10, 1) NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[content] [varchar] (255)  NULL ,
	[fixedcost] [decimal](10, 2) NULL ,
	[finish] [tinyint] NULL ,
	[wbscoding] [varchar] (20)  NULL ,
	[subject] [varchar] (80)  NULL ,
	[parentid] [int] NULL ,
	[parentids] [varchar] (255)  NULL ,
	[level_n] [tinyint] NULL ,
	[hrmid] [int] NULL ,
	[parenthrmids] [varchar] (255)  NULL ,
	[isdelete] [tinyint] NULL ,
	[childnum] [int] NULL 
)
GO

CREATE TABLE [Prj_Tool] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[relateid] [int] NOT NULL ,
	[version] [varchar] (200)  NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[workday] [decimal](10, 1) NULL ,
	[cost] [decimal](10, 2) NULL 
)
GO

CREATE TABLE [Prj_ToolProcess] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[prjid] [int] NULL ,
	[taskid] [int] NULL ,
	[relateid] [int] NOT NULL ,
	[isactived] [tinyint] NULL ,
	[begindate] [varchar] (10)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[workday] [int] NULL ,
	[cost] [decimal](10, 1) NULL 
)
GO

CREATE TABLE [Prj_ViewLog] (
	[projectid] [int] NULL ,
	[type] [int] NULL ,
	[modifydate] [varchar] (10)  NULL ,
	[modifytime] [varchar] (8)  NULL ,
	[modifier] [int] NULL ,
	[clientip] [char] (15)  NULL 
)
GO

CREATE TABLE [Prj_ViewLog1] (
	[id] [int] NOT NULL ,
	[viewer] [int] NULL ,
	[viewdate] [char] (10)  NULL ,
	[viewtime] [char] (8)  NULL ,
	[ipaddress] [char] (15)  NULL ,
	[submitertype] [tinyint] NULL 
)
GO

CREATE TABLE [Prj_WorkType] (
	[id] [int] IDENTITY (40, 1) NOT NULL ,
	[fullname] [varchar] (50)  NULL ,
	[description] [varchar] (150)  NULL 
)
GO

CREATE TABLE [ProcedureInfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[procedurename] [varchar] (100)  NULL ,
	[proceduretabel] [varchar] (200)  NULL ,
	[procedurescript] [text]  NULL ,
	[proceduredesc] [text]  NULL 
) 
GO

CREATE TABLE [SequenceIndex] (
	[indexdesc] [varchar] (40)  NULL ,
	[currentid] [int] NULL 
)
GO

CREATE TABLE [SysFavourite] (
	[Resourceid] [int] NULL ,
	[Adddate] [char] (10)  NULL ,
	[Addtime] [char] (8)  NULL ,
	[Pagename] [varchar] (150)  NULL ,
	[URL] [varchar] (100)  NULL ,
	[id] [int] IDENTITY (1, 1) NOT NULL 
)
GO

CREATE TABLE [SysMaintenanceLog] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[relatedid] [int] NOT NULL ,
	[relatedname] [varchar] (200)  NOT NULL ,
	[operatetype] [varchar] (2)  NOT NULL ,
	[operatedesc] [text]  NULL ,
	[operateitem] [varchar] (3)  NOT NULL ,
	[operateuserid] [int] NOT NULL ,
	[operatedate] [char] (10)  NOT NULL ,
	[operatetime] [char] (8)  NOT NULL ,
	[clientaddress] [char] (15)  NULL 
) 
GO

CREATE TABLE [SysRemindInfo] (
	[userid] [int] NULL ,
	[usertype] [int] NULL ,
	[hascrmcontact] [tinyint] NULL ,
	[hasnewwf] [text]  NULL ,
	[hasdealwf] [tinyint] NULL ,
	[hasendwf] [text]  NULL ,
	[haspasstimenode] [tinyint] NULL ,
	[hasapprovedoc] [tinyint] NULL ,
	[hasdealdoc] [tinyint] NULL ,
	[hasnewemail] [tinyint] NULL 
) 
GO

CREATE TABLE [Sys_Slogan] (
	[slogan] [varchar] (255)  NULL ,
	[speed] [tinyint] NULL ,
	[fontcolor] [char] (6)  NULL ,
	[backcolor] [char] (6)  NULL 
)
GO

CREATE TABLE [SystemLog] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (7)  NULL ,
	[classname] [varchar] (30)  NULL ,
	[sqlstr] [text]  NULL 
) 
GO

CREATE TABLE [SystemLogItem] (
	[itemid] [varchar] (3)  NULL ,
	[lableid] [int] NULL ,
	[itemdesc] [varchar] (40)  NULL 
)
GO

CREATE TABLE [SystemRightDetail] (
	[id] [int] NOT NULL ,
	[rightdetailname] [varchar] (100)  NULL ,
	[rightdetail] [varchar] (100)  NULL ,
	[rightid] [int] NULL 
)
GO

CREATE TABLE [SystemRightGroups] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[rightgroupmark] [varchar] (60)  NULL ,
	[rightgroupname] [varchar] (200)  NULL ,
	[rightgroupremark] [text]  NULL 
) 
GO

CREATE TABLE [SystemRightRoles] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[rightid] [int] NULL ,
	[roleid] [int] NULL ,
	[rolelevel] [char] (1)  NULL 
)
GO

CREATE TABLE [SystemRightToGroup] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[groupid] [int] NULL ,
	[rightid] [int] NULL 
)
GO

CREATE TABLE [SystemRights] (
	[id] [int] NULL ,
	[rightdesc] [varchar] (200)  NULL ,
	[righttype] [char] (1)  NULL 
)
GO

CREATE TABLE [SystemRightsLanguage] (
	[id] [int] NULL ,
	[languageid] [int] NULL ,
	[rightname] [varchar] (100)  NULL ,
	[rightdesc] [varchar] (100)  NULL 
)
GO

CREATE TABLE [SystemSet] (
	[emailserver] [varchar] (60)  NULL ,
	[debugmode] [char] (1)  NULL ,
	[logleaveday] [tinyint] NULL 
)
GO

CREATE TABLE [Weather] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[thedate] [char] (10)  NULL ,
	[picid] [int] NULL ,
	[thedesc] [varchar] (100)  NULL ,
	[temperature] [varchar] (100)  NULL 
)
GO

CREATE TABLE [WorkflowReportShare] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[reportid] [int] NULL ,
	[sharetype] [int] NULL ,
	[seclevel] [tinyint] NULL ,
	[rolelevel] [tinyint] NULL ,
	[sharelevel] [tinyint] NULL ,
	[userid] [int] NULL ,
	[subcompanyid] [int] NULL ,
	[departmentid] [int] NULL ,
	[roleid] [int] NULL ,
	[foralluser] [tinyint] NULL ,
	[crmid] [int] NULL 
)
GO

CREATE TABLE [WorkflowReportShareDetail] (
	[reportid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [int] NULL ,
	[sharelevel] [int] NULL 
)
GO

CREATE TABLE [Workflow_Report] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[reportname] [varchar] (100)  NULL ,
	[reporttype] [int] NULL ,
	[reportwfid] [int] NULL 
)
GO

CREATE TABLE [Workflow_ReportDspField] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[reportid] [int] NULL ,
	[fieldid] [int] NULL ,
	[dsporder] [int] NULL ,
	[isstat] [char] (1)  NULL ,
	[dborder] [char] (1)  NULL 
)
GO

CREATE TABLE [Workflow_ReportType] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typename] [varchar] (60)  NULL ,
	[typedesc] [varchar] (250)  NULL ,
	[typeorder] [int] NULL 
)
GO

CREATE TABLE [bgyp] (
	[lx1] [varchar] (255)  NULL ,
	[lx2] [varchar] (255)  NULL ,
	[mc] [varchar] (255)  NULL ,
	[bh] [varchar] (255)  NULL ,
	[ggxh] [varchar] (255)  NULL ,
	[jg] [float] NULL ,
	[kc] [float] NULL ,
	[bz] [varchar] (255)  NULL 
)
GO

CREATE TABLE [bgyp2] (
	[lx1] [varchar] (255)  NULL ,
	[lx2] [varchar] (255)  NULL ,
	[mc] [varchar] (255)  NULL ,
	[gly] [varchar] (50)  NULL ,
	[bh] [varchar] (255)  NULL ,
	[ggxh] [varchar] (255)  NULL ,
	[jg] [float] NULL ,
	[kc] [float] NULL ,
	[bz] [varchar] (255)  NULL 
)
GO

CREATE TABLE [bill_Approve] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[approveid] [int] NULL ,
	[approvetype] [int] NULL ,
	[gopage] [varchar] (200)  NULL ,
	[manager] [int] NULL ,
	[status] [char] (1)  NULL ,
	[needlawcheck] [char] (1)  NULL ,
	[president] [int] NULL 
)
GO

CREATE TABLE [bill_BudgetDetail] (
	[departmentid] [int] NULL ,
	[feeid] [int] NULL ,
	[month] [int] NULL ,
	[budget] [decimal](10, 2) NULL ,
	[year] [int] NULL 
)
GO

CREATE TABLE [bill_CptAdjustDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptadjustid] [int] NULL ,
	[cptid] [int] NULL ,
	[number_n] [int] NULL ,
	[unitprice] [decimal](10, 2) NULL ,
	[amount] [decimal](10, 2) NULL ,
	[cptstatus] [int] NULL ,
	[needdate] [varchar] (10)  NULL ,
	[purpose] [varchar] (60)  NULL ,
	[cptdesc] [varchar] (60)  NULL ,
	[capitalid] [int] NULL 
)
GO

CREATE TABLE [bill_CptAdjustMain] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[olddepartmentid] [int] NULL ,
	[relatecrm] [int] NULL ,
	[relatedoc] [int] NULL ,
	[relatecpt] [int] NULL ,
	[relatereq] [int] NULL ,
	[manager] [int] NULL ,
	[totalamount] [decimal](10, 2) NULL ,
	[groupid] [int] NULL ,
	[requestid] [int] NULL ,
	[realizedate] [varchar] (10)  NULL 
)
GO

CREATE TABLE [bill_CptApplyDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptapplyid] [int] NULL ,
	[cpttype] [int] NULL ,
	[cptid] [int] NULL ,
	[number_n] [int] NULL ,
	[unitprice] [decimal](10, 2) NULL ,
	[amount] [decimal](10, 2) NULL ,
	[needdate] [varchar] (10)  NULL ,
	[purpose] [varchar] (60)  NULL ,
	[cptdesc] [varchar] (60)  NULL ,
	[capitalid] [int] NULL 
)
GO

CREATE TABLE [bill_CptApplyMain] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[groupid] [int] NULL ,
	[totalamount] [decimal](10, 3) NULL ,
	[relatecrm] [int] NULL ,
	[relatedoc] [int] NULL ,
	[relatecpt] [int] NULL ,
	[relatereq] [int] NULL ,
	[manager] [int] NULL 
)
GO

CREATE TABLE [bill_CptCarFee] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[usedate] [varchar] (10)  NULL ,
	[driver] [int] NULL ,
	[carno] [int] NULL ,
	[oilfee] [decimal](10, 2) NULL ,
	[bridgefee] [decimal](10, 2) NULL ,
	[fixfee] [decimal](10, 2) NULL ,
	[phonefee] [decimal](10, 2) NULL ,
	[cleanfee] [decimal](10, 2) NULL ,
	[remax] [varchar] (255)  NULL 
)
GO

CREATE TABLE [bill_CptCarFix] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[usedate] [varchar] (10)  NULL ,
	[driver] [int] NULL ,
	[carno] [int] NULL ,
	[fixfee] [decimal](10, 2) NULL ,
	[remax] [varchar] (255)  NULL 
)
GO

CREATE TABLE [bill_CptCarMantant] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[usedate] [varchar] (10)  NULL ,
	[driver] [int] NULL ,
	[carno] [int] NULL ,
	[mantantfee] [decimal](10, 2) NULL ,
	[remax] [varchar] (255)  NULL 
)
GO

CREATE TABLE [bill_CptCarOut] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[usedate] [varchar] (10)  NULL ,
	[driver] [int] NULL ,
	[carno] [int] NULL ,
	[begindate] [varchar] (10)  NULL ,
	[begintime] [varchar] (5)  NULL ,
	[enddate] [varchar] (10)  NULL ,
	[endtime] [varchar] (5)  NULL ,
	[frompos] [varchar] (255)  NULL ,
	[beginnumber] [decimal](10, 3) NULL ,
	[endnumber] [decimal](10, 3) NULL ,
	[number_n] [decimal](10, 3) NULL ,
	[userid] [int] NULL ,
	[userdepid] [int] NULL ,
	[isotherplace] [int] NULL 
)
GO

CREATE TABLE [bill_CptCheckDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptcheckid] [int] NULL ,
	[cptid] [int] NULL ,
	[theorynumber] [int] NULL ,
	[realnumber] [int] NULL ,
	[price] [decimal](10, 2) NULL ,
	[remark] [varchar] (250)  NULL 
)
GO

CREATE TABLE [bill_CptCheckMain] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[checkresourceid2] [int] NULL ,
	[checkdate] [char] (10)  NULL ,
	[relatecrm] [int] NULL ,
	[relatedoc] [int] NULL ,
	[relatecpt] [int] NULL ,
	[relatereq] [int] NULL ,
	[assortment] [int] NULL ,
	[groupid] [int] NULL ,
	[requestid] [int] NULL 
)
GO

CREATE TABLE [bill_CptFetchDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptfetchid] [int] NULL ,
	[cptid] [int] NULL ,
	[number_n] [int] NULL ,
	[unitprice] [decimal](10, 2) NULL ,
	[amount] [decimal](10, 2) NULL ,
	[needdate] [varchar] (10)  NULL ,
	[purpose] [varchar] (60)  NULL ,
	[cptdesc] [varchar] (60)  NULL ,
	[capitalid] [int] NULL 
)
GO

CREATE TABLE [bill_CptFetchMain] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[relatecrm] [int] NULL ,
	[relatedoc] [int] NULL ,
	[relatecpt] [int] NULL ,
	[relatereq] [int] NULL ,
	[totalamount] [decimal](10, 3) NULL ,
	[groupid] [int] NULL ,
	[requestid] [int] NULL ,
	[realizedate] [varchar] (10)  NULL 
)
GO

CREATE TABLE [bill_CptPlanDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptplanid] [int] NULL ,
	[cptid] [int] NULL ,
	[number_n] [int] NULL ,
	[unitprice] [decimal](10, 2) NULL ,
	[amount] [decimal](10, 2) NULL ,
	[needdate] [varchar] (10)  NULL ,
	[purpose] [varchar] (60)  NULL ,
	[cptdesc] [varchar] (60)  NULL 
)
GO

CREATE TABLE [bill_CptPlanMain] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[totalamount] [decimal](10, 3) NULL ,
	[relatecrm] [int] NULL ,
	[relatedoc] [int] NULL ,
	[groupid] [int] NULL ,
	[requestid] [int] NULL 
)
GO

CREATE TABLE [bill_CptRequireDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptrequireid] [int] NULL ,
	[cpttype] [int] NULL ,
	[cptid] [int] NULL ,
	[number_n] [int] NULL ,
	[unitprice] [decimal](10, 2) NULL ,
	[needdate] [varchar] (10)  NULL ,
	[purpose] [varchar] (60)  NULL ,
	[cptdesc] [varchar] (60)  NULL ,
	[buynumber] [int] NULL ,
	[adjustnumber] [int] NULL ,
	[fetchnumber] [int] NULL 
)
GO

CREATE TABLE [bill_CptRequireMain] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[groupid] [int] NULL ,
	[relatecrm] [int] NULL ,
	[relatedoc] [int] NULL ,
	[relatecpt] [int] NULL ,
	[relatereq] [int] NULL ,
	[buynumbers] [decimal](10, 3) NULL 
)
GO

CREATE TABLE [bill_CptStockInDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptstockinid] [int] NULL ,
	[cptno] [varchar] (50)  NULL ,
	[cptid] [int] NULL ,
	[cpttype] [varchar] (80)  NULL ,
	[plannumber] [int] NULL ,
	[innumber] [int] NULL ,
	[planprice] [decimal](10, 2) NULL ,
	[inprice] [decimal](10, 2) NULL ,
	[planamount] [decimal](10, 2) NULL ,
	[inamount] [decimal](10, 2) NULL ,
	[difprice] [decimal](10, 2) NULL ,
	[capitalid] [int] NULL 
)
GO

CREATE TABLE [bill_CptStockInMain] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[departmentid] [int] NULL ,
	[resourceid] [int] NULL ,
	[buyerid] [int] NULL ,
	[checkerid] [int] NULL ,
	[comefrom] [varchar] (80)  NULL ,
	[billnumber] [varchar] (80)  NULL ,
	[warehouse] [varchar] (80)  NULL ,
	[stockindate] [char] (10)  NULL ,
	[relatecrm] [int] NULL ,
	[relatedoc] [int] NULL ,
	[relatecpt] [int] NULL ,
	[relatereq] [int] NULL ,
	[groupid] [int] NULL ,
	[requestid] [int] NULL ,
	[realizedate] [varchar] (10)  NULL 
)
GO

CREATE TABLE [bill_Discuss] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[accepterid] [text]  NULL ,
	[subject] [varchar] (255)  NULL ,
	[isend] [char] (1)  NULL ,
	[projectid] [int] NULL ,
	[crmid] [int] NULL ,
	[relatedrequestid] [int] NULL ,
	[alldoc] [text]  NULL ,
	[status] [char] (1)  NULL 
) 
GO

CREATE TABLE [bill_HireResource] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[begindate] [char] (10)  NULL ,
	[jobtitle] [int] NULL ,
	[jobcompetence] [text]  NULL ,
	[jobdesc] [text]  NULL ,
	[relateddoc] [int] NULL ,
	[receiver] [int] NULL ,
	[manager] [int] NULL ,
	[cptgivetype] [char] (1)  NULL ,
	[status] [char] (1)  NULL 
) 
GO

CREATE TABLE [bill_HotelBook] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[begindate] [char] (10)  NULL ,
	[enddate] [char] (10)  NULL ,
	[payterm] [int] NULL ,
	[liveperson] [varchar] (100)  NULL ,
	[amount] [decimal](10, 3) NULL ,
	[status] [char] (1)  NULL ,
	[reason] [text]  NULL ,
	[relatedcrmid] [int] NULL ,
	[relateddocid] [int] NULL ,
	[relatedrequestid] [int] NULL ,
	[livecompany] [varchar] (200)  NULL 
) 
GO

CREATE TABLE [bill_HotelBookDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[bookid] [int] NULL ,
	[hotelid] [int] NULL ,
	[roomstyle] [varchar] (50)  NULL ,
	[roomsum] [int] NULL 
)
GO

CREATE TABLE [bill_HrmFinance] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NOT NULL ,
	[requestid] [int] NULL ,
	[billid] [int] NULL ,
	[basictype] [int] NULL ,
	[detailtype] [int] NULL ,
	[amount] [decimal](10, 3) NULL ,
	[crmid] [int] NULL ,
	[projectid] [int] NULL ,
	[docid] [int] NULL ,
	[capitalid] [int] NULL ,
	[departmentid] [int] NULL ,
	[name] [varchar] (50)  NULL ,
	[description] [varchar] (250)  NULL ,
	[remark] [text]  NULL ,
	[occurdate] [char] (10)  NULL ,
	[occurtime] [char] (8)  NULL ,
	[relatedrequestid] [int] NULL ,
	[relatedresource] [varchar] (250)  NULL ,
	[accessory] [int] NULL ,
	[debitledgeid] [int] NULL ,
	[debitremark] [varchar] (250)  NULL ,
	[creditledgeid] [int] NULL ,
	[creditremark] [varchar] (250)  NULL ,
	[currencyid] [int] NULL ,
	[exchangerate] [varchar] (20)  NULL ,
	[status] [char] (1)  NULL ,
	[manager] [int] NULL ,
	[isoverrule] [char] (1)  NULL ,
	[needapprove] [char] (1)  NULL ,
	[returndate] [char] (10)  NULL ,
	[isremind] [int] NULL 
) 
GO

CREATE TABLE [bill_HrmTime] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[resourceid] [int] NOT NULL ,
	[requestid] [int] NULL ,
	[billid] [int] NULL ,
	[basictype] [int] NULL ,
	[detailtype] [int] NULL ,
	[begindate] [char] (10)  NULL ,
	[begintime] [char] (8)  NULL ,
	[enddate] [char] (10)  NULL ,
	[endtime] [char] (8)  NULL ,
	[name] [varchar] (50)  NULL ,
	[description] [varchar] (255)  NULL ,
	[remark] [text]  NULL ,
	[totaldays] [int] NULL ,
	[totalhours] [decimal](8, 3) NULL ,
	[progress] [decimal](8, 3) NULL ,
	[projectid] [int] NULL ,
	[crmid] [int] NULL ,
	[docid] [int] NULL ,
	[relatedrequestid] [int] NULL ,
	[status] [char] (1)  NULL ,
	[customizeint1] [int] NULL ,
	[customizeint2] [int] NULL ,
	[customizeint3] [int] NULL ,
	[customizefloat1] [decimal](8, 3) NULL ,
	[customizestr1] [varchar] (255)  NULL ,
	[customizestr2] [varchar] (255)  NULL ,
	[manager] [int] NULL ,
	[departmentid] [int] NULL ,
	[wakedate] [char] (10)  NULL ,
	[waketime] [char] (8)  NULL ,
	[isremind] [int] NULL ,
	[accepterid] [text]  NULL ,
	[allrequest] [text]  NULL ,
	[isopen] [int] NULL ,
	[alldoc] [text]  NULL ,
	[delaydate] [char] (10)  NULL 
) 
GO

CREATE TABLE [bill_LeaveJob] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[leavedate] [char] (10)  NULL ,
	[leavedesc] [text]  NULL ,
	[relateddoc] [int] NULL ,
	[receiver] [int] NULL ,
	[manager] [int] NULL ,
	[status] [char] (1)  NULL 
) 
GO

CREATE TABLE [bill_MailboxApply] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[reason] [text]  NULL ,
	[mailid] [varchar] (50)  NULL ,
	[status] [char] (1)  NULL ,
	[realid] [varchar] (50)  NULL ,
	[startdate] [char] (10)  NULL ,
	[passresource] [int] NULL 
) 
GO

CREATE TABLE [bill_NameCard] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[reason] [int] NULL ,
	[printnum] [int] NULL ,
	[printoption] [int] NULL ,
	[status] [char] (1)  NULL ,
	[amountpercase] [decimal](10, 3) NULL ,
	[totalamount] [decimal](10, 3) NULL ,
	[printcompany] [int] NULL ,
	[itemnumber] [varchar] (50)  NULL ,
	[getdate] [char] (10)  NULL 
)
GO

CREATE TABLE [bill_NameCardinfo] (
	[resourceid] [int] NOT NULL ,
	[cname] [varchar] (50)  NULL ,
	[cjobtitle] [varchar] (50)  NULL ,
	[cdepartment] [varchar] (100)  NULL ,
	[ename] [varchar] (50)  NULL ,
	[ejobtitle] [varchar] (50)  NULL ,
	[edepartment] [varchar] (100)  NULL ,
	[phone] [varchar] (50)  NULL ,
	[mobile] [varchar] (50)  NULL ,
	[email] [varchar] (50)  NULL 
)
GO

CREATE TABLE [bill_TotalBudget] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[target] [text]  NULL ,
	[relateddoc] [int] NULL ,
	[relatedrequest] [int] NULL ,
	[manager] [int] NULL ,
	[status] [char] (1)  NULL 
) 
GO

CREATE TABLE [bill_contract] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[contractno] [varchar] (30)  NULL ,
	[departmentid] [int] NULL ,
	[costcenterid] [int] NULL ,
	[resourceid] [int] NULL ,
	[crmid] [int] NULL ,
	[projectid] [int] NULL ,
	[docid] [int] NULL ,
	[defcurrencyid] [int] NULL ,
	[currencyid] [int] NULL ,
	[exchangerate] [decimal](10, 3) NULL ,
	[defcountprice] [decimal](18, 3) NULL ,
	[defcounttax] [decimal](18, 3) NULL ,
	[countprice] [decimal](18, 3) NULL ,
	[counttax] [decimal](18, 3) NULL ,
	[contractremark] [text]  NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL 
) 
GO

CREATE TABLE [bill_contractdetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[contractid] [int] NULL ,
	[assetid] [int] NULL ,
	[batchmark] [varchar] (20)  NULL ,
	[number_n] [float] NULL ,
	[currencyid] [int] NULL ,
	[defcurrencyid] [int] NULL ,
	[exchangerate] [decimal](18, 3) NULL ,
	[defunitprice] [decimal](18, 3) NULL ,
	[unitprice] [decimal](18, 3) NULL ,
	[taxrate] [int] NULL 
)
GO

CREATE TABLE [bill_itemusage] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[itemid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[relateproj] [int] NULL ,
	[relatecrm] [int] NULL ,
	[begindate] [char] (10)  NULL ,
	[begintime] [char] (8)  NULL ,
	[enddate] [char] (10)  NULL ,
	[endtime] [char] (8)  NULL ,
	[info] [text]  NULL ,
	[datefield1] [varchar] (10)  NULL ,
	[datefield2] [varchar] (10)  NULL ,
	[datefield3] [varchar] (10)  NULL ,
	[datefield4] [varchar] (10)  NULL ,
	[datefield5] [varchar] (10)  NULL ,
	[numberfield1] [float] NULL ,
	[numberfield2] [float] NULL ,
	[numberfield3] [float] NULL ,
	[numberfield4] [float] NULL ,
	[numberfield5] [float] NULL ,
	[textfield1] [varchar] (100)  NULL ,
	[textfield2] [varchar] (100)  NULL ,
	[textfield3] [varchar] (100)  NULL ,
	[textfield4] [varchar] (100)  NULL ,
	[textfield5] [varchar] (100)  NULL ,
	[tinyintfield1] [tinyint] NULL ,
	[tinyintfield2] [tinyint] NULL ,
	[tinyintfield3] [tinyint] NULL ,
	[tinyintfield4] [tinyint] NULL ,
	[tinyintfield5] [tinyint] NULL ,
	[usestatus] [char] (1)  NULL 
) 
GO

CREATE TABLE [bill_monthinfodetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[infoid] [int] NULL ,
	[type] [int] NULL ,
	[targetname] [varchar] (250)  NULL ,
	[targetresult] [text]  NULL ,
	[forecastdate] [char] (10)  NULL ,
	[scale] [decimal](10, 3) NULL ,
	[point] [varchar] (5)  NULL 
) 
GO

CREATE TABLE [bill_weekinfodetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[infoid] [int] NULL ,
	[type] [int] NULL ,
	[workname] [varchar] (250)  NULL ,
	[workdesc] [text]  NULL ,
	[forecastdate] [char] (10)  NULL 
) 
GO

CREATE TABLE [bill_workinfo] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NULL ,
	[requestid] [int] NULL ,
	[resourceid] [int] NULL ,
	[departmentid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[thismonth] [int] NULL ,
	[thisweek] [int] NULL ,
	[analysis] [text]  NULL ,
	[advice] [text]  NULL ,
	[manager] [int] NULL ,
	[seclevel] [int] NULL ,
	[status] [char] (1)  NULL ,
	[mainid] [int] NULL 
) 
GO

CREATE TABLE [bjb] (
	[lx1] [varchar] (255)  NULL ,
	[lx2] [float] NULL ,
	[bh] [varchar] (255)  NULL ,
	[bm] [varchar] (255)  NULL ,
	[syr] [varchar] (255)  NULL ,
	[ggxh] [varchar] (255)  NULL ,
	[rq] [varchar] (255)  NULL ,
	[jg] [float] NULL ,
	[bz] [varchar] (255)  NULL 
)
GO

CREATE TABLE [it2] (
	[lx1] [varchar] (255)  NULL ,
	[lx2] [varchar] (255)  NULL ,
	[mc] [varchar] (255)  NULL ,
	[ggxh] [varchar] (255)  NULL ,
	[jg] [float] NULL 
)
GO

CREATE TABLE [notit] (
	[inner1] [varchar] (255)  NULL ,
	[bh] [varchar] (255)  NULL ,
	[lx1] [varchar] (255)  NULL ,
	[lx2] [varchar] (255)  NULL ,
	[mc] [varchar] (255)  NULL ,
	[sl] [float] NULL ,
	[bm] [varchar] (255)  NULL ,
	[syr] [varchar] (255)  NULL ,
	[zt] [varchar] (255)  NULL ,
	[ggxh] [varchar] (255)  NULL ,
	[jg] [float] NULL ,
	[rq] [datetime] NULL ,
	[bz] [varchar] (255)  NULL 
)
GO

CREATE TABLE [notit2] (
	[lx1] [varchar] (255)  NULL ,
	[lx2] [varchar] (255)  NULL ,
	[mc] [varchar] (255)  NULL ,
	[jg] [float] NULL 
)
GO

CREATE TABLE [syslanguage] (
	[id] [int] NULL ,
	[language] [varchar] (30)  NULL ,
	[encoding] [varchar] (30)  NULL ,
	[activable] [char] (1)  NULL 
)
GO

CREATE TABLE [tsj] (
	[lx1] [varchar] (255)  NULL ,
	[lx2] [float] NULL ,
	[bh] [varchar] (255)  NULL ,
	[bm] [varchar] (255)  NULL ,
	[syr] [varchar] (255)  NULL ,
	[bz] [varchar] (255)  NULL ,
	[jg] [float] NULL ,
	[rq] [varchar] (255)  NULL ,
	[ggxh] [varchar] (50)  NULL 
)
GO

CREATE TABLE [workflow_RequestUserDefault] (
	[userid] [int] NULL ,
	[selectedworkflow] [text]  NULL ,
	[isuserdefault] [char] (1)  NULL 
) 
GO

CREATE TABLE [workflow_SelectItem] (
	[fieldid] [int] NULL ,
	[isbill] [int] NULL ,
	[selectvalue] [int] NULL ,
	[selectname] [varchar] (250)  NULL 
)
GO

CREATE TABLE [workflow_StaticRpbase] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[reportid] [int] NULL ,
	[name] [varchar] (50)  NULL ,
	[description] [varchar] (250)  NULL ,
	[pagename] [varchar] (50)  NULL ,
	[module] [int] NULL 
)
GO

CREATE TABLE [workflow_addinoperate] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[objid] [int] NULL ,
	[isnode] [int] NULL ,
	[workflowid] [int] NULL ,
	[fieldid] [int] NULL ,
	[fieldop1id] [int] NULL ,
	[fieldop2id] [int] NULL ,
	[operation] [int] NULL ,
	[customervalue] [varchar] (255)  NULL ,
	[rules] [int] NULL 
)
GO

CREATE TABLE [workflow_base] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[workflowname] [varchar] (60)  NULL ,
	[workflowdesc] [varchar] (100)  NULL ,
	[workflowtype] [int] NULL ,
	[securelevel] [varchar] (3)  NULL ,
	[formid] [int] NULL ,
	[userid] [int] NULL ,
	[isbill] [char] (1)  NULL ,
	[iscust] [int] NULL ,
	[helpdocid] [int] NULL ,
	[isvalid] [char] (1)  NULL 
)
GO

CREATE TABLE [workflow_bill] (
	[id] [int] NOT NULL ,
	[namelabel] [int] NULL ,
	[tablename] [varchar] (60)  NULL ,
	[createpage] [varchar] (255)  NULL ,
	[managepage] [varchar] (255)  NULL ,
	[viewpage] [varchar] (255)  NULL ,
	[detailtablename] [varchar] (60)  NULL ,
	[detailkeyfield] [varchar] (60)  NULL 
)
GO

CREATE TABLE [workflow_billfield] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[billid] [int] NOT NULL ,
	[fieldname] [varchar] (60)  NULL ,
	[fieldlabel] [int] NULL ,
	[fielddbtype] [varchar] (40)  NULL ,
	[fieldhtmltype] [char] (1)  NULL ,
	[type] [int] NULL ,
	[dsporder] [int] NULL ,
	[viewtype] [int] NULL 
)
GO

CREATE TABLE [workflow_browserurl] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[labelid] [int] NULL ,
	[fielddbtype] [varchar] (40)  NULL ,
	[browserurl] [varchar] (255)  NULL ,
	[tablename] [varchar] (50)  NULL ,
	[columname] [varchar] (50)  NULL ,
	[keycolumname] [varchar] (50)  NULL ,
	[linkurl] [varchar] (255)  NULL 
)
GO

CREATE TABLE [workflow_createrlist] (
	[workflowid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [int] NULL 
)
GO

CREATE TABLE [workflow_currentoperator] (
	[requestid] [int] NOT NULL ,
	[userid] [int] NULL ,
	[groupid] [int] NULL ,
	[workflowid] [int] NULL ,
	[workflowtype] [int] NULL ,
	[isremark] [char] (1)  NULL ,
	[usertype] [int] NULL 
)
GO

CREATE TABLE [workflow_fieldlable] (
	[formid] [int] NOT NULL ,
	[fieldid] [int] NOT NULL ,
	[fieldlable] [varchar] (100)  NULL ,
	[langurageid] [int] NULL ,
	[isdefault] [char] (1)  NULL 
)
GO

CREATE TABLE [workflow_flownode] (
	[workflowid] [int] NULL ,
	[nodeid] [int] NULL ,
	[nodetype] [char] (1)  NULL 
)
GO

CREATE TABLE [workflow_form] (
	[requestid] [int] NOT NULL ,
	[billformid] [int] NULL ,
	[billid] [int] NULL ,
	[document] [int] NULL ,
	[Customer] [int] NULL ,
	[Project] [int] NULL ,
	[resource_n] [int] NULL ,
	[mutiresource] [text]  NULL ,
	[remark] [text]  NULL ,
	[begindate] [char] (10)  NULL ,
	[begintime] [char] (5)  NULL ,
	[enddate] [char] (10)  NULL ,
	[endtime] [char] (5)  NULL ,
	[totaltime] [decimal](10, 3) NULL ,
	[totaldays] [int] NULL ,
	[request] [int] NULL ,
	[department] [int] NULL ,
	[subject] [varchar] (200)  NULL ,
	[manager] [int] NULL ,
	[amount] [decimal](10, 3) NULL ,
	[relatmeeting] int null
) 
GO

CREATE TABLE [workflow_formbase] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[formname] [varchar] (40)  NULL ,
	[formdesc] [varchar] (40)  NULL ,
	[securelevel] [char] (3)  NULL ,
	[userid] [int] NULL ,
	[formhtmlcode] [text]  NULL ,
	[formdate] [char] (10)  NULL 
) 
GO

CREATE TABLE [workflow_formdict] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fieldname] [varchar] (40)  NULL ,
	[fielddbtype] [varchar] (40)  NULL ,
	[fieldhtmltype] [char] (1)  NULL ,
	[type] [int] NULL 
)
GO

CREATE TABLE [workflow_formfield] (
	[formid] [int] NOT NULL ,
	[fieldid] [int] NOT NULL ,
	[fieldparameter] [varchar] (100)  NULL ,
	[needcheck] [char] (1)  NULL ,
	[checkscript] [varchar] (150)  NULL ,
	[ismultirows] [char] (1)  NULL ,
	[fieldorder] [int] NULL 
)
GO

CREATE TABLE [workflow_groupdetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[groupid] [int] NULL ,
	[type] [int] NULL ,
	[objid] [int] NULL ,
	[level_n] [int] NULL 
)
GO

CREATE TABLE [workflow_nodebase] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[nodename] [varchar] (60)  NULL ,
	[isstart] [char] (1)  NULL ,
	[isreject] [char] (1)  NULL ,
	[isreopen] [char] (1)  NULL ,
	[isend] [char] (1)  NULL ,
	[drawxpos] [int] NULL ,
	[drawypos] [int] NULL ,
	[totalgroups] [int] NULL 
)
GO

CREATE TABLE [workflow_nodeform] (
	[nodeid] [int] NULL ,
	[fieldid] [int] NULL ,
	[isview] [char] (1)  NULL ,
	[isedit] [char] (1)  NULL ,
	[ismandatory] [char] (1)  NULL 
)
GO

CREATE TABLE [workflow_nodegroup] (
	[id] [int] NOT NULL ,
	[nodeid] [int] NULL ,
	[groupname] [varchar] (60)  NULL ,
	[canview] [int] NULL 
)
GO

CREATE TABLE [workflow_nodelink] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[workflowid] [int] NULL ,
	[nodeid] [int] NULL ,
	[isreject] [char] (1)  NULL ,
	[condition] [varchar] (200)  NULL ,
	[linkname] [varchar] (60)  NULL ,
	[destnodeid] [int] NULL ,
	[directionfrom] [int] NULL ,
	[directionto] [int] NULL ,
	[x1] [int] NULL ,
	[y1] [int] NULL ,
	[x2] [int] NULL ,
	[y2] [int] NULL ,
	[x3] [int] NULL ,
	[y3] [int] NULL ,
	[x4] [int] NULL ,
	[y4] [int] NULL ,
	[x5] [int] NULL ,
	[y5] [int] NULL ,
	[nodepasstime] [float] NULL 
)
GO

CREATE TABLE [workflow_requestLog] (
	[requestid] [int] NULL ,
	[workflowid] [int] NULL ,
	[nodeid] [int] NULL ,
	[logtype] [char] (1)  NULL ,
	[operatedate] [char] (10)  NULL ,
	[operatetime] [char] (8)  NULL ,
	[operator] [int] NULL ,
	[remark] [text]  NULL ,
	[clientip] [char] (15)  NULL ,
	[operatortype] [int] NULL ,
	[destnodeid] [int] NULL 
) 
GO

CREATE TABLE [workflow_requestViewLog] (
	[id] [int] NOT NULL ,
	[viewer] [int] NULL ,
	[viewdate] [char] (10)  NULL ,
	[viewtime] [char] (8)  NULL ,
	[ipaddress] [char] (15)  NULL ,
	[viewtype] [int] NULL ,
	[currentnodeid] [int] NULL 
)
GO

CREATE TABLE [workflow_requestbase] (
	[requestid] [int] NOT NULL ,
	[workflowid] [int] NULL ,
	[lastnodeid] [int] NULL ,
	[lastnodetype] [char] (1)  NULL ,
	[currentnodeid] [int] NULL ,
	[currentnodetype] [char] (1)  NULL ,
	[status] [varchar] (50)  NULL ,
	[passedgroups] [int] NULL ,
	[totalgroups] [int] NULL ,
	[requestname] [varchar] (100)  NULL ,
	[creater] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[lastoperator] [int] NULL ,
	[lastoperatedate] [char] (10)  NULL ,
	[lastoperatetime] [char] (8)  NULL ,
	[deleted] [tinyint] NULL ,
	[creatertype] [int] NULL ,
	[lastoperatortype] [int] NULL ,
	[nodepasstime] [float] NULL ,
	[nodelefttime] [float] NULL ,
	[docids] [text]  NULL ,
	[crmids] [text]  NULL ,
	[hrmids] [text]  NULL ,
	[prjids] [text]  NULL ,
	[cptids] [text]  NULL ,
	[requestlevel] [int] NULL 
) 
GO

CREATE TABLE [workflow_requestsequence] (
	[requestid] [int] NULL 
)
GO

CREATE TABLE [workflow_sysworkflow] (
	[id] [int] NULL ,
	[name] [varchar] (250)  NULL ,
	[workflowid] [int] NULL 
)
GO

CREATE TABLE [workflow_type] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[typename] [varchar] (60)  NULL ,
	[typedesc] [varchar] (100)  NULL ,
	[dsporder] [int] NULL 
)
GO

CREATE TABLE [wrktablename75045152] (
	[requestid] [int] NOT NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[creater] [int] NULL ,
	[creatertype] [int] NULL ,
	[workflowid] [int] NULL ,
	[requestname] [varchar] (100)  NULL ,
	[status] [varchar] (50)  NULL 
)
GO

ALTER TABLE [Bill_HrmResourceAbsense] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CRM_ContactLog] WITH NOCHECK ADD 
	CONSTRAINT [PK_CRM_ContactLog_id] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CRM_CustomerContacter] WITH NOCHECK ADD 
	CONSTRAINT [PK_CRM_CustomerContacter_id] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CRM_CustomerInfo] WITH NOCHECK ADD 
	CONSTRAINT [PK_CRM_CustomerInfo_id] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CRM_SectorInfo] WITH NOCHECK ADD 
	CONSTRAINT [PK_CRM_SectorInfo_id] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CRM_ShareInfo] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptCapital] WITH NOCHECK ADD 
	CONSTRAINT [PK__CptCapital__302F0D3D] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptCapitalAssortment] WITH NOCHECK ADD 
	CONSTRAINT [PK_CptCapitalAssortment] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptCapitalGroup] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptCapitalShareInfo] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptCapitalState] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptCapitalType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptCheckStock] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptCheckStockList] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptDepreMethod1] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptDepreMethod2] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptRelateWorkflow] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptSearchMould] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [CptUseLog] WITH NOCHECK ADD 
	CONSTRAINT [PK__CptUseLog__424DBD78] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocApproveRemark] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocDetail] WITH NOCHECK ADD 
	CONSTRAINT [PK__DocDetail__32E0915F] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocDetailLog] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocFrontpage] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocImageFile] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocMailMould] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocMainCategory] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocMould] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocMouldFile] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocPicUpload] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocSearchMould] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocSecCategory] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocSecCategoryShare] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocShare] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocSubCategory] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [DocType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [ErrorMsgIndex] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaAccount] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaAccountCostcenter] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaAccountDepartment] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaAccountList] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaBudget] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaBudgetCostcenter] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaBudgetDepartment] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaBudgetDetail] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaBudgetList] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaBudgetModule] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaBudgetfeeType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaCurrency] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaCurrencyExchange] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaExpensefeeType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaIndicator] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaIndicatordetail] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaLedger] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaLedgerCategory] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaTransaction] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaTransactionDetail] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaYearsPeriods] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [FnaYearsPeriodsList] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmActivitiesCompetency] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmApplyRemark] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmBank] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCareerApply] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCareerApplyOtherInfo] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCareerInvite] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCareerWorkexp] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCertification] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCompany] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCompetency] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmComponentStat] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCostcenter] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCostcenterMainCategory] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCostcenterSubCategory] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmCountry] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmDepartment] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmEducationInfo] WITH NOCHECK ADD 
	CONSTRAINT [PK__HrmEducationInfo__208CD6FA] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmFamilyInfo] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmJobActivities] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmJobCall] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmJobGroups] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmJobTitles] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmJobType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmLanguageAbility] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmLocations] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmOtherInfoType] WITH NOCHECK ADD 
	CONSTRAINT [PK__HrmOtherInfoType__7D439ABD] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmPubHoliday] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmResource] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmResourceCompetency] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmResourceComponent] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmResourceOtherInfo] WITH NOCHECK ADD 
	CONSTRAINT [PK__HrmResourceOther__151B244E] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmResourceSkill] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmRewardsRecord] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmRewardsType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmRoleMembers] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmRoles] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmSalaryComponent] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmSalaryComponentTypes] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmSchedule] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmScheduleDiff] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmSearchMould] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmSpeciality] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmSubCompany] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmTrainRecord] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmTrainType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmUseKind] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmWelfare] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmWorkResume] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HrmWorkResumeIn] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HtmlLabelIndex] WITH NOCHECK ADD 
	CONSTRAINT [PK__HtmlLabelIndex__77BFCB91] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [HtmlNoteIndex] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [ImageFile] WITH NOCHECK ADD 
	 UNIQUE  CLUSTERED 
	(
		[imagefileid]
	)  
GO

ALTER TABLE [LgcAsset] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcAssetAssortment] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcAssetCountry] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcAssetCrm] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcAssetPrice] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcAssetRelationType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcAssetStock] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcAssetType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcAssetUnit] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcCatalogs] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcConfiguration] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcCountType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcPaymentType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcSearchMould] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcStockInOut] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcStockInOutDetail] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcStockMode] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcWarehouse] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcWebShop] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcWebShopDetail] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [LgcWebShopReceiveType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [MailPassword] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[resourceid]
	)  
GO

ALTER TABLE [MailResource] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [MailResourceFile] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [MailShare] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [MailUserGroup] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[mailgroupid]
	)  
GO

ALTER TABLE [MeetingCaller] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [Prj_ProjectInfo] WITH NOCHECK ADD 
	CONSTRAINT [PK_Prj_ProjectInfo_id] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [Prj_ShareInfo] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [ProcedureInfo] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [SysFavourite] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [SysMaintenanceLog] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [SystemLog] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [SystemRightDetail] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [SystemRightGroups] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [SystemRightRoles] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [SystemRightToGroup] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [Weather] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [WorkflowReportShare] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [Workflow_Report] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [Workflow_ReportDspField] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [Workflow_ReportType] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_Approve] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_Discuss] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_HireResource] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_HotelBook] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_HotelBookDetail] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_HrmFinance] WITH NOCHECK ADD 
	CONSTRAINT [PK__bill_HrmFinance__450A2E92] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_HrmTime] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_LeaveJob] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_MailboxApply] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_NameCard] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_NameCardinfo] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[resourceid]
	)  
GO

ALTER TABLE [bill_TotalBudget] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_monthinfodetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_bill_monthinfodetail] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_weekinfodetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_bill_weekinfodetail] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [bill_workinfo] WITH NOCHECK ADD 
	CONSTRAINT [PK__bill_workinfo__34157811] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

ALTER TABLE [workflow_addinoperate] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  
GO

 CREATE  CLUSTERED  INDEX [CptShareDetail_cptid_in] ON [CptShareDetail]([cptid]) 
GO

 CREATE  CLUSTERED  INDEX [CrmShareDetail_crmid_in] ON [CrmShareDetail]([crmid]) 
GO

 CREATE  CLUSTERED  INDEX [DocShareDetail_docid_in] ON [DocShareDetail]([docid]) 
GO

 CREATE  CLUSTERED  INDEX [errormsginfo_indexid_in] ON [ErrorMsgInfo]([indexid]) 
GO

 CREATE  CLUSTERED  INDEX [htmllabelinfo_indexid_in] ON [HtmlLabelInfo]([indexid]) 
GO

 CREATE  CLUSTERED  INDEX [htmlnoteinfo_indexid_in] ON [HtmlNoteInfo]([indexid]) 
GO

 CREATE  CLUSTERED  INDEX [PrjShareDetail_prjid_in] ON [PrjShareDetail]([prjid]) 
GO

ALTER TABLE [Bill_Meetingroom] WITH NOCHECK ADD 
	CONSTRAINT [DF__Bill_Mett__reque__6D65660B] DEFAULT (0) FOR [requestid]
GO

ALTER TABLE [CRM_CustomerInfo] WITH NOCHECK ADD 
	CONSTRAINT [DF__CRM_Custo__secle__688874F9] DEFAULT (0) FOR [seclevel]
GO

ALTER TABLE [CRM_Customize] WITH NOCHECK ADD 
	CONSTRAINT [DF__CRM_Custo__login__697C9932] DEFAULT (0) FOR [logintype]
GO

ALTER TABLE [CRM_ShareInfo] WITH NOCHECK ADD 
	CONSTRAINT [DF__CRM_Share__crmid__462A06AB] DEFAULT (0) FOR [crmid]
GO

ALTER TABLE [CptAssortmentShare] WITH NOCHECK ADD 
	CONSTRAINT [DF_CptAssortmentShare_crmid] DEFAULT (0) FOR [crmid]
GO

ALTER TABLE [CptCapitalAssortment] WITH NOCHECK ADD 
	CONSTRAINT [DF__CptCapita__subas__25B24A21] DEFAULT (0) FOR [subassortmentcount],
	CONSTRAINT [DF__CptCapita__capit__26A66E5A] DEFAULT (0) FOR [capitalcount]
GO

ALTER TABLE [CptCapitalShareInfo] WITH NOCHECK ADD 
	CONSTRAINT [DF__CptCapita__crmid__4535E272] DEFAULT (0) FOR [crmid]
GO

ALTER TABLE [CptCheckStock] WITH NOCHECK ADD 
	CONSTRAINT [DF__CptCheckS__check__452A2A23] DEFAULT ('0') FOR [checkstatus]
GO

ALTER TABLE [CptCheckStockList] WITH NOCHECK ADD 
	CONSTRAINT [DF__CptCheckS__price__480696CE] DEFAULT (0) FOR [price]
GO

ALTER TABLE [DocMainCategory] WITH NOCHECK ADD 
	CONSTRAINT [DF__DocMainCa__categ__1ED998B2] DEFAULT (0) FOR [categoryorder]
GO

ALTER TABLE [DocMould] WITH NOCHECK ADD 
	CONSTRAINT [DF__DocMould__issysd__286302EC] DEFAULT ('0') FOR [issysdefault]
GO

ALTER TABLE [DocSearchDefine] WITH NOCHECK ADD 
	 UNIQUE  NONCLUSTERED 
	(
		[userid]
	)  
GO

ALTER TABLE [DocShare] WITH NOCHECK ADD 
	CONSTRAINT [DF__DocShare__crmid__434D9A00] DEFAULT (0) FOR [crmid]
GO

ALTER TABLE [DocUserDefault] WITH NOCHECK ADD 
	 UNIQUE  NONCLUSTERED 
	(
		[userid]
	)  
GO

ALTER TABLE [ErrorMsgIndex] WITH NOCHECK ADD 
	 UNIQUE  NONCLUSTERED 
	(
		[indexdesc]
	)  
GO

ALTER TABLE [FnaLedger] WITH NOCHECK ADD 
	CONSTRAINT [DF__FnaLedger__suble__3D2915A8] DEFAULT (0) FOR [subledgercount],
	CONSTRAINT [DF__FnaLedger__inita__3E1D39E1] DEFAULT (0.000) FOR [initaccount]
GO

ALTER TABLE [FnaTransaction] WITH NOCHECK ADD 
	CONSTRAINT [DF__FnaTransa__manua__4D5F7D71] DEFAULT ('0') FOR [manual]
GO

ALTER TABLE [FnaYearsPeriodsList] WITH NOCHECK ADD 
	CONSTRAINT [DF__FnaYearsP__isclo__45BE5BA9] DEFAULT ('0') FOR [isclose],
	CONSTRAINT [DF__FnaYearsP__isact__46B27FE2] DEFAULT ('1') FOR [isactive]
GO

ALTER TABLE [HrmCareerInvite] WITH NOCHECK ADD 
	CONSTRAINT [DF__HrmCareer__caree__1AD3FDA4] DEFAULT ('0') FOR [careertype]
GO

ALTER TABLE [HrmCostcenterSubCategory] WITH NOCHECK ADD 
	CONSTRAINT [DF__HrmCostce__isdef__4F7CD00D] DEFAULT ('0') FOR [isdefault]
GO

ALTER TABLE [HrmJobTitles] WITH NOCHECK ADD 
	CONSTRAINT [DF__HrmJobTit__joble__628FA481] DEFAULT (0) FOR [joblevelfrom],
	CONSTRAINT [DF__HrmJobTit__joble__6383C8BA] DEFAULT (0) FOR [joblevelto]
GO

ALTER TABLE [HrmListValidate] WITH NOCHECK ADD 
	CONSTRAINT [DF_HrmListValidate_validate] DEFAULT (0) FOR [validate_n]
GO

ALTER TABLE [HrmPeriod] WITH NOCHECK ADD 
	 UNIQUE  NONCLUSTERED 
	(
		[departmentid]
	)  
GO

ALTER TABLE [HrmResourceCompetency] WITH NOCHECK ADD 
	CONSTRAINT [resourceid_competencyid_un] UNIQUE  NONCLUSTERED 
	(
		[resourceid],
		[competencyid]
	)  
GO

ALTER TABLE [HrmSalaryComponentTypes] WITH NOCHECK ADD 
	CONSTRAINT [DF__HrmSalary__typeo__75A278F5] DEFAULT (0) FOR [typeorder]
GO

ALTER TABLE [HrmSubCompany] WITH NOCHECK ADD 
	CONSTRAINT [DF__HrmSubCom__isdef__46E78A0C] DEFAULT ('0') FOR [isdefault]
GO

ALTER TABLE [HrmUserDefine] WITH NOCHECK ADD 
	 UNIQUE  NONCLUSTERED 
	(
		[userid]
	)  
GO

ALTER TABLE [HtmlLabelIndex] WITH NOCHECK ADD 
	CONSTRAINT [UQ__HtmlLabelIndex__78B3EFCA] UNIQUE  NONCLUSTERED 
	(
		[indexdesc]
	)  
GO

ALTER TABLE [HtmlNoteIndex] WITH NOCHECK ADD 
	 UNIQUE  NONCLUSTERED 
	(
		[indexdesc]
	)  
GO

ALTER TABLE [LgcAssetAssortment] WITH NOCHECK ADD 
	CONSTRAINT [DF__LgcAssetA__subas__69FBBC1F] DEFAULT (0) FOR [subassortmentcount],
	CONSTRAINT [DF__LgcAssetA__asset__6AEFE058] DEFAULT (0) FOR [assetcount]
GO

ALTER TABLE [LgcAssetCrm] WITH NOCHECK ADD 
	CONSTRAINT [DF__LgcAssetC__ismai__7755B73D] DEFAULT ('0') FOR [ismain]
GO

ALTER TABLE [LgcAssetStock] WITH NOCHECK ADD 
	CONSTRAINT [DF__LgcAssetS__unitp__14E61A24] DEFAULT (0) FOR [unitprice]
GO

ALTER TABLE [LgcCatalogs] WITH NOCHECK ADD 
	CONSTRAINT [DF__LgcCatalo__toolb__05A3D694] DEFAULT (200) FOR [toolbarwidth]
GO

ALTER TABLE [LgcSearchDefine] WITH NOCHECK ADD 
	CONSTRAINT [DF__LgcSearch__perpa__251C81ED] DEFAULT (20) FOR [perpage],
	 UNIQUE  NONCLUSTERED 
	(
		[userid]
	)  
GO

ALTER TABLE [LgcStockInOut] WITH NOCHECK ADD 
	CONSTRAINT [DF__LgcStockI__excha__19AACF41] DEFAULT (1) FOR [exchangerate],
	CONSTRAINT [DF__LgcStockI__count__1A9EF37A] DEFAULT (0) FOR [countprice],
	CONSTRAINT [DF__LgcStockI__count__1B9317B3] DEFAULT (0) FOR [counttax]
GO

ALTER TABLE [LgcStockInOutDetail] WITH NOCHECK ADD 
	CONSTRAINT [DF__LgcStockI__excha__2057CCD0] DEFAULT (1) FOR [exchangerate],
	CONSTRAINT [DF__LgcStockI__unitp__214BF109] DEFAULT (0) FOR [unitprice],
	CONSTRAINT [DF__LgcStockI__taxra__22401542] DEFAULT (0) FOR [taxrate]
GO

ALTER TABLE [LgcStockMode] WITH NOCHECK ADD 
	CONSTRAINT [DF__LgcStockM__modes__10216507] DEFAULT ('1') FOR [modestatus]
GO

ALTER TABLE [Meeting] WITH NOCHECK ADD 
	CONSTRAINT [DF__Meeting__isappro__3926A7F6] DEFAULT (0) FOR [isapproved],
	CONSTRAINT [DF__Meeting__isdecis__3EDF814C] DEFAULT (0) FOR [isdecision]
GO

ALTER TABLE [Prj_Cpt] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Cpt__isactiv__52269493] DEFAULT (0) FOR [isactived],
	CONSTRAINT [DF__Prj_Cpt__request__531AB8CC] DEFAULT (0) FOR [requestid],
	CONSTRAINT [DF__Prj_Cpt__type__540EDD05] DEFAULT (0) FOR [type]
GO

ALTER TABLE [Prj_Doc] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Doc__isactiv__04BA9F53] DEFAULT (0) FOR [isactived],
	CONSTRAINT [DF__Prj_Doc__docid__05AEC38C] DEFAULT (0) FOR [docid],
	CONSTRAINT [DF__Prj_Doc__type__06A2E7C5] DEFAULT (0) FOR [type]
GO

ALTER TABLE [Prj_Material] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Mater__quant__48A5B54C] DEFAULT (0) FOR [quantity],
	CONSTRAINT [DF__Prj_Materi__cost__4999D985] DEFAULT (0.00) FOR [cost]
GO

ALTER TABLE [Prj_MaterialProcess] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Mater__isact__71A7CADF] DEFAULT (0) FOR [isactived],
	CONSTRAINT [DF__Prj_Mater__quant__729BEF18] DEFAULT (0) FOR [quantity],
	CONSTRAINT [DF__Prj_Materi__cost__73901351] DEFAULT (0.00) FOR [cost]
GO

ALTER TABLE [Prj_Member] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Membe__workd__3E2826D9] DEFAULT (0.0) FOR [workday],
	CONSTRAINT [DF__Prj_Member__cost__3F1C4B12] DEFAULT (0.00) FOR [cost]
GO

ALTER TABLE [Prj_MemberProcess] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Membe__isact__59D0414E] DEFAULT (0) FOR [isactived],
	CONSTRAINT [DF__Prj_Membe__workd__5AC46587] DEFAULT (0.0) FOR [workday],
	CONSTRAINT [DF__Prj_Member__cost__5BB889C0] DEFAULT (0.00) FOR [cost]
GO

ALTER TABLE [Prj_Request] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Reque__isact__7FF5EA36] DEFAULT (0) FOR [isactived],
	CONSTRAINT [DF__Prj_Reque__reque__00EA0E6F] DEFAULT (0) FOR [requestid],
	CONSTRAINT [DF__Prj_Reques__type__01DE32A8] DEFAULT (0) FOR [type]
GO

ALTER TABLE [Prj_ShareInfo] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Share__share__3DFE09A7] DEFAULT (0) FOR [sharelevel],
	CONSTRAINT [DF__Prj_Share__crmid__4441BE39] DEFAULT (0) FOR [crmid]
GO

ALTER TABLE [Prj_TaskInfo] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_TaskI__isact__5911273F] DEFAULT (0) FOR [isactived],
	CONSTRAINT [DF__Prj_TaskI__workd__5A054B78] DEFAULT (0.0) FOR [workday],
	CONSTRAINT [DF__Prj_TaskI__fixed__5AF96FB1] DEFAULT (0.00) FOR [fixedcost],
	CONSTRAINT [DF__Prj_TaskI__paren__4C6DBB3D] DEFAULT (0) FOR [parentid],
	CONSTRAINT [DF__Prj_TaskI__level__4D61DF76] DEFAULT (1) FOR [level_n],
	CONSTRAINT [DF__Prj_TaskI__isdel__5503013E] DEFAULT (0) FOR [isdelete],
	CONSTRAINT [DF__prj_taski__child__4BA87840] DEFAULT (0) FOR [childnum]
GO

ALTER TABLE [Prj_TaskProcess] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_TaskP__isact__5CE1B823] DEFAULT (0) FOR [isactived],
	CONSTRAINT [DF__Prj_TaskP__workd__5DD5DC5C] DEFAULT (0.0) FOR [workday],
	CONSTRAINT [DF__Prj_TaskP__fixed__5ECA0095] DEFAULT (0.00) FOR [fixedcost],
	CONSTRAINT [DF__Prj_TaskP__finis__5FBE24CE] DEFAULT (0) FOR [finish],
	CONSTRAINT [DF__Prj_TaskP__paren__4E5603AF] DEFAULT (0) FOR [parentid],
	CONSTRAINT [DF__Prj_TaskP__level__4F4A27E8] DEFAULT (1) FOR [level_n],
	CONSTRAINT [DF__Prj_TaskP__isdel__55F72577] DEFAULT (0) FOR [isdelete],
	CONSTRAINT [DF__prj_taskp__child__4C9C9C79] DEFAULT (0) FOR [childnum]
GO

ALTER TABLE [Prj_Tool] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_Tool__workda__41049384] DEFAULT (0.0) FOR [workday],
	CONSTRAINT [DF__Prj_Tool__cost__41F8B7BD] DEFAULT (0.00) FOR [cost]
GO

ALTER TABLE [Prj_ToolProcess] WITH NOCHECK ADD 
	CONSTRAINT [DF__Prj_ToolP__isact__691284DE] DEFAULT (0) FOR [isactived],
	CONSTRAINT [DF__Prj_ToolP__workd__6A06A917] DEFAULT (0.0) FOR [workday],
	CONSTRAINT [DF__Prj_ToolPr__cost__6AFACD50] DEFAULT (0.0) FOR [cost]
GO

ALTER TABLE [SequenceIndex] WITH NOCHECK ADD 
	 UNIQUE  NONCLUSTERED 
	(
		[indexdesc]
	)  
GO

ALTER TABLE [SysRemindInfo] WITH NOCHECK ADD 
	CONSTRAINT [DF__SysRemind__hascr__55EC387F] DEFAULT (0) FOR [hascrmcontact],
	CONSTRAINT [DF__SysRemind__hasde__56E05CB8] DEFAULT (0) FOR [hasdealwf],
	CONSTRAINT [DF__SysRemind__haspa__57D480F1] DEFAULT (0) FOR [haspasstimenode],
	CONSTRAINT [DF__SysRemind__hasap__58C8A52A] DEFAULT (0) FOR [hasapprovedoc],
	CONSTRAINT [DF__SysRemind__hasde__59BCC963] DEFAULT (0) FOR [hasdealdoc],
	CONSTRAINT [DF__SysRemind__hasne__5AB0ED9C] DEFAULT (0) FOR [hasnewemail]
GO

ALTER TABLE [SystemLogItem] WITH NOCHECK ADD 
	 UNIQUE  NONCLUSTERED 
	(
		[itemid]
	)  
GO

ALTER TABLE [Workflow_ReportDspField] WITH NOCHECK ADD 
	CONSTRAINT [DF__Workflow___dspor__5AB02245] DEFAULT (0) FOR [dsporder],
	CONSTRAINT [DF__Workflow___issta__5BA4467E] DEFAULT ('0') FOR [isstat]
GO

ALTER TABLE [Workflow_ReportType] WITH NOCHECK ADD 
	CONSTRAINT [DF__Workflow___typeo__55EB6D28] DEFAULT (0) FOR [typeorder]
GO

ALTER TABLE [bill_CptAdjustDetail] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptA__capit__64447977] DEFAULT (0) FOR [capitalid]
GO

ALTER TABLE [bill_CptAdjustMain] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptA__group__0782C8BC] DEFAULT (0) FOR [groupid],
	CONSTRAINT [DF__bill_CptA__reque__0876ECF5] DEFAULT (0) FOR [requestid]
GO

ALTER TABLE [bill_CptApplyDetail] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptA__capit__678BC5CD] DEFAULT (0) FOR [capitalid]
GO

ALTER TABLE [bill_CptCarFix] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptC__reque__1DA8AAB3] DEFAULT (0) FOR [requestid],
	CONSTRAINT [DF__bill_CptC__carno__1E9CCEEC] DEFAULT (0) FOR [carno]
GO

ALTER TABLE [bill_CptCarMantant] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptC__reque__757ABDC8] DEFAULT (0) FOR [requestid],
	CONSTRAINT [DF__bill_CptC__carno__766EE201] DEFAULT (0) FOR [carno]
GO

ALTER TABLE [bill_CptCarOut] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptC__isoth__6DB9A06F] DEFAULT (0) FOR [isotherplace]
GO

ALTER TABLE [bill_CptCheckMain] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptC__group__0D3BA212] DEFAULT (0) FOR [groupid],
	CONSTRAINT [DF__bill_CptC__reque__0E2FC64B] DEFAULT (0) FOR [requestid]
GO

ALTER TABLE [bill_CptFetchDetail] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptF__capit__1C88D29A] DEFAULT (0) FOR [capitalid]
GO

ALTER TABLE [bill_CptFetchMain] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptF__group__096B112E] DEFAULT (0) FOR [groupid],
	CONSTRAINT [DF__bill_CptF__reque__0A5F3567] DEFAULT (0) FOR [requestid]
GO

ALTER TABLE [bill_CptPlanMain] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptP__group__4D562727] DEFAULT (0) FOR [groupid],
	CONSTRAINT [DF__bill_CptP__reque__7FE1A6F4] DEFAULT (0) FOR [requestid]
GO

ALTER TABLE [bill_CptStockInDetail] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptS__capit__762E1F88] DEFAULT (0) FOR [capitalid]
GO

ALTER TABLE [bill_CptStockInMain] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_CptS__group__0B5359A0] DEFAULT (0) FOR [groupid],
	CONSTRAINT [DF__bill_CptS__reque__0C477DD9] DEFAULT (0) FOR [requestid]
GO

ALTER TABLE [bill_HrmFinance] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_hrmf__isrem__1A43C4D1] DEFAULT (1) FOR [isremind]
GO

ALTER TABLE [bill_HrmTime] WITH NOCHECK ADD 
	CONSTRAINT [DF__bill_hrmt__isrem__194FA098] DEFAULT (1) FOR [isremind]
GO

ALTER TABLE [workflow_base] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___iscus__0BD1B136] DEFAULT (0) FOR [iscust],
	CONSTRAINT [DF__workflow___helpd__0CC5D56F] DEFAULT (0) FOR [helpdocid],
	CONSTRAINT [DF__workflow___isval__17357B58] DEFAULT (1) FOR [isvalid]
GO

ALTER TABLE [workflow_billfield] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___viewt__5F9EF494] DEFAULT (0) FOR [viewtype]
GO

ALTER TABLE [workflow_currentoperator] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___isrem__127EAEC5] DEFAULT (0) FOR [isremark],
	CONSTRAINT [DF__workflow___usert__1372D2FE] DEFAULT (0) FOR [usertype]
GO

ALTER TABLE [workflow_formfield] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___field__1A1FD08D] DEFAULT (0) FOR [fieldorder]
GO

ALTER TABLE [workflow_nodebase] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___drawx__1CFC3D38] DEFAULT ((-1)) FOR [drawxpos],
	CONSTRAINT [DF__workflow___drawy__1DF06171] DEFAULT ((-1)) FOR [drawypos],
	CONSTRAINT [DF__workflow___total__1EE485AA] DEFAULT (0) FOR [totalgroups]
GO

ALTER TABLE [workflow_nodegroup] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___canvi__21C0F255] DEFAULT (0) FOR [canview]
GO

ALTER TABLE [workflow_nodelink] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___direc__23A93AC7] DEFAULT ((-1)) FOR [directionfrom],
	CONSTRAINT [DF__workflow___direc__249D5F00] DEFAULT ((-1)) FOR [directionto],
	CONSTRAINT [DF__workflow_nod__x1__25918339] DEFAULT ((-1)) FOR [x1],
	CONSTRAINT [DF__workflow_nod__y1__2685A772] DEFAULT ((-1)) FOR [y1],
	CONSTRAINT [DF__workflow_nod__x2__2779CBAB] DEFAULT ((-1)) FOR [x2],
	CONSTRAINT [DF__workflow_nod__y2__286DEFE4] DEFAULT ((-1)) FOR [y2],
	CONSTRAINT [DF__workflow_nod__x3__2962141D] DEFAULT ((-1)) FOR [x3],
	CONSTRAINT [DF__workflow_nod__y3__2A563856] DEFAULT ((-1)) FOR [y3],
	CONSTRAINT [DF__workflow_nod__x4__2B4A5C8F] DEFAULT ((-1)) FOR [x4],
	CONSTRAINT [DF__workflow_nod__y4__2C3E80C8] DEFAULT ((-1)) FOR [y4],
	CONSTRAINT [DF__workflow_nod__x5__2D32A501] DEFAULT ((-1)) FOR [x5],
	CONSTRAINT [DF__workflow_nod__y5__2E26C93A] DEFAULT ((-1)) FOR [y5],
	CONSTRAINT [DF__workflow___nodep__2F1AED73] DEFAULT ((-1)) FOR [nodepasstime]
GO

ALTER TABLE [workflow_requestLog] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___opera__310335E5] DEFAULT (0) FOR [operatortype],
	CONSTRAINT [DF__workflow___destn__31F75A1E] DEFAULT (0) FOR [destnodeid]
GO

ALTER TABLE [workflow_requestViewLog] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___viewt__33DFA290] DEFAULT (0) FOR [viewtype],
	CONSTRAINT [DF__workflow___curre__34D3C6C9] DEFAULT (0) FOR [currentnodeid]
GO

ALTER TABLE [workflow_requestbase] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___creat__36BC0F3B] DEFAULT (0) FOR [creatertype],
	CONSTRAINT [DF__workflow___lasto__37B03374] DEFAULT (0) FOR [lastoperatortype],
	CONSTRAINT [DF__workflow___nodep__38A457AD] DEFAULT ((-1)) FOR [nodepasstime],
	CONSTRAINT [DF__workflow___nodel__39987BE6] DEFAULT ((-1)) FOR [nodelefttime],
	CONSTRAINT [DF__workflow___level__299A4BA3] DEFAULT (0) FOR [requestlevel]
GO

ALTER TABLE [workflow_type] WITH NOCHECK ADD 
	CONSTRAINT [DF__workflow___dspor__3C74E891] DEFAULT (0) FOR [dsporder]
GO

 CREATE  INDEX [IX_CRM_ContactLog_customerid] ON [CRM_ContactLog]([customerid]) 
GO

 CREATE  INDEX [IX_CRM_ContactLog_resourceid] ON [CRM_ContactLog]([resourceid]) 
GO

 CREATE  INDEX [IX_CRM_ContactLog_agentid] ON [CRM_ContactLog]([agentid]) 
GO

 CREATE  INDEX [IX_CRM_ContactLog_contactdate] ON [CRM_ContactLog]([contactdate], [contacttime]) 
GO

 CREATE  INDEX [IX_CRM_CustomerAddress_custome] ON [CRM_CustomerAddress]([customerid], [typeid]) 
GO

 CREATE  INDEX [IX_CRM_CustomerContacter_custo] ON [CRM_CustomerContacter]([customerid]) 
GO

 CREATE  INDEX [IX_CRM_CustomerInfo_dept] ON [CRM_CustomerInfo]([department]) 
GO

 CREATE  INDEX [IX_CRM_CustomerInfo_manager] ON [CRM_CustomerInfo]([manager]) 
GO

 CREATE  INDEX [IX_CRM_CustomerInfo_type] ON [CRM_CustomerInfo]([type]) 
GO

 CREATE  INDEX [IX_CRM_CustomerInfo_agent] ON [CRM_CustomerInfo]([agent]) 
GO

 CREATE  INDEX [IX_CRM_CustomerInfo_sector] ON [CRM_CustomerInfo]([sector]) 
GO

 CREATE  INDEX [IX_CRM_CustomerInfo_city] ON [CRM_CustomerInfo]([city]) 
GO

 CREATE  INDEX [IX_CRM_CustomerInfo_status] ON [CRM_CustomerInfo]([status]) 
GO

 CREATE  INDEX [IX_CRM_CustomerInfo_source] ON [CRM_CustomerInfo]([source]) 
GO

 CREATE  INDEX [IX_CRM_Customize_userid] ON [CRM_Customize]([userid]) 
GO

 CREATE  INDEX [IX_CRM_CustomizeOption_id] ON [CRM_CustomizeOption]([id]) 
GO

 CREATE  INDEX [IX_CRM_Log_customerid] ON [CRM_Log]([customerid]) 
GO

 CREATE  INDEX [IX_CRM_Log_submitdate] ON [CRM_Log]([submitdate], [submittime]) 
GO

 CREATE  INDEX [IX_CRM_LoginLog_id] ON [CRM_LoginLog]([id]) 
GO

 CREATE  INDEX [IX_CRM_LoginLog_logindate] ON [CRM_LoginLog]([logindate], [logintime]) 
GO

 CREATE  INDEX [IX_CRM_Modify_customerid] ON [CRM_Modify]([customerid]) 
GO

 CREATE  INDEX [IX_CRM_Modify_modifydate] ON [CRM_Modify]([modifydate], [modifytime]) 
GO

 CREATE  INDEX [IX_CRM_SectorInfo_parentid] ON [CRM_SectorInfo]([parentid]) 
GO

 CREATE  INDEX [IX_CRM_ShareInfo_relateitem] ON [CRM_ShareInfo]([relateditemid]) 
GO

 CREATE  INDEX [IX_CRM_ShareInfo_userid] ON [CRM_ShareInfo]([userid]) 
GO

 CREATE  INDEX [IX_CRM_ShareInfo_dept] ON [CRM_ShareInfo]([departmentid]) 
GO

 CREATE  INDEX [IX_CRM_ShareInfo_roleid] ON [CRM_ShareInfo]([roleid]) 
GO

 CREATE  INDEX [IX_CRM_ViewLog1_id] ON [CRM_ViewLog1]([id]) 
GO

 CREATE  INDEX [IX_CRM_ViewLog1_viewer] ON [CRM_ViewLog1]([viewer]) 
GO

 CREATE  INDEX [IX_CRM_ViewLog1_viewdate] ON [CRM_ViewLog1]([viewdate], [viewtime]) 
GO

 CREATE  INDEX [docdetaillog_doc_in] ON [DocDetailLog]([docid]) 
GO

 CREATE  INDEX [docdetaillog_operateuser_in] ON [DocDetailLog]([operateuserid]) 
GO

 CREATE  INDEX [docfrontpage_departmentid_in] ON [DocFrontpage]([departmentid]) 
GO

 CREATE  INDEX [docfrontpage_linktype_in] ON [DocFrontpage]([linktype]) 
GO

 CREATE  INDEX [docimagefile_docid_in] ON [DocImageFile]([docid]) 
GO

 CREATE  INDEX [docsearchmoule_userid_in] ON [DocSearchMould]([userid]) 
GO

 CREATE  INDEX [docseccategorytype_seccategory] ON [DocSecCategoryType]([seccategoryid]) 
GO

 CREATE  INDEX [fnaaccount_periodsledgerid_in] ON [FnaAccount]([tranperiods], [ledgerid]) 
GO

 CREATE  INDEX [fnaaccountcostcenter_costcente] ON [FnaAccountCostcenter]([costcenterid], [ledgerid]) 
GO

 CREATE  INDEX [fnaaccountdepartment_departmen] ON [FnaAccountDepartment]([departmentid], [ledgerid]) 
GO

 CREATE  INDEX [fnaaccountlist_periodsledgerid] ON [FnaAccountList]([tranperiods], [ledgerid]) 
GO

 CREATE  INDEX [fnaudget_budgetmoduleidyear_in] ON [FnaBudget]([budgetmoduleid], [budgetperiods]) 
GO

 CREATE  INDEX [fnabudgetdetail_budgetid_in] ON [FnaBudgetDetail]([budgetid]) 
GO

 CREATE  INDEX [fnabudgetlist_periodsledgerid] ON [FnaBudgetList]([budgetperiods], [ledgerid]) 
GO

 CREATE  INDEX [fnatransaction_tranperiods_in] ON [FnaTransaction]([tranperiods]) 
GO

 CREATE  INDEX [fnatransactiondetail_tranid_in] ON [FnaTransactionDetail]([tranid]) 
GO

 CREATE  INDEX [fnayearsperiodslist_fnayear_in] ON [FnaYearsPeriodsList]([fnayear]) 
GO

 CREATE  INDEX [hrmactivitiescompetency_jobact] ON [HrmActivitiesCompetency]([jobactivityid]) 
GO

 CREATE  INDEX [hrmcareerworkexp_applyid_in] ON [HrmCareerWorkexp]([applyid]) 
GO

 CREATE  INDEX [hrmcomponentstat_resourceid_in] ON [HrmComponentStat]([resourceid]) 
GO

 CREATE  INDEX [hrmcostcenter_departmentid_in] ON [HrmCostcenter]([departmentid]) 
GO

 CREATE  INDEX [hrmcostcentersubcategory_ccmai] ON [HrmCostcenterSubCategory]([ccmaincategoryid]) 
GO

 CREATE  INDEX [hrmpubholiday_countryid_in] ON [HrmPubHoliday]([countryid]) 
GO

 CREATE  INDEX [IX_HrmResource_manager] ON [HrmResource]([managerid]) 
GO

 CREATE  INDEX [IX_HrmResource_dept] ON [HrmResource]([departmentid]) 
GO

 CREATE  INDEX [hrmresourcecomponent_resourcei] ON [HrmResourceComponent]([resourceid]) 
GO

 CREATE  INDEX [hrmresourceskill_resourceid_in] ON [HrmResourceSkill]([resourceid]) 
GO

 CREATE  INDEX [hrmrolemembers_roleid_in] ON [HrmRoleMembers]([roleid]) 
GO

 CREATE  INDEX [hrmrolemembers_resourceid_in] ON [HrmRoleMembers]([resourceid]) 
GO

 CREATE  INDEX [IX_hrmrolemembers_roleid] ON [HrmRoleMembers]([roleid]) 
GO

 CREATE  INDEX [IX_hrmrolemembers_resourceid] ON [HrmRoleMembers]([resourceid]) 
GO

 CREATE  INDEX [hrmSalarycomponentdetail_compo] ON [HrmSalaryComponentDetail]([componentid]) 
GO

 CREATE  INDEX [hrmsubcompany_companyid_in] ON [HrmSubCompany]([companyid]) 
GO

 CREATE  INDEX [imagefile_imagefileid_in] ON [ImageFile]([imagefileid]) 
GO

 CREATE  INDEX [lgcassetcountry_assetcountyid] ON [LgcAssetCountry]([assetid], [assetcountyid]) 
GO

 CREATE  INDEX [lgcassetprice_assetcountyid_in] ON [LgcAssetCountry]([assetid], [assetcountyid]) 
GO

 CREATE  INDEX [lgcstockinoutdetail_inoutid_in] ON [LgcStockInOutDetail]([inoutid]) 
GO

 CREATE  INDEX [MailResource_resourceid] ON [MailResource]([resourceid]) 
GO

 CREATE  INDEX [MailResourceFile_mailid] ON [MailResourceFile]([mailid]) 
GO

 CREATE  INDEX [IX_Prj_Log_projectid] ON [Prj_Log]([projectid]) 
GO

 CREATE  INDEX [IX_Prj_Log_submiter] ON [Prj_Log]([submiter]) 
GO

 CREATE  INDEX [IX_Prj_Log_submitdate] ON [Prj_Log]([submitdate], [submittime]) 
GO

 CREATE  INDEX [IX_Prj_Material_prjid] ON [Prj_Material]([prjid], [taskid]) 
GO

 CREATE  INDEX [IX_Prj_MaterialProcess_prjid] ON [Prj_MaterialProcess]([prjid], [taskid]) 
GO

 CREATE  INDEX [IX_Prj_Member_prjid] ON [Prj_Member]([prjid], [taskid]) 
GO

 CREATE  INDEX [IX_Prj_Member_relateid] ON [Prj_Member]([relateid]) 
GO

 CREATE  INDEX [IX_Prj_MemberProcess_prjid] ON [Prj_MemberProcess]([prjid], [taskid]) 
GO

 CREATE  INDEX [IX_Prj_MemberProcess_relateid] ON [Prj_MemberProcess]([relateid]) 
GO

 CREATE  INDEX [IX_Prj_Modify_projectid] ON [Prj_Modify]([projectid]) 
GO

 CREATE  INDEX [IX_Prj_Modify_modifier] ON [Prj_Modify]([modifier]) 
GO

 CREATE  INDEX [IX_Prj_Modify_modifydate] ON [Prj_Modify]([modifydate], [modifytime]) 
GO

 CREATE  INDEX [IX_Prj_ProjectInfo_manager] ON [Prj_ProjectInfo]([manager]) 
GO

 CREATE  INDEX [IX_Prj_ProjectInfo_department] ON [Prj_ProjectInfo]([department]) 
GO

 CREATE  INDEX [IX_Prj_ProjectInfo_parentid] ON [Prj_ProjectInfo]([parentid]) 
GO

 CREATE  INDEX [IX_Prj_ProjectInfo_prjtype] ON [Prj_ProjectInfo]([prjtype]) 
GO

 CREATE  INDEX [IX_Prj_ProjectInfo_worktype] ON [Prj_ProjectInfo]([worktype]) 
GO

 CREATE  INDEX [IX_Prj_ProjectInfo_status] ON [Prj_ProjectInfo]([status]) 
GO

 CREATE  INDEX [IX_Prj_ShareInfo_relateitem] ON [Prj_ShareInfo]([relateditemid]) 
GO

 CREATE  INDEX [IX_Prj_ShareInfo_userid] ON [Prj_ShareInfo]([userid]) 
GO

 CREATE  INDEX [IX_Prj_ShareInfo_dept] ON [Prj_ShareInfo]([departmentid]) 
GO

 CREATE  INDEX [IX_Prj_ShareInfo_roleid] ON [Prj_ShareInfo]([roleid]) 
GO

 CREATE  INDEX [IX_Prj_TaskInfo_version] ON [Prj_TaskInfo]([prjid], [version], [level_n]) 
GO

 CREATE  INDEX [IX_Prj_TaskInfo_hrmid] ON [Prj_TaskInfo]([prjid], [hrmid]) 
GO

 CREATE  INDEX [IX_Prj_TaskInfo_parentids] ON [Prj_TaskInfo]([prjid], [parentids]) 
GO

 CREATE  INDEX [IX_Prj_TaskProcess_level] ON [Prj_TaskProcess]([prjid], [level_n]) 
GO

 CREATE  INDEX [IX_Prj_TaskProcess_hrmid] ON [Prj_TaskProcess]([prjid], [hrmid]) 
GO

 CREATE  INDEX [IX_Prj_TaskProcess_parentids] ON [Prj_TaskProcess]([prjid], [parentids]) 
GO

 CREATE  INDEX [IX_Prj_Tool_prjid] ON [Prj_Tool]([prjid], [taskid]) 
GO

 CREATE  INDEX [IX_Prj_Tool_relateid] ON [Prj_Tool]([relateid]) 
GO

 CREATE  INDEX [IX_Prj_ToolProcess_prjid] ON [Prj_ToolProcess]([prjid], [taskid]) 
GO

 CREATE  INDEX [IX_Prj_ToolProcess_relateid] ON [Prj_ToolProcess]([relateid]) 
GO

 CREATE  INDEX [IX_Prj_ViewLog1_id] ON [Prj_ViewLog1]([id]) 
GO

 CREATE  INDEX [IX_Prj_ViewLog1_viewer] ON [Prj_ViewLog1]([viewer]) 
GO

 CREATE  INDEX [IX_Prj_ViewLog1_viewdate] ON [Prj_ViewLog1]([viewdate], [viewtime]) 
GO

 CREATE  INDEX [systemrighttogroup_index] ON [SystemRightToGroup]([groupid]) 
GO

 CREATE  INDEX [systemrightslanguage_index] ON [SystemRightsLanguage]([id]) 
GO

 CREATE  INDEX [Workflow_ReportDspField_report] ON [Workflow_ReportDspField]([reportid]) 
GO


/* 工作流编号 */

alter table workflow_base add needmark char(1) default '0' 
alter table workflow_requestbase add requestmark varchar(30)

create table workflow_requestmark (
markdate  char(10)  primary key ,
requestmark int 
)

GO

/*人力资源招聘*/

alter table HrmCareerApply add NumberId varchar(30)
GO


create table hrmshare
(
hrmid int,
applyid int
)
GO


/* 费用报销单据 */

alter table bill_HrmFinance add realamount decimal(10,3)
alter table Bill_ExpenseDetail add realfeesum decimal(10, 2) 
GO
