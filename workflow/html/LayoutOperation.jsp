
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%
FileUpload fu = new FileUpload(request, false, false, "filesystem/htmllayoutimages");
int wfid = Util.getIntValue(fu.getParameter("wfid"), 0);//
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
//把权限判断放到最上面，不影响下面的初始化对象、参数
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%@ page import="weaver.file.FileUpload,java.io.File"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="htmlLayoutManager" class="weaver.workflow.html.HtmlLayoutManager" scope="page"/>
<%
int flag = 0;
int formid = Util.getIntValue(fu.getParameter("formid"), 0);//
int nodeid = Util.getIntValue(fu.getParameter("nodeid"), 0);//
int modeid = Util.getIntValue(fu.getParameter("modeid"), 0);//
int isbill = Util.getIntValue(fu.getParameter("isbill"), -1);//
int layouttype = Util.getIntValue(fu.getParameter("layouttype"), -1);
int isform = Util.getIntValue(fu.getParameter("isform"), -1);
String curmodetype=Util.null2String(fu.getParameter("curmodetype"));
htmlLayoutManager.setFu(fu);
htmlLayoutManager.setUser(user);
String operation = Util.null2String(fu.getParameter("operation"));
if("save".equalsIgnoreCase(operation)){
	modeid = htmlLayoutManager.doSaveLayoutInfo();
}else if("preppm".equalsIgnoreCase(operation)){
	modeid = htmlLayoutManager.doPrepPrintMode();
}
if(modeid > 0){
	flag = 1;
}


//response.sendRedirect("/workflow/html/LayoutEditFrame.jsp?wfid="+wfid+"&formid="+formid+"&nodeid="+nodeid+"&modeid="+modeid+"&isbill="+isbill+"&layouttype="+layouttype+"&isform="+isform+"&flag="+flag);
//return;
%>
<script language="javascript">
try{
	//var url = window.opener.location.href;
	//window.opener.location.reload();
	window.opener.nodefieldedit("<%=nodeid%>");
}catch(e){}
location.href = "/workflow/html/LayoutEditFrame.jsp?wfid=<%=wfid%>&formid=<%=formid%>&nodeid=<%=nodeid%>&modeid=<%=modeid%>&isbill=<%=isbill%>&layouttype=<%=layouttype%>&isform=<%=isform%>&flag=<%=flag%>&curmodetype=<%=curmodetype %>";
</script>