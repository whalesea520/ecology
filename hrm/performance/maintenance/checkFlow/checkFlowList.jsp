<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.company.*" %>
<%@ page import="weaver.hrm.performance.goal.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdHRM.gif";
//TD3935
//modified by hubo,2006-03-16
String titlename = SystemEnv.getHtmlLabelName(18043,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
%>

<%
if(!HrmUserVarify.checkUserRight("CheckFlowInfo:Maintenance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String companyIcon = "/images/treeimages/global16.gif";
String flowName = GoalUtil.getCheckFlow(0,"0");
%>

<HTML>
<HEAD>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css">
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree.css">
<style>
TABLE.Shadow A {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:hover {
	COLOR: #333; TEXT-DECORATION: none
}

TABLE.Shadow A:link {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:visited {
	TEXT-DECORATION: none
}
</style>
<script type="text/javascript" src="/js/xloadtree/xtree4performance.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4performance.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class="Shadow">
<tr>
<td valign="top">		
<!--=================================-->
<TABLE class=ListStyle cellspacing=1>
<TR class=Header>
	<TH width="50%"><%=SystemEnv.getHtmlLabelName(17871,user.getLanguage())%></TH>
	<th width="25%"><%=SystemEnv.getHtmlLabelName(18102,user.getLanguage())%></th>
	<th width="25%"><%=SystemEnv.getHtmlLabelName(18103,user.getLanguage())%></th>
</TR>
<TR class=Line>
	<TD colSpan=3></TD>
</TR>
<tr>
	<td colspan="3" id="treeTD">
	<script type="text/javascript">
	webFXTreeConfig.blankIcon		= "/images/xp2/blank.png";
	webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
	webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
	webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
	webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
	webFXTreeConfig.iIcon			= "/images/xp2/I.png";
	webFXTreeConfig.lIcon			= "/images/xp2/L.png";
	webFXTreeConfig.tIcon			= "/images/xp2/T.png";

	var rti;
	var tree = new WebFXTree('<%=compInfo.getCompanyname("1")%>','0|0|<%=flowName%>','','<%=companyIcon%>','<%=companyIcon%>');
	<%out.println(subCompInfo.getSubCompanyTreeJSByComp());%>
	document.write(tree);
	//rti.expand();
	</script>
	</td>
</tr>
</table>
<!--=================================-->
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

</body>
</html>


<script type="text/javascript">
function onShowFlowID(flowType,obj){
	if(flowType=="0"){
		var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put("where isbill=1 and formid=146")%>");
	}else if(flowType=="1"){
		var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put("where isbill=1 and formid=145")%>");
	}
	if(datas==null) return false;
	var arrayObj = obj.split("|");
	if(arrayObj[1]=="3"){
		location.href = "checkFlowOperation.jsp?syc=y&flowType="+flowType+"&flowId="+datas.id+"&objId="+arrayObj[0]+"&objType="+arrayObj[1];
	}else{
		if(confirm("<%=SystemEnv.getHtmlLabelName(18260,user.getLanguage())%>?")){
			location.href = "checkFlowOperation.jsp?syc=y&flowType="+flowType+"&flowId="+datas.id+"&objId="+arrayObj[0]+"&objType="+arrayObj[1];
		}else{
			location.href = "checkFlowOperation.jsp?syc=n&flowType="+flowType+"&flowId="+datas.id+"&objId="+arrayObj[0]+"&objType="+arrayObj[1];
		}
	}
}
</script>