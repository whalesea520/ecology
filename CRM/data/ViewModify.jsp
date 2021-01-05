
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String log=Util.null2String(request.getParameter("log"));

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0){
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log="+log+"&CustomerID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String orderby = "t1.modifydate ,t1.modifytime ";
String fromSql = "CRM_Modify t1";
String sqlWhere = " t1.customerid = "+CustomerID;
String backfields = "*";


String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_EditDetailLog+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_EditDetailLog,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlWhere+"\"  "+
	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.customerid\" sqlsortway=\"Desc\"/>"+
"<head>"+
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(63,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(345,user.getLanguage())+")" +"\" column=\"tabledesc\""+
	" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getViewModifyDesc\" otherpara=\"column:type+column:customerid\"/>"+
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(31644,user.getLanguage()) +"\" column=\"fieldname\"/>"+
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(19766,user.getLanguage()) +"\" column=\"original\" "+
	"otherpara=\"column:fieldname\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getModifyType\"/>"+
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelNames("365,563",user.getLanguage())+"\" column=\"modified\" "+
	"otherpara=\"column:fieldname\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getModifyType\"/>"+
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(723,user.getLanguage()) +"\" column=\"modifydate\"/>"+
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(97,user.getLanguage()) +"\" column=\"modifytime\"/>"+
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(424,user.getLanguage()) +"\" column=\"modifier\" "+
" otherpara=\"column:submitertype+"+user.getLogintype()+"\" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getSubmiterInfo\" />"+
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(33586,user.getLanguage()) +"\" column=\"clientip\"/>"+
"</head>"+   			
"</table>";
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=CustomerInfoComInfo.getCustomerInfoname(CustomerID) %>"/>
</jsp:include>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_EditDetailLog%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
</html>
