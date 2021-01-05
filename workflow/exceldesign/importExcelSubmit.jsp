<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.workflow.exceldesign.TemplateOperation" %>
<%
	String excelFilePath = Util.null2String(request.getParameter("excelFilePath"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String layouttype = Util.null2String(request.getParameter("layouttype"));
	
	Map<String,String> wfinfo = new HashMap<String,String>();
	wfinfo.put("wfid",wfid);
	wfinfo.put("nodeid",nodeid);
	wfinfo.put("formid",formid);
	wfinfo.put("isbill",isbill);
	wfinfo.put("layouttype",layouttype);
	wfinfo.put("userid", String.valueOf(user.getUID()));
	wfinfo.put("language", String.valueOf(user.getLanguage()));

	TemplateOperation templateOperation = new TemplateOperation(excelFilePath, wfinfo);
	int modeid = templateOperation.importTemplate();
	if(modeid>0){
		out.print("<script>jQuery(document).ready(function(){impSuccessRedirect();});</script>");
	}
%>
<script>
function impSuccessRedirect(){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	
	var editing_wfid = jQuery("#wfid",parentWin.parent.document).val();
	var editing_nodeid = jQuery("#nodeid",parentWin.parent.document).val();
	var editing_layouttype = jQuery("#layouttype",parentWin.parent.document).val();
	
	if(editing_wfid=="<%=wfid%>"&&editing_nodeid=="<%=nodeid%>"&&editing_layouttype=="<%=layouttype%>"){
		parentWin.parent.location = "/workflow/exceldesign/excelMain.jsp?wfid=<%=wfid%>&nodeid=<%=nodeid%>&formid=<%=formid%>&isbill=<%=isbill%>&modeid=<%=modeid%>&layouttype=<%=layouttype%>";
	}else{
		parentWin.location.reload();
	}
	dialog.close();
}
</script>
