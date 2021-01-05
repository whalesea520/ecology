
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String logintype = ""+user.getLogintype();
logintype="1";  //表WorkPlanShareDetail usertype字段都是为1，所以，如果客户门户登陆的话，永远查询不到数据

String userid = ""+user.getUID();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


String CustomerID = Util.null2String(request.getParameter("CustomerID"));
char flag=Util.getSeparator() ;
String clientip=request.getRemoteAddr();
RecordSetLog.executeProc("CRM_ViewLog1_Insert",CustomerID+""+flag+userid+""+flag+user.getLogintype()+""+flag+CurrentDate+flag+CurrentTime+flag+clientip);


/*check right begin*/
StringBuffer tableInfo = new StringBuffer();
tableInfo.append("<TABLE id='customConnectionExt' width=\"100%\" >");
//tableInfo.append("<COLGROUP>");
//tableInfo.append("<COL width=\"25%\">");
//tableInfo.append("<COL width=\"25%\">");
//tableInfo.append("<COL width=\"25%\">");
//tableInfo.append("<COL width=\"25%\">");
tableInfo.append("<tr>");
tableInfo.append("<td colspan=\"4\">");
tableInfo.append("<table class=ListStyle cellspacing=\"1\">");			
tableInfo.append("<COLGROUP>");					
tableInfo.append("<COL width=\"25%\">");						
tableInfo.append("<COL width=\"25%\">");
tableInfo.append("<COL width=\"25%\">");
tableInfo.append("<COL width=\"*\">");

