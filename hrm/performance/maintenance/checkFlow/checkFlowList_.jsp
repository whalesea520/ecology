<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.company.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

%>

<%
if(!HrmUserVarify.checkUserRight("CheckFlowInfo:Maintenance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String companyIcon = "/images/treeimages/global16.gif";
%>

<HTML>
<HEAD>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="xtree.css">
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
<script src="xtree.js"></script>
<script type="text/javascript">
var tree;
</script>
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
	<script language="javascript">
	if(document.getElementById){
		tree = new WebFXTree('<%=compInfo.getCompanyname("1")%>','','','<%=companyIcon%>','<%=companyIcon%>');
		tree.setBehavior('classic');
		<%=subCompInfo.getSubCompanyTreeJS("0",0)%>
		document.write(tree);
		tree.expand();
	}
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
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/FlowBrowser.jsp?para="+flowType);
	if(id==null) return false;
	var a = id.toArray();
	var arrayObj = obj.split("|");
	if(confirm("是否同步下级单位？")){
		location.href = "checkFlowOperation.jsp?syc=y&flowType="+flowType+"&flowId="+a[0]+"&objId="+arrayObj[0]+"&objType="+arrayObj[1];
	}else{
		location.href = "checkFlowOperation.jsp?syc=n&flowType="+flowType+"&flowId="+a[0]+"&objId="+arrayObj[0]+"&objType="+arrayObj[1];
	}
}
</script>