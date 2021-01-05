<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.*,java.math.BigDecimal,java.text.NumberFormat" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.report.ReportCompositorOrderBean" %>
<%@ page import="weaver.workflow.report.ReportCompositorListBean" %>
 <%@ page import="weaver.workflow.report.ReportUtilComparator" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<jsp:useBean id="ExpensefeeTypeComInfo" class="weaver.fna.maintenance.ExpensefeeTypeComInfo" scope="page"/>
<jsp:useBean id="MDCompanyNameInfo" class="weaver.workflow.report.ReportShare" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="resourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="WorkflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>	
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<HTML>
<HEAD>
<link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
<style type="text/css">
.e8PageCountClass td{
	background-color:#e9f3fb!important;
}
.e8TotalCountClass td{
	background-color:#ecfdea!important;
}
</style>
</HEAD>
<BODY id="reportBody">
<%

//报表id
String reportid = Util.null2String(request.getParameter("reportid")) ;
String outputExcel = Util.null2String(request.getParameter("outputExcel")) ;

if(reportid.equals("")){
	reportid="0";
}

String[] checkcons =null;//报表条件
String[] isShowArray = null;//报表列
List isShowList=new ArrayList();//显示的列的字段id

String isbill = "1";
String formid = "0";
String reportname = "";
String modeid = "0";
String sql = "select a.reportname,a.formid,a.modeid from mode_Report a where a.id= "+reportid;
RecordSet.execute(sql) ;
while(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formid"));
	reportname = Util.null2String(RecordSet.getString("reportname"));
	modeid = Util.null2String(RecordSet.getString("modeid"));
}

List fieldids = new ArrayList() ;
List fields = new ArrayList() ;
List fieldnames = new ArrayList() ;

List htmltypes = new ArrayList() ;
List types = new ArrayList() ;
List isstats = new ArrayList() ;
List statvalues = new ArrayList() ;
List tempstatvalues = new ArrayList() ;
List isdetails = new ArrayList() ;//add by wang jinyong
String requestid = ""; //add by wang jinyong
boolean isnew = true; //add by wang jinyong
List isdborders = new ArrayList() ;

ArrayList compositorOrderList = new ArrayList() ;//addsed by xwj for td2099 on 2005-06-08
ArrayList compositorColList = new ArrayList() ;//addsed by xwj for td2451 on 2005-11-14
ArrayList compositorColList2 = new ArrayList() ;//addsed by xwj for td2451 on 2005-11-14

List ids = new ArrayList();
List isMains = new ArrayList();
List isShows = new ArrayList();
List isCheckConds = new ArrayList();
List colnames = new ArrayList();
List htmlTypes = new ArrayList();
List qfwList = new ArrayList();
List typeTemps = new ArrayList();
List opts = new ArrayList();
List values = new ArrayList();
List names = new ArrayList();
List opt1s = new ArrayList();
List value1s = new ArrayList();


checkcons = request.getParameterValues("check_con");//报表条件
isShowArray = request.getParameterValues("isShow");//报表列

if(isShowArray!=null){
    for(int i=0;i<isShowArray.length;i++){
	    isShowList.add(isShowArray[i]);
    }
}

String modedatacreatedateIsShow = request.getParameter("modedatacreatedateIsShow");
String modedatacreateIsShow = request.getParameter("modedatacreateIsShow");

if(modedatacreatedateIsShow!=null&&modedatacreatedateIsShow.equals("1")){
	isShowList.add("-1");
}

if(modedatacreateIsShow!=null&&modedatacreateIsShow.equals("1")){
	isShowList.add("-2");
}

//传递过来的LIST值
String showListStr = Util.StringReplace(Util.StringReplace(Util.StringReplace(Util.null2String(request.getParameter("isShowList")),"[",","),"]",",")," ","");
isShowList = Util.TokenizerString(showListStr, ",");

String sqlrightwhere = "";
String temOwner = "";


