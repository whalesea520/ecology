
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>

<html >
<head id="Head1">
	<%
	
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		Calendar today = Calendar.getInstance();
		int currentyear=today.get(Calendar.YEAR);
		int year = Util.getIntValue(request.getParameter("year"),currentyear);
		String type = Util.null2String(request.getParameter("type"));
		int month = Util.getIntValue(request.getParameter("month"),1);
		
		
	%>
    <title>	My Calendar </title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" /> 
    <link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF" />
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curSkin %>/wui_wev8.css'/>
    <script type="/js/jquery/ui/ui.dialog_wev8.js"  type="text/javascript"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>


</head>
<body scroll="no">
<div id="listdiv">
  <%
     int userid = user.getUID();
     String ym = "" +year +"-"+ (month > 9?month:("0"+month));
   	 String returnStr = "" ;  
   	 returnStr=" and  ('"+ym+"'" + " between SUBSTRING(t1.begindate,1,7) and SUBSTRING(t1.enddate,1,7)) " ;
   	 if(!"".equals(type)){
   	 	returnStr += "and t1.meetingtype = " + type ;
   	 }
     
    if ((RecordSet.getDBType()).equals("oracle")) {
    	returnStr = Util.StringReplace(returnStr,"SUBSTRING","substr");   
    }
        
	String backfields = "t1.id,t1.name,t1.address,t1.customizeAddress,t1.caller,t1.contacter,t1.begindate,t1.cancel,t1.begintime,t1.enddate,t1.endtime,t1.meetingstatus,t1.isdecision,t1.description, t3.status as status,t.id as tid, t.name as typename ";
	String fromSql = "  Meeting t1 left join Meeting_View_Status t3 on t3.meetingId = t1.id and t3.userId = " + userid + ", Meeting_Type  t ";
		
	String whereSql = " where t1.meetingtype = t.id and t1.meetingstatus <> 0 and t1.repeatType = 0 " + returnStr;
   	int  perpage=5;
    
//System.out.println("sql111:select "+ backfields + " from "+ fromSql + whereSql);
     String orderby = " t1.begindate ,t1.begintime , t1.id" ;
     String tableString = "";
   	tableString =" <table instanceid=\"meetingTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+ 
                          "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(whereSql)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" />"+
                          "			<head>"+
                          "				<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(2151,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingName\" otherpara=\"column:id+column:status\" />"+
                          "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(2152,user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
                          "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(2152,user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
                          "				<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+"\" column=\"address\" orderkey=\"address\" otherpara=\""+user.getLanguage()+"+column:customizeaddress\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingAddress\" />"+
           				  "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate,begintime\" otherpara=\"column:begintime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
                          "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate,endtime\" otherpara=\"column:endtime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
                          "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingstatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision\" orderkey=\"meetingstatus\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingStatus\" />"+
                          "			</head>"+
                          "</table>";
  %>
  <wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run" />
</div>

</body>
</html>
<script type="text/javascript">

	window.parent.setWindowSize(window.parent.document);

function pointerXY(event,doc)  
{  

} 

function openhrm(tempuserid)
{
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+tempuserid);
}


function afterDoWhenLoaded(){
	window.parent.setWindowSize(window.parent.document);
}
document.oncontextmenu=function(){
	   return false;
	}
	
function doCancel(id){
	window.parent.doCancel(id);
}
var diag_vote;
function view(id)
{
	if(id!="0" && id !=""){
		if(window.top.Dialog){
			diag_vote = new window.top.Dialog();
		} else {
			diag_vote = new Dialog();
		}
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 550;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
		diag_vote.URL = "/meeting/data/ViewMeetingTab.jsp?meetingid="+id;
		diag_vote.show();
	}
}


function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	doSearchsubmit();
}
</script>
