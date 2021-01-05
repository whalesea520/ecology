
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("30688",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->dataBrowser.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
</HEAD>
<%
String titlename = SystemEnv.getHtmlLabelName(30688,user.getLanguage());
String selectedids_old =  Util.null2String(request.getParameter("selectedids"));
String selectedids = "";
String[] str = selectedids_old.split(",");
for(int i = 0; i < str.length; i++) {
	if(i == 0) {
		selectedids = str[i];
	} else {
		selectedids = selectedids + "," + str[i];
	}
	
}
%>
<BODY>
<div>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="blog"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33539,user.getLanguage()) %>"/>  
	</jsp:include>
    <DIV align=right>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String typename = Util.null2String(request.getParameter("typename"));
String eid = Util.null2String(request.getParameter("eid"));

String namesimple = Util.null2String(request.getParameter("namesimple"));

String showclass = Util.null2String(request.getParameter("showclass"));
String showtype = Util.null2String(request.getParameter("showtype"));

String tableString=""+
					   "<table  datasource=\"weaver.page.element.compatible.PageMore.getOutDataMore\" sourceparams=\"eid:"+eid+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_TRIGGERTABLEBROWSER,user.getUID())+"\" tabletype=\"none\">"+
					   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   "<head>"+							 
							 "<col width=\"0%\"  text=\"\" column=\"col1\"/>"+
							 "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(33523,user.getLanguage())+"\" column=\"col2\"/>"+
							 "<col width=\"50%\"  column=\"col3\" text=\""+SystemEnv.getHtmlLabelName(33522,user.getLanguage())+"\"/>"+
					   "</head>"+
					   "</table>";

%>
    </DIV>
    <form>
    	<TABLE width="100%">
		    <tr>
		        <td valign="top">  
		           	<wea:SplitPageTag  tableString='<%=tableString%>' selectedstrs="<%=selectedids%>" mode="run" />
		        </td>
		    </tr>
		</TABLE>
    </form>
</div>

</BODY>
</HTML>
<script type="text/javascript">

</SCRIPT>