String tablename = "workflow_form" ;
String detailtablename = "" ;
String detailkeyfield = "" ;
int maincount = 0 ;
int detailcount = 0 ;
int ordercount = 0 ;
int statcount = 0 ;
String fieldname = "" ;
String orderbystr = "" ;
ReportCompositorOrderBean reportCompositorOrderBean = new ReportCompositorOrderBean(); //added by xwj for td2099 on 2005-06-08
ReportCompositorListBean rcListBean = new ReportCompositorListBean();//added by xwj for td2451 20051114
ReportCompositorListBean rcColListBean = new ReportCompositorListBean();//added by xwj for td2451 20051114


	//只有显示请求说明时才执行下面的操作
	if(isShowList.indexOf("-1")!=-1){
		rs1.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = -1");
		if(rs1.next()){
		    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
		    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
		    rcListBean.setSqlFlag("a");//xwj for td2451 20051114
		    rcListBean.setFieldName("modedatacreatedate");//xwj for td2451 20051114
		    rcListBean.setFieldId("-1");//xwj for td2451 20051114
		    rcListBean.setColName(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//xwj for td2451 20051114
			compositorColList.add(rcListBean);//xwj for td2451 20051114
		    fields.add("modedatacreatedate");
		    if(!"n".equals(rs1.getString("dbordertype"))){
		        reportCompositorOrderBean = new ReportCompositorOrderBean();
		        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
				reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
				reportCompositorOrderBean.setFieldName("modedatacreatedate");
				reportCompositorOrderBean.setSqlFlag("a");
				compositorOrderList.add(reportCompositorOrderBean);
		    }
		}
	}

	 //只有显示紧急程度时才执行下面的操作
	if(isShowList.indexOf("-2")!=-1){    
		rs1.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = -2");
		if(rs1.next()){
	      rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
		    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
		    rcListBean.setSqlFlag("a");//xwj for td2451 20051114
		    rcListBean.setFieldName("modedatacreater");//xwj for td2451 20051114
		    rcListBean.setFieldId("-2");//xwj for td2451 20051114
		    rcListBean.setColName(SystemEnv.getHtmlLabelName(882,user.getLanguage()));//创建人
		    compositorColList.add(rcListBean);//xwj for td2451 20051114
		    fields.add("modedatacreater");
		    if(!"n".equals(rs1.getString("dbordertype"))){
		        reportCompositorOrderBean = new ReportCompositorOrderBean();
		        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
				reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
				reportCompositorOrderBean.setFieldName("modedatacreater");
				reportCompositorOrderBean.setSqlFlag("a");
				compositorOrderList.add(reportCompositorOrderBean);
		    }
		}
	}
	
	sql = " select a.fieldname , c.labelname, a.fieldhtmltype, a.type, b.isstat , a.viewtype , b.dborder , a.id , b.dbordertype , b.compositororder, b.dsporder, a.detailtable as detailtable from  workflow_billfield a, mode_ReportDspField b , HtmlLabelInfo c " +
        " where a.id = b.fieldid and a.fieldlabel = c.indexid and b.reportid = " + reportid +" and  c.languageid = " + user.getLanguage() + " order by b.dsporder asc,a.detailtable";
        if(RecordSet.getDBType().equals("oracle")){
    		sql += " desc";
	    }else{
			sql += " asc";
	    }
    sql += ",a.id asc";
    RecordSet.execute(sql) ;
	
	while(RecordSet.next()) {

		if(isShowList.indexOf(Util.null2String(RecordSet.getString(8)))==-1){
			continue;
		}

     String viewtype = Util.null2String(RecordSet.getString(6)) ;
     if(viewtype.equals("1")) {
		viewtype = Util.null2String(RecordSet.getString("detailtable")) ;
		detailcount ++ ;
     }
     else {
         viewtype ="a" ; // "a." --> "a"   xwj for td2131 on 2005-06-20
         maincount ++ ;
     }

     /*-----  xwj for td2974 20051026   B E G I N  ---*/
     rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
     rcListBean.setCompositorList(RecordSet.getDouble(11));//xwj for td2451 20051114
     rcListBean.setSqlFlag(viewtype);//xwj for td2451 20051114
     rcListBean.setFieldName(Util.null2String(RecordSet.getString(1)));//xwj for td2451 20051114
     rcListBean.setFieldId(Util.null2String(RecordSet.getString(8)));//xwj for td2451 20051114
     rcListBean.setColName(Util.toScreen(RecordSet.getString(2),user.getLanguage()));//xwj for td2451 20051114
	      compositorColList.add(rcListBean);//xwj for td2451 20051114
     fields.add(Util.null2String(RecordSet.getString(1))) ;
	 
     if(Util.null2String(RecordSet.getString(7)).equals("1")) {
         reportCompositorOrderBean = new ReportCompositorOrderBean();
         reportCompositorOrderBean.setCompositorOrder(RecordSet.getInt(10));
         reportCompositorOrderBean.setOrderType(Util.null2String(RecordSet.getString(9)));
         reportCompositorOrderBean.setFieldName(Util.null2String(RecordSet.getString(1)));
         reportCompositorOrderBean.setSqlFlag(viewtype);
         compositorOrderList.add(reportCompositorOrderBean);
     }

 }
 compositorColList2 = ReportComInfo.getCompositorList(compositorColList); //xwj for td2451 on 2005-11-14
 for(int a = 0; a < compositorColList2.size(); a++){
 rcColListBean = (ReportCompositorListBean)compositorColList2.get(a);
 RecordSet.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = " +rcColListBean.getFieldId());
 if(RecordSet.next()){
 
 String  tempfieldid = RecordSet.getString("fieldid");
 if("-1".equals(tempfieldid) || "-2".equals(tempfieldid)){
 htmltypes.add(tempfieldid);
 qfwList.add("");
 types.add(tempfieldid);
 isdetails.add("");
 }
 else{
 rs3.executeSql("select formid from mode_report b where   b.id = "+ reportid);
 if(rs3.next()){
 rs2.executeSql("select * from workflow_billfield where id = " + tempfieldid + " and billid=" + rs3.getString("formid"));
 if(rs2.next()){
  htmltypes.add(Util.null2String(rs2.getString("fieldhtmltype")));
  int qfwsValue  = rs2.getInt("qfws");
  if("1".equals(rs2.getString("fieldhtmltype"))&&("4".equals(rs2.getString("type")))){
	qfwsValue = 2;
  }
  String fielddbtype = rs2.getString("fielddbtype");
  if("1".equals(rs2.getString("fieldhtmltype"))&&("3".equals(rs2.getString("type"))|| "5".equals(rs2.getString("type")))){
    int digitsIndex = fielddbtype.indexOf(",");
	if(digitsIndex > -1){
		qfwsValue = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
  	}else{
  		qfwsValue = 2;
  	}
	}
  qfwList.add(qfwsValue+"");
  types.add(Util.null2String(rs2.getString("type")));
  String detailtabletmp = Util.null2String(rs2.getString("detailtable"));
  if(!"".equals(detailtabletmp)){
 	 isdetails.add("1");
  }else{
 	 isdetails.add("");
  }
 }
 }
 }
 fieldids.add(tempfieldid);
 if(Util.null2String(RecordSet.getString("isstat")).equals("1")) {
         statcount ++ ;
         isstats.add("1") ;
 }
 else{ 
   isstats.add("") ;
 }
 statvalues.add("") ;
 tempstatvalues.add("") ;
  if(!Util.null2String(RecordSet.getString("dbordertype")).equals("n")) {
         ordercount ++ ;
         isdborders.add("1") ;
 }
 else{ 
   isdborders.add("") ;
 }
}
 } //xwj for td2451 on 2005-11-14 
 fieldname =  ReportComInfo.getCompositorListByStrs(compositorColList)+",c.requestid"; //xwj for td2451 on 2005-11-14
 orderbystr = ReportComInfo.getCompositorOrderByStrs(compositorOrderList); //added by xwj for td2099 on2005-06-08
 
	sql = " select tablename , detailtablename , detailkeyfield from workflow_bill where id = " + formid ;
	RecordSet.execute(sql) ;
	RecordSet.next() ;
	tablename = Util.null2String(RecordSet.getString(1)) ;
	detailtablename = Util.null2String(RecordSet.getString(2)) ;
	detailkeyfield = Util.null2String(RecordSet.getString(3)) ;
	detailtablename = "";
	RecordSet.executeSql("select tablename from workflow_billdetailtable where billid="+formid);
	while(RecordSet.next()){
		detailtablename += RecordSet.getString("tablename")+",";
	}
sql = request.getParameter("pmSql");

int pageSize = Util.getIntValue((String)request.getParameter("pageSize"), 20);
int currentPage = Util.getIntValue((String)request.getParameter("currentPage"), 1);
int rowcount = 0;
int pageCount = 0;
String dbType = RecordSet.getDBType();
String countsql = "";
if ("sqlserver".equals((dbType))) {
	countsql = "select count(1) as count from (" + " SELECT TOP 100 PERCENT t1.* from (" + sql + ") t1 ) tbl_1";
} else {
	countsql = "select count(1) as count from (" + sql + ") tbl_1";
}

RecordSet.execute(countsql);
if (RecordSet.next()) {
	rowcount = Util.getIntValue(RecordSet.getString("count"));
}

if(rowcount % pageSize == 0) {
	pageCount = rowcount / pageSize;
} else {
	pageCount = rowcount / pageSize + 1;
}

int tmpPageSize = pageSize;

if (rowcount - currentPage * pageSize < 0) {
	tmpPageSize = currentPage * pageSize - rowcount;
}

String tmpTblName = null;

StringBuffer splitPageSql = new StringBuffer();

if ("sqlserver".equals((dbType))) {
	
	tmpTblName = "TEMP_TBL_RPTDATA_" + new Date().getTime();
	StringBuffer splitinertSql = new StringBuffer();
	
	splitinertSql.append("SELECT *, identity(int,1,1) as rptRltSltId into " + tmpTblName + " FROM (");
	splitinertSql.append(" select top " + pageSize * currentPage + " * from  (    ");
	splitinertSql.append(" SELECT TOP 100 PERCENT t1.* from (" + sql + ") t1");
	splitinertSql.append("    ) tbl");
	splitinertSql.append(") tbl");
	
	RecordSet.execute(splitinertSql.toString());
	if (currentPage == 1) {
		splitPageSql.append(" select top " + pageSize + " * from ");
		splitPageSql.append(tmpTblName);
	} else {
		splitPageSql.append(" select * from ");
		splitPageSql.append(tmpTblName);
		splitPageSql.append(" where rptRltSltId > ");
		splitPageSql.append((currentPage - 1) * pageSize);
	}
}else if ("mysql".equals((dbType))) {
	splitPageSql.append(sql+" LIMIT "+ (currentPage - 1) * pageSize +","+currentPage * pageSize);
} else {
	splitPageSql.append(" SELECT * FROM ");
	splitPageSql.append(" (");
	splitPageSql.append(" SELECT A.*, ROWNUM RN ");
	splitPageSql.append(" FROM (SELECT * FROM (" + sql + ")) A ");
	splitPageSql.append(" WHERE ROWNUM <= " + currentPage * pageSize + "");
	splitPageSql.append(" )");
	splitPageSql.append(" WHERE RN > " + (currentPage - 1) * pageSize + "");
}


String oldsql = sql;
if(!"1".equals(outputExcel)){
	sql = splitPageSql.toString();
}
Map statisticsRowKv = new HashMap();
List rowNames = new ArrayList();

%>

<div style="height:0px;width:0px;">
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0px" width="0px"></iframe>
</div>
<div id="firstDiv" name="firstDiv" style="width:100%;overflow:auto;height:99%;">
<table>
<tr>
<td>
<%
ArrayList colList = ReportComInfo.getCompositorList(compositorColList);
String tableWidth="";
if(colList.size()>15){
	tableWidth="width:"+colList.size()*100+"px;";
}
%>
<TABLE class=ListStyle cellspacing=1 id="reportDateTbl" name="reportDateTbl" style="table-Layout:fixed;<%=tableWidth%>">
  <COLGROUP>
  <thead>

  <TR class="HeaderForXtalbe">
  <%
	ExcelSheet es = new ExcelSheet() ;
	ExcelRow er = es.newExcelRow () ;
  
   %>
   <%if (statcount!=0) {er.addValue("");%><TH style="height: 38px;width:50px"></TH><%} %>
   <%
   String widthStr = "";
   if(colList.size()>15){
   		widthStr = "100px;";
   }else{
   		widthStr = 100/colList.size()+"%;";
   }
   for(int i = 0; i < colList.size(); i++) {
	    rcColListBean = (ReportCompositorListBean) colList.get(i);
	    er.addStringValue(delHtmlToExcel(rcColListBean.getColName())) ;
  %>
    <TH style="height: 38px;width:<%=widthStr%>" title="<%=rcColListBean.getColName()%>"><%=rcColListBean.getColName()%></TH>
    <%
    }
	es.addExcelRow(er) ;
    %>
  </TR>
  </thead>
  <tbody>
<%
   	String useddetailtable = Util.null2String(request.getParameter("useddetailtable"));
    int needchange = 0;
    String tempvalue = "";
    String tempdbordervalue = "" ;
    boolean needstat = false ;
    boolean isfirst = true ;
    if(!"".equals(useddetailtable)) useddetailtable = useddetailtable.substring(1);
    detailtablename = useddetailtable;
    ArrayList detailtablenameList = Util.TokenizerString(detailtablename, ",");
    int details = detailtablenameList.size();
    String[] detailids = null;
    if(details>0) detailids = new String[details];
    for(int flag=0;flag<details;flag++){
        detailids[flag] = ",";
    }
    
    if(details>0){
        String tempsql = "select t1.id from ("+sql+") t1";
        RecordSet.executeSql(tempsql);
        ArrayList requestids = new ArrayList();
        while(RecordSet.next()){
        	if (!requestids.contains(RecordSet.getString("id"))) {
            	requestids.add(RecordSet.getString("id"));
        	}
        }

        for(int rqflag=0;rqflag<requestids.size();rqflag++){
            String thisrequestid = (String)requestids.get(rqflag);
          	RecordSet.executeSql("select * from (" + sql + ") tbl where tbl.id=" + thisrequestid);
		
		//qc:298668表单建模，没有明细的数据 
		boolean haveDetailData=false;//主数据是否有对应的明细明细
		for(int indexflag=0;indexflag<details;indexflag++){
	        String thisrowflag = (String)detailtablenameList.get(indexflag);
	        thisrowflag = thisrowflag.toUpperCase();
	        RecordSet.beforFirst();
          	while(RecordSet.next() && !haveDetailData){
           		String thisdetailid = RecordSet.getString(thisrowflag + "_id_");
           		if("".equals(thisdetailid)) {
           			continue;
           		}else{
           			haveDetailData=true;
           		}
			}
		}

		boolean havePrintedMainData=false;//没有明细情况下，是否输出了主数据 //qc:298668表单建模，没有明细的数据 
			
        	for(int indexflag=0;indexflag<details;indexflag++){
	            String thisrowflag = (String)detailtablenameList.get(indexflag);
	            thisrowflag = thisrowflag.toUpperCase();
	            String thisdetailids = ",";
	            RecordSet.beforFirst();
	            
          		while(RecordSet.next()){
            		String thisdetailrequestid = RecordSet.getString("id");
            		if(!thisrequestid.equals(thisdetailrequestid)) {
            			continue;
            		}
					String thisdetailid = RecordSet.getString(thisrowflag + "_id_");
					if("".equals(thisdetailid) && haveDetailData){
						continue;
            		}
            		
            		if(!haveDetailData && havePrintedMainData){
            			continue;
            		}else{
            			havePrintedMainData=true;
            		}
					
					//pmSql：数据sql   控制重复输出的方法   主表->havePrintedMainData    多明细->thisdetailids
            		//zwbo 控制多明细表   输出1次   考虑跨页输出  已经输出但本页的thisdetailids没记录->重复输出
					StringBuffer repeatSql = new StringBuffer();
					//查询之前是否有输出该明细    输出的记录是否有通过明细id去确认
					if (currentPage > 1 && !"".equals(thisdetailid)) {
						repeatSql.append("select * from (");
						String paramsql = request.getParameter("pmSql");
						if ("sqlserver".equals((dbType))) {	
								repeatSql.append(" select * from ");
								repeatSql.append(tmpTblName);
								repeatSql.append(" where rptRltSltId <= ");
								repeatSql.append((currentPage - 1) * pageSize);
						}else if ("mysql".equals((dbType))) {
								repeatSql.append(paramsql+" LIMIT 0 ,"+ "(select count(*) from ("+paramsql+") tempt)-"+pageSize);
						} else {
								repeatSql.append(" SELECT * FROM ");
								repeatSql.append(" (");
								repeatSql.append(" SELECT A.*, ROWNUM RN ");
								repeatSql.append(" FROM (SELECT * FROM (" + paramsql + ")) A ");
								repeatSql.append(" WHERE ROWNUM <= " + (currentPage-1) * pageSize + "");
								repeatSql.append(" )");
						}
						repeatSql.append(" ) t2  where t2."+thisrowflag + "_id_"+" = "+thisdetailid);
						RecordSet repRs = new RecordSet();
						repRs.execute(repeatSql.toString());
						//之前分页已经输出过这个明细
						while(repRs.next()){
							thisdetailids += thisdetailid+",";
						}
					}
					
					
					
					
					if(thisdetailids.indexOf(","+thisdetailid+",")>-1){
            			continue;
            		}

            		thisdetailids += thisdetailid+",";
			        if(ordercount == 1) {
			            for(int i =0 ; i< fields.size() ; i++) {
			                if(((String)isdborders.get(i)).equals("1")) {
			                    tempvalue = Util.null2String(RecordSet.getString(i+1));
			                    if(!tempvalue.equals(tempdbordervalue)) {
			                        needstat = true ;
			                        tempdbordervalue = tempvalue ;
			                    }
			                    else {
			                        needstat = false ;
			                    }
			                }
			            }
			        }
        
			        if(ordercount > 1){
			            List list  = new ArrayList();
			            for(int i =0 ; i< fields.size() ; i++) {
			                if(((String)isdborders.get(i)).equals("1")) {
			                     tempvalue += Util.null2String(RecordSet.getString(i+1));
			                }
						}
			          
			              if(!tempvalue.equals(tempdbordervalue)) {
			                        needstat = true ;
			                        tempdbordervalue = tempvalue ;
			                    }
			                    else {
			                        needstat = false ;
			                    }
			           tempvalue = "";
			        }

        			isfirst = false ;
       				er = es.newExcelRow () ;
       				if(needchange ==0){
       					needchange = 1;
		%>
  						<TR>
		<%
  					}else{
  						needchange=0;
		%>
						<TR>
		<%
					}
		%>
		<%
					String temRequestid = RecordSet.getString("id");
					if(!temRequestid.equals(requestid)){
						isnew = true;
						requestid = temRequestid;
					}else{
						isnew = false;
					}

					String leavetype = "";
					%>
						<%if (statcount!=0) { er.addValue("") ;%><td></td><%} %>
					<%
					for(int i =0 ; i< fields.size() ; i++) {
						String result = Util.null2String(RecordSet.getString(i+1)) ;
						String tcolname= RecordSet.getColumnName(i+1);
						
						if(tcolname.indexOf("__")>0&&tcolname.toUpperCase().indexOf(thisrowflag)==-1) {
							result = "";
						}
						String htmltype = (String)htmltypes.get(i);
						int qfws = Util.getIntValue((String)qfwList.get(i));
						int type = Util.getIntValue((String)types.get(i)) ;
						String results[] = null ;
      
						if(htmltype.equals("-2")) {
							result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
						}if(htmltype.equals("2")){
							   String tempString=result;
	        		           tempString = tempString.replaceAll("<p>","<br/>");  
	        		           tempString = tempString.replaceAll("</p>","<br/>");  
	        				   tempString = tempString.replaceAll("<script>initFlashVideo();</script>","");
	            			   tempString = tempString.replaceAll("<br>","</br></span><span>");  
	        		            result = "<span>"+tempString+"</span>";
						}
    
						if(htmltype.equals("3")) {
        					switch (type) {
					            case 1:
					                result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
					                break ;
					            case 23:
					                result = Util.toScreen(CapitalComInfo.getCapitalname(result),user.getLanguage()) ;
					                break ;
					            case 4:
					                result = Util.toScreen(DepartmentComInfo.getDepartmentname(result),user.getLanguage()) ;
					                break ;
					            case 6:
					                result = Util.toScreen(CostcenterComInfo.getCostCentername(result),user.getLanguage()) ;
					                break ;
					            case 7:
					                result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(result),user.getLanguage()) ;
					                break ;
					            case 8:
					                result = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(result),user.getLanguage()) ;
					                break ;
					            case 9:
					                result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage()) ;
					                break ;
					            case 12:
					                result = Util.toScreen(CurrencyComInfo.getCurrencyname(result),user.getLanguage()) ;
					                break ;
					            case 25:
					                result = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(result),user.getLanguage()) ;
					                break ;
					            case 14:
					            case 15:
					                result = Util.toScreen(LedgerComInfo.getLedgername(result),user.getLanguage()) ;
					                break ;
					            case 16:
					                result = Util.toScreen(RequestComInfo.getRequestname(result),user.getLanguage()) ;
					                break ;
					            case 17:
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					            case 18:
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					            case 24:
					                result = Util.toScreen(JobTitlesComInfo.getJobTitlesname(result),user.getLanguage()) ;
					                break ;
					            case 37:            // 增加多文档处理
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					             case 57:            // 增加多部门处理
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					            case 2:
					                break ;
					            case 19:
					                break ;
					            case 42:      //分部
					                result = Util.toScreen(SubCompanyComInfo.getSubCompanyname(result),user.getLanguage()) ;
					                break ;
				                
					            case 65: //多角色处理 added xwj for td2127 on 2005-06-20
					                Map roleMap  = new HashMap(); 
					                String sql_  = "select ID,RolesName from HrmRoles";
					                rs.executeSql(sql_);
					                while(rs.next()){
					                   roleMap.put(rs.getString("ID"),rs.getString("RolesName"));
					                }
					                results = Util.TokenizerString2(result,",");
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen((String)roleMap.get(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen((String)roleMap.get(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					            case 141:
					            //人力资源条件
					            	result = resourceConditionManager.getFormShowName(result, user.getLanguage());            
					                break;
					            case 142:
					            //收发文单位
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break;
					            case 143:
					            //树状文档
					            	results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break;
					            case 152:
					            //多请求
					            	results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                		result = "";
					                    for(int j=0 ; j< results.length ; j++) {
					                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
					                       rs.executeSql(sql2);
							                   while(rs.next()){
							                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
							                   }
					                    }
					                    if(!result.equals("")) result = result.substring(0,result.length()-1);
					                }
					                break;
					            case 135:
					            //多项目
					            	results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                		result = "";
					                    for(int j=0 ; j< results.length ; j++) {
					                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
					                       rs.executeSql(sql2);
							                   while(rs.next()){
							                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
							                   }
					                    }
					                    if(!result.equals("")) result = result.substring(0,result.length()-1);
					                }
					                break;
					            case 161:
								case 162:
					            //自定义单选,多选
					                if(!result.equals("")) {
									//获取字段的数据库类型
									String tempfid=(String)fieldids.get(i);
									String tempfdbtype="";
										rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
					                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
					                    result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
									}
					                if (type==162) 
										{
										//if(!result.equals("")) result = result.substring(0,result.length()-1);
										}
					                break;
								case 224:
								case 225:
								case 226:
								case 227:
								   result = result;
									break;
								case 256:
								case 257:
									String tempfid=(String)fieldids.get(i);
									String tempfdbtype="";
									rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
				                    if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
									 result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
									break; 
					            default:
									results = Util.TokenizerString2(result,",") ;
									if(results != null) {
											result = "";
					                    for(int j=0 ; j< results.length ; j++) {
					                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
					                       rs.executeSql(sql2);
							                   while(rs.next()){
							                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
							                   }
					                    }
										if(!result.equals("")) result = result.substring(0,result.length()-1);
									}
       						}
    					}
    
						if(htmltype.equals("5"))
					    // 选择框字段
					    {
					        char flag = Util.getSeparator();
					        if(!result.equals("")){
					        	rs.executeProc("workflow_SelectItemSByvalue", (String)fieldids.get(i) + flag + isbill + flag + result);
						        if(rs.next())
						        {
						            result = Util.toScreen(rs.getString("selectname"), user.getLanguage());
						        }
						        else
						        {
						            result = "";
						        }
      						}else{
      	 						result = "";
							}
						}
						if(htmltype.equals("6")) {  // 增加文件上传 added xwj for td2127 on 2005-06-20
	       					switch (type) {
	        					case 1:           
						            result = Util.toScreen(DocComInfo.getMuliDocName(result),user.getLanguage());
						            break ;
	        					case 2:           
						            result = Util.toScreen(DocComInfo.getMuliDocName(result),user.getLanguage());
						            break ;
						        default:
	        				}
	    				}
						
					    if (!rowNames.contains(RecordSet.getColumnName(i + 1))) {
					    	rowNames.add(RecordSet.getColumnName(i + 1));
					    }
        
					    if(((String)isstats.get(i)).equals("1")) {
					
					        double resultdouble = Util.getDoubleValue((String)statvalues.get(i) , 0) ;
					        double tempresultdouble = Util.getDoubleValue((String)tempstatvalues.get(i) , 0) ;
					        
					        statisticsRowKv.put(RecordSet.getColumnName(i + 1), Boolean.valueOf(!isdetails.get(i).equals("1")));
					        
					        if(!isdetails.get(i).equals("1")){
					            if(isnew){
					                resultdouble += Util.getDoubleValue(result , 0) ;
					                tempresultdouble += Util.getDoubleValue(result , 0) ;
					                requestid = temRequestid;
					                statvalues.set(i, ""+resultdouble) ;
					                if("1".equals(outputExcel)){
					                	tempstatvalues.set(i, Util.toDecimalDigits(Util.getNumStr(tempresultdouble),qfws)) ;
					                }else{
					                	tempstatvalues.set(i, ""+tempresultdouble) ;
					                }
					                
					            }else{
					                result = "0";
					            }
					        }else{
					            resultdouble += Util.getDoubleValue(result , 0) ;
					            tempresultdouble += Util.getDoubleValue(result , 0) ;
					            requestid = temRequestid;
					            statvalues.set(i, ""+resultdouble) ;
					            if("1".equals(outputExcel)){
				                	tempstatvalues.set(i, Util.toDecimalDigits(Util.getNumStr(tempresultdouble),qfws)) ;
				                }else{
				                	tempstatvalues.set(i, ""+tempresultdouble) ;
				                }
					        }
					    }
  		%>
    
    	<% 
						String tempTdTextValue = "";
    					String transvalue = "";
						if(!((String)isdborders.get(i)).equals("1") || ((String)isdborders.get(i)).equals("1") && (needstat||statcount== 0) ) {
							if(htmltype.equals("1") && (type==3)) {
								tempTdTextValue=formatData(result);
								///er.addValue(delHtmlToExcel(formatData(result))) ;
								transvalue = delHtmlToExcel(formatData(result));
							}else{
								tempTdTextValue=result;
								String tempString = Util.StringReplace(Util.getTxtWithoutHTMLElement(FieldInfo.toExcel(result)),"%nbsp;"," ");
							    tempString = Util.StringReplace(tempString,"&dt;&at;"," ");
								tempString = Util.StringReplace(tempString,"&amp;","&");
		         				if((htmltype.equals("1")&&type==1)||htmltype.equals("2")) {
		         					//er.addStringValue(delHtmlToExcel(tempString)) ;
		         					transvalue = delHtmlToExcel(tempString);
		         				} else {
		         					//er.addValue(delHtmlToExcel(tempString)) ;
		         					transvalue = delHtmlToExcel(tempString);
		         				}
							}
				} else {
					tempTdTextValue=result;
					//er.addValue(delHtmlToExcel(formatData(result))) ;
					transvalue = delHtmlToExcel(formatData(result));
				}
				if(htmltype.equals("1")){
					if(type == 2){ //整数
						if("1".equals(outputExcel)){
							er.addValue("".equals(transvalue)?"":Util.getNumStr(Util.getIntValue(transvalue, 0))) ;
		                }else{
		                	er.addValue(Util.getIntValue(transvalue, 0)) ;
		                }
					}else if(type == 3){	//浮点数
						tempTdTextValue = "".equals(transvalue)?"":Util.toDecimalDigits(Util.getNumStr(Util.getDoubleValue(transvalue, 0)),qfws);
						if("1".equals(outputExcel)){
							er.addValue("".equals(transvalue)?"":Util.toDecimalDigits(Util.getNumStr(Util.getDoubleValue(transvalue, 0)),qfws)) ;
		                }else{
		                	er.addValue(Util.getDoubleValue(transvalue, 0)) ;
		                }
					}else if(type == 4){
						tempTdTextValue = "".equals(transvalue)?"":Util.toDecimalDigits(Util.getNumStr(Util.getDoubleValue(transvalue, 0)),2);
						er.addStringValue(tempTdTextValue) ;
					}else {
						er.addStringValue(transvalue) ;
					}
					
				}else if(htmltype.equals("2")){
					  transvalue = result;
					  transvalue = transvalue.replaceAll("<span>","");
					  transvalue = transvalue.replaceAll("</span>","");
  	              	  transvalue = transvalue.replaceAll("</br>","\r\n"); 
				      er.addStringValue(transvalue) ;
				}else {
					er.addStringValue(transvalue) ;
				}
		%>
							<TD style="overflow: hidden; vertical-align: middle; white-space: nowrap; word-break: keep-all; text-overflow: ellipsis;" title="<%=Util.HTMLtoTxt(tempTdTextValue)%>" ><% if(tcolname.equals("c_requestname")){%><%=tempTdTextValue%><%}else{%><%=delHtml(tempTdTextValue)%><%} %></TD>
		<%
					}

		%>
						</TR>
						<tr class="Spacing" style="width:100%;height:1px!important;"><td colspan="<%=statcount !=0 ? colList.size()+1 : colList.size()%>" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>
		<%
    				es.addExcelRow(er) ;
				}
			}
		}
	}else{
    	RecordSet.execute(sql);
      	while(RecordSet.next()){
	        if(ordercount == 1) {
	            for(int i =0 ; i< fields.size() ; i++) {
	                if(((String)isdborders.get(i)).equals("1")) {
	                    tempvalue = Util.null2String(RecordSet.getString(i+1));
	                    if(!tempvalue.equals(tempdbordervalue)) {
	                        needstat = true ;
	                        tempdbordervalue = tempvalue ;
	                    }
	                    else {
	                        needstat = false ;
	                    }
	                }
	            }
	        }
			if(ordercount > 1){
            	List list  = new ArrayList();
            	for(int i =0 ; i< fields.size() ; i++) {
                	if(((String)isdborders.get(i)).equals("1")) {
						tempvalue += Util.null2String(RecordSet.getString(i+1));
					}
           		}
          
				if(!tempvalue.equals(tempdbordervalue)) {
					needstat = true ;
					tempdbordervalue = tempvalue ;
				} else {
					needstat = false ;
				}
				tempvalue = "";
			}
  
        	isfirst = false ;
        	er = es.newExcelRow () ;
			if(needchange ==0){
				needchange = 1;
		%>
  				<TR>
		<%
			}else{
  				needchange=0;
		%>
				<TR>
		<%
			}
			String temRequestid = RecordSet.getString("id");
			if(!temRequestid.equals(requestid)){
				isnew = true;
				requestid = temRequestid;
			}else{
				isnew = false;
			}
			if (statcount!=0) { 
				er.addValue("") ;
		%>
				<td></td>
		<%  } 
  			String leavetype = "";
			for(int i =0 ; i< fields.size() ; i++) {
				String result = Util.null2String(RecordSet.getString(i+1)) ;  	
				String tcolname= RecordSet.getColumnName(i+1);
				String htmltype = (String)htmltypes.get(i);
				int qfws = Util.getIntValue((String)qfwList.get(i));
				int type = Util.getIntValue((String)types.get(i)) ;

				String results[] = null ;
      
				if(htmltype.equals("-2")) {
					result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
				}if(htmltype.equals("2")){
					   String tempString=result;
    		           tempString = tempString.replaceAll("<p>","<br/>");  
    		           tempString = tempString.replaceAll("</p>","<br/>");  
    				   tempString = tempString.replaceAll("<script>initFlashVideo();</script>","");
        			   tempString = tempString.replaceAll("<br>","</br></span><span>");  
    		            result = "<span>"+tempString+"</span>";
				}
				if(htmltype.equals("3")) {
			        switch (type) {
			            case 1:
			                result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
			                break ;
			            case 23:
			                result = Util.toScreen(CapitalComInfo.getCapitalname(result),user.getLanguage()) ;
			                break ;
			            case 4:
			                result = Util.toScreen(DepartmentComInfo.getDepartmentname(result),user.getLanguage()) ;
			                break ;
			            case 6:
			                result = Util.toScreen(CostcenterComInfo.getCostCentername(result),user.getLanguage()) ;
			                break ;
			            case 7:
			                result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(result),user.getLanguage()) ;
			                break ;
			            case 8:
			                result = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(result),user.getLanguage()) ;
			                break ;
			            case 9:
			                result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage()) ;
			                break ;
			            case 12:
			                result = Util.toScreen(CurrencyComInfo.getCurrencyname(result),user.getLanguage()) ;
			                break ;
			            case 25:
			                result = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(result),user.getLanguage()) ;
			                break ;
			            case 14:
			            case 15:
			                result = Util.toScreen(LedgerComInfo.getLedgername(result),user.getLanguage()) ;
			                break ;
			            case 16:
			                result = Util.toScreen(RequestComInfo.getRequestname(result),user.getLanguage()) ;
			                break ;
			            case 17:
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
			            case 18:
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
			            case 24:
			                result = Util.toScreen(JobTitlesComInfo.getJobTitlesname(result),user.getLanguage()) ;
			                break ;
			            case 37:            // 增加多文档处理
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
			             case 57:            // 增加多部门处理
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
			            case 2:
			                break ;
			            case 19:
			                break ;
			            case 42:      //分部
			                result = Util.toScreen(SubCompanyComInfo.getSubCompanyname(result),user.getLanguage()) ;
			                break ;
			                
			            case 65: //多角色处理 added xwj for td2127 on 2005-06-20
			                Map roleMap  = new HashMap(); 
			                String sql_  = "select ID,RolesName from HrmRoles";
			                rs.executeSql(sql_);
			                while(rs.next()){
			                   roleMap.put(rs.getString("ID"),rs.getString("RolesName"));
			                }
			                results = Util.TokenizerString2(result,",");
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen((String)roleMap.get(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen((String)roleMap.get(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
             
			            case 141:
			            //人力资源条件
			            	result = resourceConditionManager.getFormShowName(result, user.getLanguage());            
			                break;
			            case 142:
			            //收发文单位
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break;
			            case 143:
			            	//树状文档
			            	results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break;
			            case 152:
			            	//多请求
			            	results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                		result = "";
			                    for(int j=0 ; j< results.length ; j++) {
			                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
			                       rs.executeSql(sql2);
					                   while(rs.next()){
					                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
					                   }
			                    }
			                    if(!result.equals("")) result = result.substring(0,result.length()-1);
			                }
			                break;
			            case 135:
			            	//多项目
			            	results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                		result = "";
			                    for(int j=0 ; j< results.length ; j++) {
			                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
			                       rs.executeSql(sql2);
					                   while(rs.next()){
					                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
					                   }
			                    }
			                    if(!result.equals("")) result = result.substring(0,result.length()-1);
			                }
			                break;
			            case 161:
						case 162:
			            	//自定义单选,多选
			                if(!result.equals("")) {
							//获取字段的数据库类型
							String tempfid=(String)fieldids.get(i);
							String tempfdbtype="";
								rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
			                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
			                    result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
							}
			                if (type==162) 
								{
								//if(!result.equals("")) result = result.substring(0,result.length()-1);
								}
			                break; 
						case 224:
						case 225:
						case 226:
						case 227:
			               result = result;
			                break;
						case 256:
						case 257:
							String tempfid=(String)fieldids.get(i);
							String tempfdbtype="";
							rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
		                    if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
							 result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
							break; 
			            default:
			                results = Util.TokenizerString2(result,",") ;
							if(results != null) {
									result = "";
			                    for(int j=0 ; j< results.length ; j++) {
			                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
								   rs.executeSql(sql2);
					                   while(rs.next()){
					                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
					                   }
			                    }
								if(!result.equals("")) result = result.substring(0,result.length()-1);
							}
					}
    			}
    
			    if(htmltype.equals("5"))
			    // 选择框字段
			    {
			        char flag = Util.getSeparator();
			        if(!result.equals("")){
				        rs.executeProc("workflow_SelectItemSByvalue", (String)fieldids.get(i) + flag + isbill + flag + result);
				        
				        if(rs.next())
				        {
				            result = Util.toScreen(rs.getString("selectname"), user.getLanguage());
				        }
				        else
				        {
				            result = "";
				        }
			      	}else{
						result = "";
			      	}
			    }
				if(htmltype.equals("6")) { 
			       switch (type) {
			        case 1:           
						results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0){
			                           //result =  " <a href=\"javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+results[j]+"')\">"+Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) +"</a> ";
			                           result =  Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage());
			                        }else{
			                            //result += "<br>"+  " <a href=\"javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+results[j]+"')\">"+Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) +"</a> ";
			                            result += "<br>"+ Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage());
			                        }
			                    }
			                }
			            break ;
			        	default:
			        }
				}
				if(htmltype.equals("1")) {   //处理超长的数字会成为科学计数法(如文本，电话号码)
					if (type==1) 
					{ 
						result=result+ " ";
					}
				}
				if (!rowNames.contains(RecordSet.getColumnName(i + 1))) {
					rowNames.add(RecordSet.getColumnName(i + 1));
				}
				if(((String)isstats.get(i)).equals("1")) {
			        double resultdouble = Util.getDoubleValue((String)statvalues.get(i) , 0) ;
			        double tempresultdouble = Util.getDoubleValue((String)tempstatvalues.get(i) , 0) ;

					statisticsRowKv.put(RecordSet.getColumnName(i + 1), Boolean.valueOf(!isdetails.get(i).equals("1")));

					if(!isdetails.get(i).equals("1")){
						if(isnew){
			                resultdouble += Util.getDoubleValue(result , 0) ;
			                tempresultdouble += Util.getDoubleValue(result , 0) ;
			                requestid = temRequestid;
			                statvalues.set(i, ""+resultdouble) ;
			                if("1".equals(outputExcel)){
			                	tempstatvalues.set(i, Util.toDecimalDigits(Util.getNumStr(tempresultdouble),qfws)) ;
			                }else{
			                	tempstatvalues.set(i, ""+tempresultdouble) ;
			                }
			            }else{
			                result = "0";
			            }
        			}else{
			            resultdouble += Util.getDoubleValue(result , 0) ;
			            tempresultdouble += Util.getDoubleValue(result , 0) ;
			            requestid = temRequestid;
			            statvalues.set(i, ""+resultdouble) ;
			            if("1".equals(outputExcel)){
		                	tempstatvalues.set(i, Util.toDecimalDigits(Util.getNumStr(tempresultdouble),qfws)) ;
		                }else{
		                	tempstatvalues.set(i, ""+tempresultdouble) ;
		                }
					}
				}
				String tempTdTextValue = "";
				String transvalue = "";
				if(!((String)isdborders.get(i)).equals("1") || ((String)isdborders.get(i)).equals("1") && (needstat||statcount== 0) ) {
					if(htmltype.equals("1") && (type==3)) {
						tempTdTextValue=formatData(result);
						///er.addValue(delHtmlToExcel(formatData(result))) ;
						transvalue = delHtmlToExcel(formatData(result));
					}else{
						tempTdTextValue=result;
						String tempString = Util.StringReplace(Util.getTxtWithoutHTMLElement(FieldInfo.toExcel(result)),"%nbsp;"," ");
					    tempString = Util.StringReplace(tempString,"&dt;&at;"," ");
						tempString = Util.StringReplace(tempString,"&amp;","&");
         				if((htmltype.equals("1")&&type==1)||htmltype.equals("2")) {
         					//er.addStringValue(delHtmlToExcel(tempString)) ;
         					transvalue = delHtmlToExcel(tempString);
         				} else {
         					//er.addValue(delHtmlToExcel(tempString)) ;
         					transvalue = delHtmlToExcel(tempString);
         				}
					}
				} else {
					tempTdTextValue=result;
					//er.addValue(delHtmlToExcel(formatData(result))) ;
					transvalue = delHtmlToExcel(formatData(result));
				}
				if(htmltype.equals("1")){
					if(type == 2){ //整数
						if("1".equals(outputExcel)){
							er.addValue("".equals(transvalue)?"":Util.getNumStr(Util.getIntValue(transvalue, 0))) ;
		                }else{
		                	er.addValue(Util.getIntValue(transvalue, 0)) ;
		                }
					}else if(type == 3){	//浮点数
						tempTdTextValue = "".equals(transvalue)?"":Util.toDecimalDigits(Util.getNumStr(Util.getDoubleValue(transvalue, 0)),qfws);
						if("1".equals(outputExcel)){
							er.addValue("".equals(transvalue)?"":Util.toDecimalDigits(Util.getNumStr(Util.getDoubleValue(transvalue, 0)),qfws)) ;
		                }else{
		                	er.addValue(Util.getDoubleValue(transvalue, 0)) ;
		                }
					}else if(type == 4){
						tempTdTextValue = "".equals(transvalue)?"":Util.toDecimalDigits(Util.getNumStr(Util.getDoubleValue(transvalue, 0)),2);
						er.addStringValue(tempTdTextValue) ;
					}else {
						er.addStringValue(transvalue) ;
					}
				}else if(htmltype.equals("2")){
					  transvalue = result;
					  transvalue = transvalue.replaceAll("<span>","");
					  transvalue = transvalue.replaceAll("</span>","");
  	                  transvalue = transvalue.replaceAll("</br>","\r\n"); 
				      er.addStringValue(transvalue) ;
				}else {
					er.addStringValue(transvalue) ;
				}
				
		%>
				<TD style="overflow: hidden; vertical-align: middle; white-space: nowrap; word-break: keep-all; text-overflow: ellipsis;" title="<%=Util.HTMLtoTxt(tempTdTextValue)%>" ><% if(tcolname.equals("c_requestname")){%><%=tempTdTextValue%><%}else{%><%=delHtml(tempTdTextValue)%><%} %></TD>
		<%
			}

		%>
				</TR>
				<tr class="Spacing" style="width:100%;height:1px!important;"><td colspan="<%=statcount !=0 ? colList.size()+1 : colList.size()%>" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>
		<%
    		es.addExcelRow(er) ;
		}
	}
    //如果存在
    if ("sqlserver".equals((dbType))) {
    	RecordSet.execute("drop table " + tmpTblName);
    }
    List qfws = new ArrayList();
    List newTempStatValues = new ArrayList();
    
    for(Iterator it = fieldids.iterator();it.hasNext();){
    	String fieldidStr = ((String) it.next()).toLowerCase();
    	int qfwsValue = 0;
    	RecordSet.execute("select * from workflow_billfield where billid = '"+formid+"' and id='"+fieldidStr+"'");
    	if(RecordSet.next()){
    		qfwsValue  = RecordSet.getInt("qfws");
    		if("1".equals(RecordSet.getString("fieldhtmltype"))&&("4".equals(RecordSet.getString("type")))){
    			qfwsValue = 2;
    		}
    		String fielddbtype = RecordSet.getString("fielddbtype");
    		if("1".equals(RecordSet.getString("fieldhtmltype"))&&("3".equals(RecordSet.getString("type"))|| "5".equals(RecordSet.getString("type")))){
    			int digitsIndex = fielddbtype.indexOf(",");
    			if(digitsIndex > -1){
    				qfwsValue = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
	        	}else{
	        		qfwsValue = 2;
	        	}
    		}
    		
    	}
    	qfws.add(qfwsValue+"");
    }
    for (Iterator it = rowNames.iterator();it.hasNext();) {
    	String rowName = (String) it.next();
    	Object obj = statisticsRowKv.get(rowName);
    	String tval = "";
    	if (obj != null) {
    		StringBuffer totalSql = new StringBuffer();
    		Boolean blnobj = (Boolean)obj;
    		boolean isTotal = blnobj.booleanValue(); 
    		if (isTotal) {
    			totalSql.append("select sum(t2.rowsum) as rowsum from ( select Avg(tbl." + rowName + ") as rowsum from ( ");
    			totalSql.append(oldsql);
    			totalSql.append(" ) tbl group by tbl.id) t2");
    		} else {
    			totalSql.append("select sum(t2.rowsum) as rowsum from ( select Avg(tbl." + rowName + ") as rowsum from ( ");
    			totalSql.append(oldsql);
    			totalSql.append(" ) tbl group by tbl." + rowName.substring(0, rowName.lastIndexOf("__") + 1) + "id_) t2");
    		}
    		RecordSet.execute(totalSql.toString());
    		if (RecordSet.next()) {
    			tval = String.valueOf(Util.getDoubleValue(Util.null2String(RecordSet.getString("rowsum")), 0));
    		} else {
    			tval = "0.00";
    		}
    	}else {
    		tval = "";
    	}
    	newTempStatValues.add(tval);
    }
    
    if(statcount != 0 && !isfirst ) {
        er = es.newExcelRow () ;
            %>
            <TR class="e8PageCountClass" style="vertical-align: middle;background-color:#e9f3fb !important;">
            <TD style="background-color:#e9f3fb !important; text-align: right; text-overflow: ellipsis; white-space: nowrap; height: 30px; vertical-align: middle; overflow: hidden; word-break: keep-all;" title="<%=SystemEnv.getHtmlLabelName(33273,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(33273,user.getLanguage()) %><!-- 当页合计  --></TD>
                <% 
                er.addValue(SystemEnv.getHtmlLabelName(523,user.getLanguage()));
                for(int i =0 ; i< tempstatvalues.size() ; i++) {
                	//er.addValue(delHtmlToExcel(formatData((String)tempstatvalues.get(i)))) ;
                	int len = Util.getIntValue((String)qfws.get(i));
                	er.addValue(formatData((String)tempstatvalues.get(i),len));
                %>
                <%-- --%>
                <TD style="background-color:#e9f3fb !important; text-overflow: ellipsis; white-space: nowrap; height: 30px; vertical-align: middle; overflow: hidden; word-break: keep-all;" title="<%=formatData((String)tempstatvalues.get(i),len)%>"><%=formatData((String)tempstatvalues.get(i),len)%></TD>
                <%tempstatvalues.set(i,"") ; }%>
            </tr>
            <tr class="Spacing e8PageCountSpacingClass" style="height: 1px !important;"><td colspan="<%=statcount !=0 ? colList.size()+1 : colList.size()%>" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>
    <%
    es.addExcelRow(er) ;
    }
    %>
    <%
    if (statcount !=0&&!"1".equals(outputExcel) ) {
        er = es.newExcelRow () ;
    %>
    <TR class="e8TotalCountClass" style="vertical-align: middle;background-color:#ecfdea !important">
    	 <TD style="background-color:#ecfdea !important; text-align: right; text-overflow: ellipsis; white-space: nowrap; height: 30px; vertical-align: middle; overflow: hidden; word-break: keep-all;" title="<%=SystemEnv.getHtmlLabelName(523,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(523,user.getLanguage()) %><!-- 总计 --></TD>
                <% 
                for(int i =0 ; i< newTempStatValues.size() ; i++) {
                	int len = Util.getIntValue((String)qfws.get(i));
                    er.addValue(Util.getDoubleValue(delHtmlToExcel(formatData((String)newTempStatValues.get(i),len)), 0)) ;
                %>
                <TD style="background-color:#ecfdea !important; text-overflow: ellipsis; white-space: nowrap; height: 30px; vertical-align: middle; overflow: hidden; word-break: keep-all;" title="<%=formatData((String)newTempStatValues.get(i), len)%>"><%=formatData((String)newTempStatValues.get(i), len)%></TD>
                <% }%>
                </tr>
                <tr class="Spacing e8TotalCountSpacingClass" style="height: 1px !important;"><td colspan="<%=statcount !=0 ? colList.size()+1 : colList.size()%>" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>
    <%
        es.addExcelRow(er) ;
	}
    %>
	</TBODY></TABLE>
