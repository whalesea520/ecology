<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.formmode.exceldesign.TemplateOperation" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
FileUpload fu = new FileUpload(request, false, false, "filesystem/htmllayoutimages/dd");
int fileid = Util.getIntValue(fu.uploadFiles("filename"),-1);
String sql = "select filerealpath,isaesencrypt,aescode from imagefile where imagefileid = "+fileid;
rs.executeSql(sql);
String excelFilePath= "";
if(rs.next()){
	excelFilePath =  rs.getString("filerealpath");
}

String wfid="",nodeid="",formid="",isbill="",layouttype="";
int modeid = -1;
if(excelFilePath!=""){
	Map<String,String> wfinfo = new HashMap<String,String>();
	wfid = Util.null2String(fu.getParameter("wfid"));
	nodeid = Util.null2String(fu.getParameter("nodeid"));
	formid = Util.null2String(fu.getParameter("formid"));
	isbill = Util.null2String(fu.getParameter("isbill"));
	layouttype = Util.null2String(fu.getParameter("layouttype"));
	wfinfo.put("wfid",wfid);
	wfinfo.put("nodeid",nodeid);
	wfinfo.put("formid",formid);
	wfinfo.put("isbill",isbill);
	wfinfo.put("layouttype",layouttype);
	wfinfo.put("userid", String.valueOf(user.getUID()));
	wfinfo.put("language", String.valueOf(user.getLanguage()));
	
	Map<String,Object> checkmap = new HashMap<String,Object>();
	if("".equals(Util.null2String(checkmap.get("error")))){
		TemplateOperation templateOperation = new TemplateOperation();
		modeid = templateOperation.importTemplate(excelFilePath,wfinfo);
		if(modeid>0){
			out.print("<script>jQuery(document).ready(function(){impSuccessRedirect();});</script>");
		}
	}
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
		parentWin.parent.location = "/formmode/exceldesign/excelMain.jsp?wfid=<%=wfid%>&nodeid=<%=nodeid%>&formid=<%=formid%>&isbill=<%=isbill%>&modeid=<%=modeid%>&layouttype=<%=layouttype%>";
	}else{
		parentWin.location.reload();
	}
	dialog.close();
}
</script>
<html>
<body>
<input type="hidden" id="excelFilePath" value="<%=excelFilePath %>" />
</body>
</html>