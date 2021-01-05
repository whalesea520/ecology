
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	String objid = Util.null2String(request.getParameter("id"));
	String buttonname = Util.null2String(request.getParameter("buttonname"));
	String titlename = SystemEnv.getHtmlLabelName(30091,user.getLanguage());//页面扩展设置
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customsearch a,modeTreeField b WHERE a.appid=b.id AND a.id="+objid;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	String userRightStr = "FORMMODEAPP:ALL";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
	
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//搜索
	RCMenuHeight += RCMenuHeightStep ;
	
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javaScript:doAdd(),_self} " ;//新建
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML>
	<HEAD>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
	</HEAD>
	<body>
<form name="frmSearch" method="post" action="/formmode/search/CustomSearchButton.jsp">
	<input type="hidden" id="id" name="id" value="<%=objid%>"/>
	<table class="e8_tblForm">
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
			<td class="e8_tblForm_field" width="80%">
				<input class="inputstyle" id="buttonname" name="buttonname" type="text" value="<%=buttonname%>" style="width:80%">
			</td>
		</tr>
	</table>
</form>
<br/>

<%
String SqlWhere = " where 1=1 ";
if(!buttonname.equals("")){
	SqlWhere += " and buttonname like '%"+buttonname+"%' ";
}
if(!objid.equals("")){
	SqlWhere += " and objid = '"+objid+"'";
}
String perpage = "10";
String backFields = "id,objid,buttonname,hreftype,isshow,showorder ";
String sqlFrom = "from mode_customSearchButton ";
String tableString=""+
	"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlorderby=\"showorder\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+ //名称                            
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"buttonname\" orderkey=\"buttonname\"  otherpara=\"column:id+column:objid+column:issystem+column:issystemflag+"+user.getLanguage()+"\" transmethod=\"weaver.formmode.service.CustomSearchButtService.getButtonNameNewUrl\"/>"+
					//链接目标方式
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(81967,user.getLanguage())+"\" column=\"hreftype\" orderkey=\"hreftype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.service.CustomSearchButtService.getHrefType\"/>"+
					//是否显示
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15603,user.getLanguage())+"\" column=\"isshow\" orderkey=\"isshow\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.service.CustomSearchButtService.getIsShow\"/>"+
					//显示顺序
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\"/>"+
			"</head>"+
	"</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doAdd(){
		enableAllmenu();
        location.href="/formmode/search/CustomSearchButtonAdd.jsp?objid=<%=objid%>";
    }
</script>

</BODY>
</HTML>
