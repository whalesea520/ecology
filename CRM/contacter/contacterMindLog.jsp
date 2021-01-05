
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.common.util.string.StringUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage()) + SystemEnv.getHtmlLabelName(216,user.getLanguage());
String customerId=Util.null2String(request.getParameter("customerId"));
String contacterId=Util.null2String(request.getParameter("contacterId"));
String operate_type=Util.null2String(request.getParameter("operate_type"));
String operate_date=Util.null2String(request.getParameter("operate_date"));
String contacterName=Util.null2String(request.getParameter("contacterName"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));
String sqlwhere="";
if(!fromdate.equals("")){
 	sqlwhere+=" and t1.begindate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and t1.begindate<='"+enddate+"'";
}
if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t1.begindate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t1.begindate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
String titleName = SystemEnv.getHtmlLabelName(32061,user.getLanguage());
%>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=titleName%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td class="rightSearchSpan" style="text-align:right;">
		</td>
	</tr>
</table>
<%
	String operate_usr = "isnull(h.lastname,'系统管理员')";
	String dbType = RecordSet.getDBType();
	if("oracle".equals(dbType)){
		operate_usr = "nvl(h.lastname,'系统管理员')";
	}
    String tableString = "";
	String backfields = "contacterid,"+operate_usr+"  as operate_usr,operate_date,operate_time,case operate_type when '0' then '新增' when '1' then '修改' when '2' then '删除' when '3' then '关系图变更'  else '其他' end as operate_type, operate_value ";
	String fromSql  = " crm_customercontacter_mind_log l "+
					  " left join hrmresource h on l.operate_usr = h.id ";
	String sqlWhere = " l.customerid = "+customerId;
	String orderby = " operate_date desc,operate_time desc";
	tableString = " <table pageId=\"CRM_MIND:ModifyLog\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ModifyLog,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+
				  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"l.customerid\" sqlsortway=\"Desc\"/>"+
	              " <head>"+
	              "	<col width='10%' text-align='center' text='"+SystemEnv.getHtmlLabelName(572,user.getLanguage())+"' column=\"contacterid\" orderkey=\"contacterid\"  otherpara='column:submittime' transmethod=\"weaver.crm.Maint.CRMTransMethod.getDateTime\"/>"+
	              "	<col width='10%' text-align='center' text='"+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"' column=\"operate_type\" orderkey=\"operate_type\"  otherpara='column:submittime' transmethod=\"weaver.crm.Maint.CRMTransMethod.getDateTime\"/>"+
	              "	<col width='40%' text-align='center' text='"+SystemEnv.getHtmlLabelName(104,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())+"' column=\"operate_value\" orderkey=\"operate_type\"  otherpara='column:submitertype+"+user.getLogintype()+"' transmethod=\"\"/>"+
	              "	<col width='15%' text-align='center' text='"+SystemEnv.getHtmlLabelName(21663,user.getLanguage())+"' column=\"operate_date\" orderkey=\"operate_date\" otherpara='"+customerId+"+"+user.getLanguage()+"+column:submittime+column:submitdate+column:logcontent' transmethod=\"\"/>"+
	              "	<col width='15%' text-align='center' text='"+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"' column=\"operate_time\" orderkey=\"operate_time\" otherpara='"+customerId+"+"+user.getLanguage()+"+column:submittime+column:submitdate+column:logcontent' transmethod=\"\"/>"+
	              "	<col width='10%' text-align='center' text='"+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"' column=\"operate_usr\" orderkey=\"operate_usr\" otherpara='"+customerId+"+"+user.getLanguage()+"+column:submittime+column:submitdate+column:operate_usr' transmethod=\"\"/>"+
	 			  "	</head></table>";
  %>
<input type="hidden" name="pageId" id="pageId" value="CRM_MIND:ModifyLog"> 
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
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

<script type="text/javascript">
</script>
</body>
</HTML>
