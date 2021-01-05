
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

//是否分权系统
String docdetachable="0";
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
if(isUseDocManageDetach){
   docdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("docdetachable",docdetachable);
   session.setAttribute("docdftsubcomid",ManageDetachComInfo.getDocdftsubcomid());
}else{
   docdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("docdetachable",docdetachable);
   session.setAttribute("docdftsubcomid","0");

}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"managestruabbr_help.jsp";
//alert(contentUrl);
</script>
</HEAD>

<body scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%><span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
			<iframe src="StruAbbrTab.jsp?_fromURL=1" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>

	<script type="text/javascript">
		jQuery(document).ready(function(){
			e8_initTree("managestruabbr_left.jsp?rightStr=StruAbbr:Maintenance");
		});
	</script>
<!-- <TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
<IFRAME name=leftframe id=leftframe src="managestruabbr_left.jsp?rightStr=StruAbbr:Maintenance" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width="10px" style=’padding:0px’>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
<IFRAME name=contentframe id=contentframe src="managestruabbr_help.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>-->
 </body>

</html>