</td>
</tr>
</table>
</div>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
	<tr><td colspan="<%=tempstatvalues.size()%>" align="right">
	<div align="right">
		<span class="e8_pageinfo">
			<input type="hidden" name="pageSize" value="<%=pageSize %>">
			<input type="hidden" name="currentPage" value="<%=currentPage %>">
			<input type="hidden" name="rowcount" value="<%=rowcount %>">
			<input type="hidden" name="pageCount" value="<%=pageCount %>">
			<% 
			String strnew = getSplitPageStringnew(pageSize, currentPage, rowcount, pageCount, "bottom", user);
			out.print(strnew);
	    	%>
	    </span>
	</div>
	</td></tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</table>
<div>
	<table class=ReportStyle>
		<TBODY>
			<TR>
				<TD>
					
					<B><%=SystemEnv.getHtmlLabelName(81959,user.getLanguage())%></B>：
					<BR>
					<%=SystemEnv.getHtmlLabelName(81960,user.getLanguage())%>
					<%=SystemEnv.getHtmlLabelName(81961,user.getLanguage())%>
					<%=SystemEnv.getHtmlLabelName(81962,user.getLanguage())%>
					<BR>
					<%=SystemEnv.getHtmlLabelName(81963,user.getLanguage())%>
					<%=SystemEnv.getHtmlLabelName(81964,user.getLanguage())%>
					<%=SystemEnv.getHtmlLabelName(81965,user.getLanguage())%>
					<BR>
					<BR>
					<%=SystemEnv.getHtmlLabelName(81966,user.getLanguage())%>
				</TD>
			</TR>
		</TBODY>
	</table>
	<br>
	<br>
