
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css">
	 <script type="text/javascript" src="/js/xtree_wev8.js"></script>
	 <script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
    <script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(341,user.getLanguage());
String needfav ="1";
String needhelp ="";
//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
String docdetachable="0";
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
if(isUseDocManageDetach){
   docdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("docdetachable",docdetachable);
   String hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"DocMouldAdd:Add",-1);
   session.setAttribute("docdftsubcomid",hasRightSub);
}else{
   docdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("docdetachable",docdetachable);
   session.setAttribute("docdftsubcomid","0");

}
//如果未开启人力资源模块管理分权则直接跳转到角色页面(不显示左边的树)
if("0".equals(docdetachable)){
    response.sendRedirect("/docs/mould/DocMouldTab.jsp?_fromURL=2");
    return;
}
%>
<BODY scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
				<span><%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %></span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
			<iframe src="/docs/mould/DocMouldTab.jsp?_fromURL=2" id="outcontentframe" name="outcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td class="flowMenusTd" style="width:226px;">
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
			e8_initTree("/docs/category/subcompany_left.jsp?rightStr=DocSecCategoryMould:all&url=/docs/mould/DocMouldTab.jsp?_fromURL=2");
		});
	</script>
</body>
</html>

<%--
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MainCategoryManager" class="weaver.docs.category.MainCategoryManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("DocMainCategoryAdd:add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onNew(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocMainCategory:log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where int(operateitem) =1")+"',_top} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where operateitem =1")+"',_top} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="20%">
  <COL width="60%">
  <COL width="20%">
  <TBODY>
  <TR class=header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
    </TR>
<TR class=Line><TD colSpan=4></TD></TR>
  <%
  MainCategoryManager.resetParameter();
  MainCategoryManager.selectCategoryInfo();
  int i=0;
  while(MainCategoryManager.next()){
  	int id = MainCategoryManager.getCategoryid();
  	String name = MainCategoryManager.getCategoryname();
  	String imageid = Util.null2String(MainCategoryManager.getCategoryiamgeid());
  	int order = MainCategoryManager.getCategoryorder();
  	
  	if(i==0){
  		i=1;
  %>  
  <TR class=datalight>
  <%
  	}else{
  		i=0;
  %>
  <TR class=datadark>
  <%  	}
  %>
    <TD><a href="DocMainCategoryEdit.jsp?id=<%=id%>"><%=id%></a></TD>
    <TD><%=name%></TD>
    <TD><%=order%></TD></TR>
   <%}
   MainCategoryManager.closeStatement();%>
    </TBODY></TABLE>
    <script>
    function onNew(){
    		location="DocMainCategoryAdd.jsp"
    }    	
    </script>    

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

    </BODY></HTML>
--%>