insert into workflow_browserurl(id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) values(179,1509,'integer','/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=1','CptCapital','name','id','/cpt/capital/CptCapital.jsp?id=')
/

update workflow_billfield set type=179 where billid=14 and viewtype=1 and fieldhtmltype=3 and fieldname='cptid'
/

update workflow_bill set operationpage='BillCptApplyOperation.jsp' where id=14
/