boolean isLight = true;
int nLogCount = 0;
String sql="";
if(CoworkDAO.haveRightToViewCustomer(userid,CustomerID)){//fix TD2536
	if (RecordSetC.getDBType().equals("oracle"))
		sql = " SELECT * FROM ( SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
			+ " FROM WorkPlan WHERE id IN ( "
		    + " SELECT DISTINCT a.id FROM WorkPlan a "
			+ " where (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + CustomerID + ",%'"
			+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC) where rownum <= 3";
	else if (RecordSetC.getDBType().equals("db2"))
	sql = " SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
		+ " FROM WorkPlan WHERE id IN ( "
	    + " SELECT DISTINCT a.id FROM WorkPlan a "
		+ " where (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + CustomerID + ",%'"
		+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC fetch first 3 rows only";
	else
		sql = "SELECT TOP 3 id, begindate , begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
			+ " FROM WorkPlan WHERE id IN ("
		    + "SELECT DISTINCT a.id FROM WorkPlan a"
		    + " where (',' + a.crmid + ',') LIKE '%," + CustomerID + ",%'"
			+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
}else{
	if (RecordSetC.getDBType().equals("oracle"))
		sql = " SELECT * FROM ( SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
			+ " FROM WorkPlan WHERE id IN ( "
		    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
	        + " WHERE a.id = b.workid"
			+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + CustomerID + ",%'"
			+ " AND b.usertype = "+logintype + " AND b.userid = " + String.valueOf(userid)
			+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC) where rownum <= 3";
	else if (RecordSetC.getDBType().equals("db2"))
	    sql = "SELECT id, begindate , begintime, resourceid, description, createrid, createrType,taskid, crmid, requestid, docid"
			+ " FROM WorkPlan WHERE id IN ("
		    + "SELECT DISTINCT a.id FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid"
			+ " AND (',' + a.crmid + ',') LIKE '%," + CustomerID + ",%'"
			+ " AND b.usertype = " + logintype + " AND b.userid = " + String.valueOf(userid)
			+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC fetch first 3 rows only ";
	else
		sql = "SELECT TOP 3 id, begindate , begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
			+ " FROM WorkPlan WHERE id IN ("
		    + "SELECT DISTINCT a.id FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid"
		    + " AND (',' + a.crmid + ',') LIKE '%," + CustomerID + ",%'"
			+ " AND b.usertype = " + logintype + " AND b.userid = " + String.valueOf(userid)
			+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
}
//RecordSetC.writeLog(sql);
//System.out.println("sql444=="+sql);
String m_beginDate = "";
String m_beginTime = "";
String m_memberId = "";
String m_createrType = "";
String m_description = "";
RecordSetC.executeSql(sql);
while (RecordSetC.next()) {
	m_beginDate = Util.null2String(RecordSetC.getString("begindate"));
	m_beginTime = Util.null2String(RecordSetC.getString("begintime"));
	m_memberId = Util.null2String(RecordSetC.getString("createrid"));
	m_createrType = Util.null2String(RecordSetC.getString("createrType"));
	m_createrType="1";
	m_description = Util.null2String(RecordSetC.getString("description"));
	String relatedprj = Util.null2String(RecordSetC.getString("taskid"));
	String relatedcus = Util.null2String(RecordSetC.getString("crmid"));
	String relatedwf = Util.null2String(RecordSetC.getString("requestid"));
	String relateddoc = Util.null2String(RecordSetC.getString("docid"));
	ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
	ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
	ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
	ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");

	nLogCount++;

	if (nLogCount > 2)
		break;

	if(isLight){
		tableInfo.append(" <TR CLASS=DataLight>");
	}else{
		tableInfo.append(" <TR CLASS=DataDark>");
	}
	//tableInfo.append("<tr class=\"Header\">");
	tableInfo.append(" <td colspan=\"4\">");
   
	   
if (m_createrType.equals("1")) {
	if (!m_memberId.equals("")) {
		if (!logintype.equals("2")) {
						tableInfo.append(" <A href=\"/hrm/resource/HrmResource.jsp?id="+m_memberId+"\">"+ResourceComInfo.getResourcename(m_memberId)+"</A>&nbsp");	
		}
	}else{
		if (!m_memberId.equals("")) {
			tableInfo.append(" <A href=\"/CRM/data/ViewCustomer.jsp?CustomerID="+m_memberId+"\">"+CustomerInfoComInfo.getCustomerInfoname(m_memberId)+"</A>&nbsp");
		}
	}
	tableInfo.append(" "+m_beginDate+" "+m_beginTime);
	tableInfo.append("</td>");
	tableInfo.append(" </tr>");

	if(isLight){
		tableInfo.append(" <TR CLASS=DataLight>");
	
	}else{
		tableInfo.append(" <TR CLASS=DataDark>");
	
	}
	tableInfo.append(" <TD style=\"word-break:break-all\"  colSpan=4>");
	tableInfo.append(Util.toScreen(m_description,user.getLanguage()));
	tableInfo.append("</TD>");	
	tableInfo.append("</TR>");	
	//tableInfo.append("<tr><td class=Line colspan=4></td></tr>");	
		
	
	
	if(isLight){
		tableInfo.append(" <TR CLASS=DataLight>");
	}else{
		tableInfo.append(" <TR CLASS=DataDark>");
	}
	tableInfo.append("<td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"</td>");	
	tableInfo.append("<td>"+SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())+"</td>");	
	tableInfo.append("<td>"+SystemEnv.getHtmlLabelName(783,user.getLanguage())+"</td>");
	tableInfo.append("<td>"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"</td>");
	tableInfo.append("</tr>");
	//tableInfo.append("<tr><td class=Line colspan=4></td></tr>");
  
  	if(relateddocList.size()+relatedprjList.size()+relatedcusList.size()+relatedwfList.size()!=0){
  		if(isLight){
  			tableInfo.append(" <TR CLASS=DataLight>");
  		}else{
  			tableInfo.append(" <TR CLASS=DataDark>");
  		}
  		tableInfo.append("<td>");
    
		for(int i=0;i<relateddocList.size();i++){
			tableInfo.append("<a href=\"/docs/docs/DocDsp.jsp?id="+relateddocList.get(i).toString()+"\">");
			tableInfo.append(DocComInfo.getDocname(relateddocList.get(i).toString())+"<br></a>");
		}
		tableInfo.append("</td>");
		tableInfo.append(" <td>");
   
		for(int i=0;i<relatedprjList.size();i++){
			tableInfo.append("<a href=\"/proj/process/ViewTask.jsp?taskrecordid="+relatedprjList.get(i).toString()+"\">");
			tableInfo.append(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString())+"<br></a>");
		}
		tableInfo.append("</td>");
		tableInfo.append(" <td>");
		for(int i=0;i<relatedcusList.size();i++){
			tableInfo.append("<a href=\"/CRM/data/ViewCustomer.jsp?CustomerID="+relatedcusList.get(i).toString()+"\">");
			tableInfo.append(CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())+"<br></a>");
		}
		tableInfo.append("</td>");
		tableInfo.append(" <td>");
		for(int i=0;i<relatedwfList.size();i++){
			tableInfo.append("<a href=\"/workflow/request/ViewRequest.jsp?requestid="+relatedwfList.get(i).toString()+"\">");
			tableInfo.append(RequestComInfo.getRequestname(relatedwfList.get(i).toString())+"<br></a>");
		}
				
		tableInfo.append("</td>");
		//tableInfo.append(" <td>");
		//tableInfo.append(" <tr><td class=Line colspan=4></td></tr>");
 
	}
	isLight=!isLight;
	}
}
		
if (nLogCount > 2) {
	tableInfo.append("<TR>");
	tableInfo.append(" <TD align=right colspan=4><a href=\"#\" onClick= \"parent.setTabPanelActive('crmContract')\" target=\"_self\">");
	tableInfo.append(SystemEnv.getHtmlLabelName(332,user.getLanguage())+"</a>&nbsp;&nbsp;</TD>");
	tableInfo.append("</tr>");
	
}
tableInfo.append("</table>");
tableInfo.append("</td>");
tableInfo.append("</tr>");
tableInfo.append("</TABLE>");
out.println(tableInfo.toString());        
%>         