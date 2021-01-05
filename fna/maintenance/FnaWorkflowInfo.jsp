<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	</head>
<%	
String startDate = Util.null2String(request.getParameter("startDate")) ; 
String endDate = Util.null2String(request.getParameter("endDate")) ;

String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = ""; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(131140,user.getLanguage()) %>"/>
</jsp:include>
		
<%
String backfields = " wr.requestid,wr.requestname,wb.workflowname,wb.id,wn.nodename,wr.creater,wr.creatertype, ";
if("oracle".equals(recordSet.getDBType())){
	backfields += " wr.createdate||' '||wr.createtime createDateTime ";
}else if("mysql".equals(recordSet.getDBType())){
	backfields += " concat_ws(' ',wr.createdate,wr.createtime) createDateTime ";
}else{
	backfields += " wr.createdate+' '+wr.createtime createDateTime ";
}
String fromSql = " from fnaexpenseinfo fe ";
fromSql += " left join workflow_requestbase wr on fe.requestid = wr.requestid ";
fromSql += " join workflow_base wb on wb.id = wr.workflowid ";
fromSql += " join workflow_nodebase wn on wr.currentnodeid = wn.id ";
String sqlWhere = " where fe.occurdate >= '" + startDate + "'";
sqlWhere += " and fe.occurdate <= '" + endDate + "'";
sqlWhere += " and fe.status = 0 ";
String orderby = "wr.createdate";
String tableString = ""; 
String para4 = user.getLanguage() + "+" + user.getUID() + "+" + user.getUID();

tableString = " <table instanceid=\"FnaWorkflowInfoListTable\" tabletype=\"none\"   pagesize=\"" + "10" + "\" >" + 
			"	   <sql backfields=\"" + Util.toHtmlForSplitPage(backfields) + "\" sqlform=\"" + Util.toHtmlForSplitPage(fromSql) + "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) + "\" "+
			" sqlorderby=\""	+ Util.toHtmlForSplitPage(orderby) + "\"  sqlprimarykey=\"requestname\" sqlsortway=\"desc\" />" + 
			"		<head>" + 
			"			<col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(28610, user.getLanguage()) + "\" column=\"requestid\" />"+	
			"			<col width=\"25%\"  text=\"" + SystemEnv.getHtmlLabelName(26876, user.getLanguage()) + "\" column=\"requestname\" "+
			" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"openWorkflow+column:requestid+column:id\" />" + 
			"			<col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage()) + "\" column=\"creater\" "+
			" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" otherpara=\"column:creatertype\" />" + 
			"			<col width=\"20%\"  text=\"" + SystemEnv.getHtmlLabelName(1339, user.getLanguage()) + "\" column=\"createDateTime\" />"+
			"			<col width=\"15%\"  text=\"" + SystemEnv.getHtmlLabelName(125749, user.getLanguage()) + "\" column=\"workflowname\" />" +
			"			<col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(18564, user.getLanguage()) + "\" column=\"nodename\" />" +
			"			<col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\" " +
			" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\" otherpara=\"" + para4 + "\" />" + 
			"		</head>" + 
			" </table>";
			
%>
<wea:SplitPageTag tableString='<%=tableString%>' mode="run"  />
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();">
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#e8_navtab").css("color","red");
		jQuery("#e8_navtab").css("line-height","60px");
	    jQuery("#header").load("/systeminfo/commonTabHead.jsp");  //重新加载包含的jsp页面
	});  


	function openWorkflow(requestid,workflowid){
		window.open("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&_workflowid="+workflowid+"&_workflowtype=&isovertime=0");
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);	
		//dialog.close();
		dialog.closeByHand();
	}
	
	function showallreceived(requestid,returntdid){
        var _data ="requestid="+requestid+"&returntdid="+returntdid;
        jQuery.ajax({
            url : "/workflow/search/WorkflowUnoperatorPersons.jsp",
            type : "post",
            processData : false,
            data : _data, 
            dataType : "text",
            success: function do4Success(msg){ 
            	jQuery("#"+returntdid).html(msg);
            }
        });
        
    }
	
</script>

</BODY>
</HTML>


