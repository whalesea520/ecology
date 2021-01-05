
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.file.*,javax.servlet.jsp.JspWriter" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	int isbill = Util.getIntValue(request.getParameter("isbill"), -1);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
	
	int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
	int isform = Util.getIntValue(request.getParameter("isform"), 0);
	String navname = SystemEnv.getHtmlLabelName(34243,user.getLanguage());//"模板导入"
	String groupname =SystemEnv.getHtmlLabelName(83308,user.getLanguage());//"模板文件导入";
	String nodetypesql = "select  b.workflowname,nb.nodename from workflow_nodebase nb,workflow_flownode fn,workflow_base b where b.id= fn.workflowid and nb.id = fn.nodeid and nb.id="+nodeid;
	RecordSet.executeSql(nodetypesql);
	if(RecordSet.first())
		navname += " ("+Util.null2String(RecordSet.getString("workflowname"))+"-"+Util.null2String(RecordSet.getString("nodename"))+")";
%>

<HTML><HEAD>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript">
		var dialog;
		var parentWin;
		
		jQuery(document).ready(function(){
			dialog = window.top.getDialog(window);
		});
		
		function importWef()
		{
			var filename = $("#filename").val();
			if(check_form(document.excelImportForm,"filename")){
				var pos = filename.length-4;
				if(filename.lastIndexOf(".wef")==pos){
					//jQuery("#type").attr("disabled",false);
					//jQuery("#loading").show();
					//jQuery("#content").hide();
					document.excelImportForm.submit();
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(127977,user.getLanguage()) %>");//选择文件格式不正确,请选择xml文件25644
					return;
				}
			}
		}
		
	</script>
</HEAD>
 	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<body style="overflow:hidden">
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value="<%=navname %>"/>
	</jsp:include>     	
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %>" onclick="importWef()" class="e8_btn_top" id="btnok1">
		      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
	<form id="excelImportForm" name="excelImportForm" enctype="multipart/form-data" action="/workflow/exceldesign/excelImportOperation.jsp" method="post">
	<input type="hidden" name="wfid" value="<%=wfid %>" />
	<input type="hidden" name="formid" value="<%=formid %>" />
	<wea:layout type="twoCol">
	    <wea:group context='<%=groupname %>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19971,user.getLanguage()) %></wea:item>
	    	<wea:item>
				<input class=InputStyle  type=file size=40 name="filename" id="filename" onChange="checkinpute8(this,'filenamespan')">
				<span id="filenamespan"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>     	
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage()) %>：</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(127978,user.getLanguage()) %></wea:item>
	    </wea:group>
	</wea:layout>
	</form>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>	
      <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
  </body>
   <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
