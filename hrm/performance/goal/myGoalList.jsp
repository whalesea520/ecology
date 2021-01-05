<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

/*
if(!HrmUserVarify.checkUserRight("SetGoal:Performance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
*/

String goalType = "";
int objId = 0;
String goalDate = "";
String cycle = "";

//TD4195
//added by hubo,2006-04-19
if(SessionOper.getAttribute(session,"goalGroupId")!=null){SessionOper.removeAttribute(session,"goalGroupId");}

int companyId = Util.getIntValue(request.getParameter("companyid"));
int subCompanyId = Util.getIntValue(request.getParameter("subcompanyid"));
int departmentId = Util.getIntValue(request.getParameter("departmentid"));
int hrmId = Util.getIntValue(request.getParameter("hrmid"));

String selectCycle = Util.null2String(request.getParameter("selectCycle"));
if( !selectCycle.equals("y") ){
	//集团目标
	if(companyId==0){
		goalType="0";
		objId=companyId;
	}
	//分公司目标
	if(companyId==-1 && departmentId==-1){
		goalType = "1";
		objId = subCompanyId;
	}
	//部门目标
	if(companyId==-1 && subCompanyId==-1){
		goalType="2";
		objId=departmentId;
	}
	//人员目标
	if(companyId==-1 && subCompanyId==-1 && departmentId==-1){
		goalType="3";
		objId=hrmId;
	}
	//默认当前用户
	if(companyId==-1 && subCompanyId==-1 && departmentId==-1	&& hrmId==-1){
		goalType="3";
		objId = user.getUID();
	}
	SessionOper.setAttribute(session,"goalType",goalType);
	SessionOper.setAttribute(session,"objId",new Integer(objId));
}

//out.println(goalType);
//out.println("goalDate"+SessionOper.getAttribute(session,"goalDate"));
//out.println("cycle"+SessionOper.getAttribute(session,"cycle"));

cycle = Util.null2String(request.getParameter("cycle"));
if(cycle.equals("")){
	if(SessionOper.getAttribute(session,"cycle")==null){
		cycle = "3";
	}else{
		cycle = (String)SessionOper.getAttribute(session,"cycle");
	}
}

String year = SessionOper.getAttribute(session,"year")==null ? TimeUtil.getFormartString(Calendar.getInstance(),"yyyy") : (String)SessionOper.getAttribute(session,"year");

//==============================================================================================
//TD4028
//added by hubo,2006-03-23
boolean fromRemind = false;
String month = "";
String season = "";
if(request.getParameter("goalDate")!=null && !request.getParameter("goalDate").equals("")){
	fromRemind = true;
	goalType = Util.null2String(request.getParameter("goalType"));
	objId = Util.getIntValue(request.getParameter("objId"));
	goalDate = Util.null2String(request.getParameter("goalDate"));
	cycle = Util.null2String(request.getParameter("cycle"));
	if(cycle.equals("0")){
		month = goalDate.substring(4,goalDate.length());
	}else if(cycle.equals("1")){
		season = goalDate.substring(4,goalDate.length());
	}
	SessionOper.setAttribute(session,"goalType",goalType);
	SessionOper.setAttribute(session,"objId",new Integer(objId));
}
//==============================================================================================
%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{background-image:url(/images/tab2.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{padding-top:2px;background-image:url(/images/tab.active2.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</head>

<body style="overflow:hidden" <%if(fromRemind){%>onload="goIframeForRemind('<%=cycle%>','<%=month%>','<%=season%>')"<%}%>>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:100%;height:100%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
<colgroup>
<col width="79"></col>
<col width="79"></col>
<col width="79"></col>
<col width="79"></col>
<col width="*"></col>
</colgroup>
<tr height="20">
	<td class="cycleTD" onclick="goIframe('3')">
		<select id="currentYear"
			onchange="setGoalYear()" style="font-weight:normal;color:#000">
			<script>
			for(var i=<%=year%>-10;i<<%=year%>+11;i++){
				if(i==<%=year%>){
					document.write("<option value=\""+i+"\" selected>"+i+"</option>");
				}else{
					document.write("<option value=\""+i+"\">"+i+"</option>");
				}
			}
			</script>
		</select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
	</td>
	<td class="cycleTD" onclick="goIframe('2')"><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%></td>
	<td class="cycleTD" onclick="goIframe('1')"><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></td>
	<td class="cycleTD" onclick="goIframe('0')"><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
	<td id="subTab" style="">&nbsp;</td>
</tr>
<tr>
	<td colspan="5" style="padding:0;">
	<iframe name="myGoalListIframe" id="myGoalListIframe" src="myGoalListIframe.jsp" frameborder="0" scrolling="auto" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0"></iframe>
	</td>
</tr>
</table>
<script type="text/javascript">
var cellIndex = Math.abs(<%=cycle%>-3);
document.getElementById("tabPane").rows[0].cells[cellIndex].className = "cycleTDCurrent";

function goIframe(c){
	if(window.event.srcElement.tagName=="SELECT")	return false;
	document.getElementById("myGoalListIframe").src = "myGoalListIframe.jsp?cycle="+c;
	with(document.getElementById("tabPane")){
		for(var i=0;i<rows[0].cells.length-1;i++){
			rows[0].cells[i].className = "cycleTD";
		}
	}
	window.event.srcElement.className = "cycleTDCurrent";
}

function goIframeForRemind(c,m,s){
	document.getElementById("myGoalListIframe").src = "myGoalListIframe.jsp?cycle="+c+"&month="+m+"&season="+s;
	with(document.getElementById("tabPane")){
		for(var i=0;i<rows[0].cells.length-1;i++){
			rows[0].cells[i].className = "cycleTD";
		}
		if(<%=cycle%>=="1"){rows[0].cells[2].className="cycleTDCurrent";}else
		if(<%=cycle%>=="0"){rows[0].cells[3].className="cycleTDCurrent";}
	}
}

function setGoalYear(){
	var o = document.getElementById("currentYear");
	var y = o.options[o.selectedIndex].value;
	//location.href = "myGoalList.jsp?currentYear="+y+"&selectCycle=y&currentSeason="+o.getAttribute("season");
	document.getElementById("myGoalListIframe").src = "myGoalListIframe.jsp?cycle=3&year="+y;
	with(document.getElementById("tabPane")){
		for(var i=0;i<rows[0].cells.length-1;i++){
			rows[0].cells[i].className = "cycleTD";
		}
	}
	window.event.srcElement.parentElement.className = "cycleTDCurrent";
}
</script>

</body>
</html>