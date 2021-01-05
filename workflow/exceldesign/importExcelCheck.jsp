<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.workflow.exceldesign.TemplateOperation" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	FileUpload fu = new FileUpload(request, false, false, "filesystem/exceldesign/excelimp");
	int fileid = Util.getIntValue(fu.uploadFiles("filename"),-1);
	String sql = "select filerealpath,isaesencrypt,aescode from imagefile where imagefileid = "+fileid;
	rs.executeSql(sql);
	String excelFilePath= "";
	if(rs.next()){
		excelFilePath =  rs.getString("filerealpath");
	}
	Map<String,String> wfinfo = new HashMap<String,String>();
	String wfid = Util.null2String(fu.getParameter("wfid"));
	String nodeid = Util.null2String(fu.getParameter("nodeid"));
	String formid = Util.null2String(fu.getParameter("formid"));
	String isbill = Util.null2String(fu.getParameter("isbill"));
	String layouttype = Util.null2String(fu.getParameter("layouttype"));
	wfinfo.put("wfid",wfid);
	wfinfo.put("nodeid",nodeid);
	wfinfo.put("formid",formid);
	wfinfo.put("isbill",isbill);
	wfinfo.put("layouttype",layouttype);
	wfinfo.put("userid", String.valueOf(user.getUID()));
	wfinfo.put("language", String.valueOf(user.getLanguage()));
	
	TemplateOperation templateOperation = new TemplateOperation(excelFilePath, wfinfo);
	String check_result = templateOperation.checkTemplate();
	
	out.println("<script>var check_result = '"+check_result+"';</script>");
%>
<html>
<head>
<script>
	var dialog = parent.getDialog(window);
	jQuery(document).ready(function(){
		if(check_result==''){	//字段验证通过，直接submit到导入页面
			jQuery("#importing").css("display","");
			document.impExcelForm.submit();
		}else{
			var needclose = true;
			var url = "/workflow/form/addfieldbatch.jsp?formid="+jQuery("#formid").val()+"&dialog=1&isFromMode=0&fromwhere=excelimp";
			var dlg = new window.top.Dialog();
			dlg.currentWindow = window;
		    dlg.Title = '<%=SystemEnv.getHtmlLabelNames("20839,17998",user.getLanguage()) %>';
	     	dlg.Width = 1020;
		    dlg.Height = 580;
		    dlg.Modal = true;
			dlg.URL = url;
			dlg.callbackfun = function(paramobj, result){
				if(result == "nextImport"){
					needclose = false;
					jQuery("#importing").css("display","");
					document.impExcelForm.submit();
				}
			}
			dlg.closeHandle = function(){
				if(needclose)
					dialog.close();
			}
			dlg.show();
		}
	});
</script>
</head>
<body style="background-color:#efefef">
<form id="impExcelForm" name="impExcelForm" action="importExcelSubmit.jsp" method="post">
	<input type="hidden" id="excelFilePath" name="excelFilePath" value="<%=excelFilePath %>" />
	<input type="hidden" id="wfid" name="wfid" value="<%=wfid %>" />
	<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid %>" />
	<input type="hidden" id="formid" name="formid" value="<%=formid %>" />
	<input type="hidden" id="isbill" name="isbill" value="<%=isbill %>" />
	<input type="hidden" id="layouttype" name="layouttype" value="<%=layouttype %>" />
</form>
<div id="importing" style="text-align:center;color:#4a6379;line-height:23em;font-size:12pt;diaplay:none;">
	<%=SystemEnv.getHtmlLabelName(128059, user.getLanguage())%>
</div>
</body>
</html>