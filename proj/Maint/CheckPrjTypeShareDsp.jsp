<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
}

if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>

<%

String parentid = Util.fromScreen(request.getParameter("paraid"),user.getLanguage());
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
boolean canedit = HrmUserVarify.checkUserRight("EditProjectType:Edit",user);

%>


<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";

%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=form2 name=form2 action="/proj/Maint/PrjTypeShareDsp.jsp" >
<input type="hidden" name="assortid" value="<%=parentid %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
</div>	

<%

String sqlWhere = " where relateditemid="+parentid;

if(!"".equals(nameQuery)){
	//sqlWhere+=" and sharetype like '%"+nameQuery+"%'";
}


String orderby =" id ";
String tableString = "";
int perpage=6;                                 
String backfields = " id,relateditemid,sharetype,seclevel,rolelevel,sharelevel,userid,departmentid,roleid,foralluser,crmid,subcompanyid ";
String fromSql  = " Prj_T_ShareInfo ";

tableString =   " <table instanceid=\"CptCapitalAssortmentTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTypeShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("21956",user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.proj.util.ProjectTransUtil.getShareTypeName'  />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("106",user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\""+"{'languageid':"+user.getLanguage()+",'sharetablename':'Prj_T_ShareInfo'}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getShareObjectName' />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("683",user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\" />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("3005",user.getLanguage())+"\" column=\"sharelevel\" orderkey=\"sharelevel\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.proj.util.ProjectTransUtil.getShareLevelName' />"+
                "       </head>"+
                " </table>";
%>

<!-- listinfo -->
<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />

<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %>
</BODY>
</HTML>
