
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
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
String userid = ""+user.getUID();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


String CustomerID = Util.null2String(request.getParameter("CustomerID"));


/*check right begin*/
StringBuffer tableInfo = new StringBuffer();

tableInfo.append("<TABLE class=ListStyle cellspacing=1>");
tableInfo.append("<COLGROUP>");
tableInfo.append("<COL width=\"30%\">");
tableInfo.append("<COL width=\"30%\">");
tableInfo.append("<COL width=\"40%\">");
tableInfo.append("<TBODY>");
tableInfo.append("<TR class=Header>");
tableInfo.append("<th>"+SystemEnv.getHtmlLabelName(97,user.getLanguage())+"</th>");
tableInfo.append("<th>"+SystemEnv.getHtmlLabelName(277,user.getLanguage())+"</th>");	    
tableInfo.append("<th>"+SystemEnv.getHtmlLabelName(616,user.getLanguage())+"</th>");	      
tableInfo.append(" </TR>");
tableInfo.append(" <TR class=Line style='height: 1px'><TD colSpan=3 style='padding:0'></TD></TR>");

boolean isLight = false;
char flag=2;
int nLogCount=0;
RecordSetEX.executeProc("ExchangeInfo_SelectBID",CustomerID+flag+"CC");
while(RecordSetEX.next())
{
nLogCount++;
	if (nLogCount==2) {
	tableInfo.append(" </tbody></table>");
	tableInfo.append("<div  id=WorkFlowDiv style=\"display:none\">");
	tableInfo.append("<table class=ListStyle cellspacing=1>");
	tableInfo.append("<COLGROUP>");
	tableInfo.append("<COL width=\"30%\">");
	tableInfo.append("<COL width=\"30%\">");
	tableInfo.append("<COL width=\"40%\">");
	tableInfo.append("<tbody>");
	}
	if(isLight){
		tableInfo.append("<TR CLASS=DataLight>");
	}else{
		tableInfo.append("<TR CLASS=DataDark>");
	}
	tableInfo.append("<TD>"+RecordSetEX.getString("createDate")+"</TD>");
	tableInfo.append("<TD>"+RecordSetEX.getString("createTime")+"</TD>");
	tableInfo.append("<TD>");  
      
	if(Util.getIntValue(RecordSetEX.getString("creater"))>0){
		tableInfo.append("<a href=\"/hrm/resource/HrmResource.jsp?id="+RecordSetEX.getString("creater")+"\">"+Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())+"</a>");  
	}else{
		tableInfo.append("<A href='/CRM/data/ViewCustomer.jsp?CustomerID="+RecordSetEX.getString("creater").substring(1)+"'>"+CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))+"</a>");
	}
	tableInfo.append("  </TD>");
	tableInfo.append("  </TR>");	

	if(isLight){
		tableInfo.append("<TR CLASS=DataLight>");
	}else{
		tableInfo.append("<TR CLASS=DataDark>");
	}
	tableInfo.append("<TD colSpan=3  style=\"word-break:break-all\" >"+Util.toScreen(RecordSetEX.getString("remark"),user.getLanguage())+"</TD>");
	tableInfo.append("</TR>");      
      

	if(isLight){
		tableInfo.append("<TR CLASS=DataLight>");
	}else{
		tableInfo.append("<TR CLASS=DataDark>");
	}
    String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
    String docsname="";
    if(!docids_0.equals("")){

        ArrayList docs_muti = Util.TokenizerString(docids_0,",");
        int docsnum = docs_muti.size();

        for(int i=0;i<docsnum;i++){
            docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a>" +" ";
        }
    }
    tableInfo.append("<td  colSpan=3 >"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+":"+docsname);
   	tableInfo.append("</TR>");
       
	isLight = !isLight;
}
tableInfo.append(" </TBODY>");
tableInfo.append(" </TABLE>");
	 
if (nLogCount>=2) { 
	tableInfo.append(" </div>");  
}
tableInfo.append(" <table class=ListStyle cellspacing=1>");  
tableInfo.append("<COLGROUP>");
tableInfo.append("<COL width=\"30%\">");
tableInfo.append("<COL width=\"30%\">");
tableInfo.append("<COL width=\"40%\">");
tableInfo.append("<tbody>");

       
if (nLogCount>=2) { 
	tableInfo.append(" <tr class=header>");
	tableInfo.append("<td align=right colspan=3><SPAN id=WorkFlowspan><a href=\"#\" onClick= \"parent.setTabPanelActive('crmExchange')\" target=\"_self\">"+SystemEnv.getHtmlLabelName(332,user.getLanguage())+"</a></span></td>");
	tableInfo.append(" </TR>");
}

tableInfo.append(" </TBODY>");
tableInfo.append(" </TABLE>");

out.println(tableInfo.toString());        
%>         