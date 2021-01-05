<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="hrmComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18070,user.getLanguage())+"";
String needfav ="1";
String needhelp ="";    

if(!HrmUserVarify.checkUserRight("ModifyPoint:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int userid=0;
userid=user.getUID();

String sql = "";
int minPoint = 0;
int maxPoint = 0;
//取得评分规则中的分数范围--------------------------------------------------------------------
sql = "SELECT * FROM HrmPerformancePointRule";
rs.executeSql(sql);
if(rs.next()){
	minPoint = rs.getInt("minPoint");
	maxPoint = rs.getInt("maxPoint");
}
//----------------------------------------------------------------------------


int checkPointId = Util.getIntValue(request.getParameter("id"));

String point5 = "";
String point6 = "";
int objId = 0;
String checkType ="";
String cycle = "";
String checkDate = "";

sql = "SELECT * FROM HrmPerformanceCheckPoint WHERE id="+checkPointId+"";
//out.println(sql);
rs.executeSql(sql);
if(rs.next()){
	objId = rs.getInt("objId");
	checkType = rs.getString("checkType");
	cycle = rs.getString("cycle");
	checkDate = rs.getString("checkDate");
	point5 = rs.getString("point5");
	point6 = rs.getString("point6");
}
HashMap orgIdName = GoalUtil.getOrgIdName(Util.getIntValue(checkType),objId);
StringBuffer reportName = new StringBuffer("");
reportName.append(orgIdName.get("objOrgName"));
if(cycle.equals("0")||cycle.equals("3")){
	reportName.append(checkDate.substring(0,4));
}else{
	reportName.append(checkDate.substring(0,4));
	reportName.append(SystemEnv.getHtmlLabelName(445,user.getLanguage()));
	reportName.append(checkDate.substring(4));
}

reportName.append(SystemEnv.getHtmlLabelName(GoalUtil.getCycleLabelIdByKey2(Util.getIntValue(cycle)),user.getLanguage()));
reportName.append(SystemEnv.getHtmlLabelName(351,user.getLanguage()));

sql = "SELECT * FROM HrmPerformancePointAdjust WHERE pointId="+checkPointId+" ORDER BY id DESC";
rs.executeSql(sql);
%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver.js"></script>
</head>
  
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="modifyPointOperation.jsp" >
<input type="hidden" id="checkPointId" name="checkPointId" value="<%=checkPointId%>">
<input type="hidden" id="point_before" name="point_before" value="<%=point6%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td></td>
	<td valign="top">
		<table class="Shadow">
		<tr>
			<td valign="top">
<!--=================================-->
<TABLE class=ViewForm id="formTable">
<COLGROUP>
<COL width="20%">
<COL width="80%">
</COLGROUP>
<TBODY>
<TR class=Title>
	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18070,user.getLanguage())%> - <%=reportName%></TH>
</TR>
<TR class=Spacing>
	<TD class=Line1 colSpan=2></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18248,user.getLanguage())%></td>
	<td class=Field><%=Util.getPointValue(point5,1,point5)%></td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18249,user.getLanguage())%></td>
	<td class=Field><%=Util.getPointValue(point6,1,point6)%></td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18250,user.getLanguage())%></td>
	<td class=Field>
	<INPUT class=InputStyle maxLength=50 style="width:90%" name="modifiedPoint" onchange="checkinput('modifiedPoint','modifiedPointImage');" onkeypress='ItemCount_KeyPress()' onblur="checkPoint(this)">
	<SPAN id=modifiedPointImage><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
	<td valign="top"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
	<td class=Field><textarea class="inputstyle" name="content"	style="width:90%;height:50px"></textarea></td>
</tr>
</table>

<TABLE width="100%" id="oTable" class=ListStyle cellspacing=1>
<thead>
<TR>
	<td colspan="3">
		<table style="width:100%;border-collapse:collapse;" cellpadding="0">
		<tr>
			<Td style="font-weight:bold;vertical-align:bottom"><%=SystemEnv.getHtmlLabelName(18251,user.getLanguage())%></Td>
			<Td align=right></Td>
		</tr>
		</table>
	</td>
</TR>
<TR><TD style="height:2px;background-color:#A1A1A1" colSpan=5></TD></TR>
</thead>

<tbody>
<tr class=Header style="height:22px">
	<td width="100"><%=SystemEnv.getHtmlLabelName(18252,user.getLanguage())%></td>
	<td width="100"><%=SystemEnv.getHtmlLabelName(18253,user.getLanguage())%></td>
	<td width="120"><%=SystemEnv.getHtmlLabelName(15820,user.getLanguage())%></td>
	<td width="100"><%=SystemEnv.getHtmlLabelName(15823,user.getLanguage())%></td>
	<td width="*"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
</tr>
<TR class=Line><TD colspan="5"></TD></TR>
<%while(rs.next()){%>
<tr>
	<td><%=rs.getDouble("point_before")%></td>
	<td><%=rs.getDouble("point_after")%></td>
	<td><%=rs.getString("adjustDate")%></td>
	<td><%=hrmComInfo.getResourcename(String.valueOf(rs.getInt("adjustPerson")))%></td>
	<td><%=rs.getString("content")%></td>
</tr>
<%}%>
</tbody>
</table>
<!--=================================-->
			</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</form>
</body>
</html>

<script type="text/javascript">
function checkSubmit(){
	if(check_form(frmMain,'modifiedPoint')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
}

function checkPoint(o){
	if(o.value<<%=minPoint%> || o.value><%=maxPoint%>){
		alert("<%=SystemEnv.getHtmlLabelName(18261,user.getLanguage())%>(<%=minPoint%>-<%=maxPoint%>)");
		o.value = "";
		document.getElementById("modifiedPointImage").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		o.focus();
		return false;
	}
}
</script>