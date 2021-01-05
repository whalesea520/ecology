<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.formmode.exceldesign.TemplateOperation" %>
<%
	String excelFilePath = Util.null2String(request.getParameter("excelFilePath"));
	String modeid = Util.null2String(request.getParameter("modeid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String layoutid = Util.null2String(request.getParameter("layoutid"));
	String layouttype = Util.null2String(request.getParameter("layouttype"));
	String isdefault = Util.null2String(request.getParameter("isdefault"));
	
	Map<String,String> wfinfo = new HashMap<String,String>();
	wfinfo.put("modeid",modeid);
	wfinfo.put("formid",formid);
	wfinfo.put("layoutid",layoutid);
	wfinfo.put("layouttype",layouttype);
	wfinfo.put("isdefault",isdefault);
	wfinfo.put("userid", String.valueOf(user.getUID()));
	wfinfo.put("language", String.valueOf(user.getLanguage()));

	TemplateOperation templateOperation = new TemplateOperation(excelFilePath, wfinfo);
	int layoutidnew = templateOperation.importTemplate();
	if(layoutidnew>0){
		out.print("<script>jQuery(document).ready(function(){impSuccessRedirect();});</script>");
	}
%>
<script>
function impSuccessRedirect(){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	
	var editing_layoutid = jQuery("#layoutid",parentWin.parent.document).val();
	
	if(editing_layoutid=="<%=layoutidnew%>"){
		parentWin.parent.location = "/formmode/exceldesign/excelMain.jsp?modeid=<%=modeid%>&formid=<%=formid%>&layoutid=<%=layoutidnew%>&layouttype=<%=layouttype%>&isdefault=<%=isdefault%>";
	}else{
		parentWin.location.reload();
	}
	dialog.close();
}
</script>