</div>
 <%
ExcelFile.init() ;
ExcelFile.setFilename(Util.toScreen(reportname,user.getLanguage())) ;
ExcelFile.addSheet(Util.toScreen(reportname,user.getLanguage()), es) ;
 %>
 
 <%! 
 private String getSplitPageStringnew(int pageSize, int currentPage, int rowcount, int pageCount, String position, User user) {
	 	String sbf = "";
		int z_index = currentPage - 2;
		int y_num = currentPage + 2;
		int left_index = currentPage - 1;
		int right_index = currentPage + 1;
		String left = "";
		String right = "";
		String tempCent = "";
		String tempLeft = "";
		String tempRight = "";
		
		left = "<span class=\"e8_pageinfo\"><span class=\"e8_numberspan weaverTablePrevPageOfDisabled weaverTablePage\"  ";
		if(left_index > 0){
			left += " onClick=\"jumpTo(" + left_index + ")\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\" ";
		}
		left += ">&lt;</span>";
		if (z_index > 1) {
		    tempLeft += "<span _jumpTo=\"1\" onClick=\"jumpTo(1)\" class=\"e8_numberspan\">" + 1 + "</span>";
		}
		if (z_index > 2) {
		    tempLeft += "<span class=\"e8_numberspan\">&nbsp;...&nbsp;</span>";
		}
		
		if (y_num < (pageCount - 1)) {
		    tempRight += "<span class=\"e8_numberspan\">&nbsp;...&nbsp;</span>";
		}
		
		if (y_num < pageCount) {
			tempRight += "<span class=\"e8_numberspan\" _jumpTo=\"1\" onClick=\"jumpTo(" + pageCount + ")\" >" + pageCount + "</span>";
		}
		right = "<span class=\"e8_numberspan weaverTablePage weaverTableNextPage\" ";
		if(right_index <= pageCount){
			right += " onClick=\"jumpTo(" + right_index + ")\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\" ";
		}
		right += ">&gt;</span>";
		
		
		for(;z_index<=y_num; z_index++) {
		    if (z_index>0 && z_index<=pageCount) {
		        if (z_index == currentPage) {
		            tempCent +="<span _jumpTo=\"" + z_index + "\"  class=\"e8_numberspan weaverTableCurrentPageBg\">" + z_index + "</span>";                
		        } else {
		            tempCent +="<span class=\"e8_numberspan\" _jumpTo=\"" + z_index + "\" onClick=\"jumpTo(" + z_index + "," + z_index + ")\">" + z_index + "</span>";
		        }
		    }
		}
		
		sbf = left + tempLeft + tempCent + tempRight + right;
		
		String pageString = "";
	    pageString += "<div class=\"K13_select\" style=\"width: 40px; z-index: 10000;\">";
	    pageString += "    <div class=\"K13_select_checked\" >";
	    pageString += "    <input class=\"_pageSizeInput\" onmouseout=\"hiddenOl()\" onclick=\"clickShow()\" maxlength=\"3\" style=\"width:40px;background:transparent;text-align:center;border:1px solid transparent;color:#fff;height:26px;vertical-align:top;\" type=\"text\" value=\""+pageSize+"\" name=\"pageSizeSel1inputText\" id=\"pageSizeSel1inputText\">";
	    pageString += "    </div>";
	    pageString += "    <div class=\"K13_select_list\" onmouseover=\"showOl()\" onmouseout=\"hiddenOl()\" style=\"padding-bottom: 1px; top: -125px; display: none;\">";
	    pageString += "	    <ol>";
	    pageString += "		    <li class=\"\" onclick=\"changepageSizeSel1(10)\">10</li>";
	    pageString += "		    <li class=\"\" onclick=\"changepageSizeSel1(20)\">20</li>";
	    pageString += "		    <li class=\"\" onclick=\"changepageSizeSel1(50)\">50</li>";
	    pageString += "		    <li class=\"\" onclick=\"changepageSizeSel1(100)\">100</li>";
	    pageString += "	    </ol>";
	    pageString += "    </div>";
	    pageString += "    <select class=\"_pageSize\" id=\"pageSizeSel1\" name=\"pageSizeSel1\" style=\"background-color: transparent; border: none; width: 50px; text-align: center; text-decoration: none; height: 20px; padding-right: 2px; margin-left: 5px; margin-right: 5px; line-height: 20px; display: none; background-position: initial initial; background-repeat: initial initial;\">";
	    pageString += "	    <option value=\"10\">10</option>";
	    pageString += "	    <option value=\"20\">20</option>";
	    pageString += "	    <option value=\"50\">50</option>";
	    pageString += "	    <option value=\"100\">100</option>";
	    pageString += "    </select>";
	    pageString += "</div>";
		
		String result = "";
	    result += "<span style=\"float:left;TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;\">"+SystemEnv.getHtmlLabelName(15323,user.getLanguage())+"</span>";//第
	    result += "<span  id=\"jumpTo" + position + "_go_page_wrap\" style=\"float:left;display:inline-block;width:30px;height:20px;border:1px solid #FFF;margin:0px 1px;padding:0px;position:relative;left:0px;top:5px;\">";
	    result += "<span  id=\"jumpTo" + position + "-goPage\" onClick=\"jumpTo(document.getElementById('jumpTo" + position + "').value, document.getElementById('jumpTo" + position + "'))\" style=\"float:left;cursor:pointer;width: 44px; height: 22px; line-height: 20px; padding: 0px; text-align: center; border: 0px; background-color: rgb(0, 99, 220); color: rgb(255, 255, 255); position: absolute; left: 0px; top: -1px; display: none;z-index:10000\">"+SystemEnv.getHtmlLabelName(30911,user.getLanguage())+"</span>";//跳转
	    result += "<input id=\"jumpTo" + position + "\" type=\"text\" onfocus=\"focus_goPage(this)\" value=\""+ currentPage +"\"  onblur=\"blur_goPage(this)\" size=\"3\" onmouseover=\"if(jQuery('#jumpTobottom-goPage').css('display')=='none'){jQuery(this).css('border','1px solid #DDDDDD');}\" onmouseout=\"jQuery(this).css('border','1px solid transparent')\" style=\"color: rgb(102, 102, 102); width: 30px; height: 18px; line-height: 18px; float: left; text-align: center; position: absolute; left: 0px; top: 0px; outline: none; border: 1px solid transparent;\"></span>";
	    
	    result += "<span style=\"float:left;TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;padding-right:10px;\">"+SystemEnv.getHtmlLabelName(30642,user.getLanguage())+"</span>";//页
	    //跳转 按钮在火狐中折行 的问题是 width:38px值太小 —— 要改为width:50px;
	    result += "<span class=\"e8_splitpageinfo\">";
	    result += "<span style=\"position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">"+pageString+""+SystemEnv.getHtmlLabelName(18256,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(30642,user.getLanguage())+"&nbsp;|&nbsp;"+SystemEnv.getHtmlLabelName(18609,user.getLanguage())+""+rowcount+""+SystemEnv.getHtmlLabelName(18256,user.getLanguage());//条/页 共 条
	    result += "</span>";
	    result += "</span>";
	    result += "</span>";
	    
	    sbf += result;
		 return sbf;
	 }

 private String delHtml(final String inputString) {
     String htmlStr = new weaver.workflow.mode.FieldInfo().toExcel(inputString); // 含html标签的字符串
     //String htmlStr = inputString;
     htmlStr = Util.StringReplace(htmlStr, "&dt;&at;", "<br>");
     
     String textStr = "";
     java.util.regex.Pattern p_script;
     java.util.regex.Matcher m_script;
     java.util.regex.Pattern p_html;
     java.util.regex.Matcher m_html;

     try {
         String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式

         String regEx_script = "<[/s]*?script[^>]*?>[/s/S]*?<[/s]*?//[/s]*?script[/s]*?>"; // 定义script的正则表达式{或<script[^>]*?>[/s/S]*?<//script>

         p_script = java.util.regex.Pattern.compile(regEx_script, java.util.regex.Pattern.CASE_INSENSITIVE);
         m_script = p_script.matcher(htmlStr);
         htmlStr = m_script.replaceAll(""); // 过滤script标签
		 
         htmlStr = htmlStr.replaceAll("<br>","");
         /**p_html = java.util.regex.Pattern.compile(regEx_html, java.util.regex.Pattern.CASE_INSENSITIVE);
         m_html = p_html.matcher(htmlStr);
         htmlStr = m_html.replaceAll(""); // 过滤html标签**/

         textStr = htmlStr;

     } catch (Exception e) {
         System.err.println("Html2Text: " + e.getMessage());
     }
     //return Util.HTMLtoTxt(textStr).replaceAll("%nbsp;", "").replaceAll("%nbsp","").trim();// 返回文本字符串
     return textStr.replaceAll("%nbsp;", " ").replaceAll("%nbsp"," ").trim();
 }
     
 private String delHtmlToExcel(final String inputString) {
     String htmlStr = new weaver.workflow.mode.FieldInfo().toExcel(inputString); // 含html标签的字符串
     htmlStr = Util.StringReplace(htmlStr, "&dt;&at;", "<br>");
     htmlStr = Util.StringReplace(htmlStr, "<script>initFlashVideo();</script>", "");
     String textStr = "";
     java.util.regex.Pattern p_script;
     java.util.regex.Matcher m_script;
     java.util.regex.Pattern p_html;
     java.util.regex.Matcher m_html;

     try {
         String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式

         String regEx_script = "<[/s]*?script[^>]*?>[/s/S]*?<[/s]*?//[/s]*?script[/s]*?>"; // 定义script的正则表达式{或<script[^>]*?>[/s/S]*?<//script>

         p_script = java.util.regex.Pattern.compile(regEx_script, java.util.regex.Pattern.CASE_INSENSITIVE);
         m_script = p_script.matcher(htmlStr);
         htmlStr = m_script.replaceAll(""); // 过滤script标签

         p_html = java.util.regex.Pattern.compile(regEx_html, java.util.regex.Pattern.CASE_INSENSITIVE);
         m_html = p_html.matcher(htmlStr);
         htmlStr = m_html.replaceAll(""); // 过滤html标签

         textStr = htmlStr;

     } catch (Exception e) {
         System.err.println("Html2Text: " + e.getMessage());
     }
     return Util.HTMLtoTxt(textStr).replaceAll("%nbsp;", " ").replaceAll("%nbsp", " ").trim();// 返回文本字符串
 }
     
 private String formatData(String inData){
     if(inData==null||inData.equals("")){
         return "";
     }
     try{
         return Util.null2String(inData).equals("")?"0":Util.null2String(inData);
     }catch(Exception e){
         return inData;
     }
 }
 private String formatData(String inData, int len){
     if(inData==null||inData.equals("")){
         return "";
     }
     try{
     	 BigDecimal bd = new BigDecimal(inData);
     	 bd.setScale(len, BigDecimal.ROUND_HALF_UP);
     	 return Util.toDecimalDigits(bd.toPlainString(), len);
         //double _bd = new BigDecimal(  Util.null2String(inData).equals("")?"0":Util.null2String(inData) ).setScale(len,BigDecimal.ROUND_HALF_UP).doubleValue();
         //NumberFormat nf = NumberFormat.getInstance();
         //return nf.format(_bd);
     }catch(Exception e){
         return inData;
     }
 }
 %>
</BODY>
<%
if("1".equals(outputExcel)){
	ExcelFile.init();
	ExcelFile.setFilename(Util.toScreen(reportname,user.getLanguage())) ;
	ExcelFile.addSheet(Util.toScreen(reportname,user.getLanguage()), es) ;
}
%>
</HTML>
<script type="text/javascript">
<!--
<%if("1".equals(outputExcel)){%>
	//window.parent.document.getElementById("excelwaitDiv").style.display = "none";	
	window.parent.e8showAjaxTips("",false);
	window.location.href = "/weaver/weaver.file.ExcelOut";
<%}%>
//-->
</script>
