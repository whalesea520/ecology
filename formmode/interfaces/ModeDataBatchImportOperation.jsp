
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@page import="weaver.formmode.excel.ImpExcelServer"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeDataBatchImport" class="weaver.formmode.interfaces.ModeDataBatchImport" scope="page"/>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<%
out.clear();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
    FileUploadToPath fu = new FileUploadToPath(request);
	String clientaddress = request.getRemoteAddr();
	int modeid = Util.getIntValue(fu.getParameter("modeid"),0);
	int pageexpandid = Util.getIntValue(fu.getParameter("pageexpandid"));
	String method = Util.null2String(fu.getParameter("method"));
	int sourcetype = Util.getIntValue(fu.getParameter("sourcetype"),0);
	String flag = "";
	if ("import".equals(method)) {
		int type = 4;//批量导入权限
		if(type == 4){//监控权限判断
			ModeRightInfo.setModeId(modeid);
			ModeRightInfo.setType(type);
			ModeRightInfo.setUser(user);
			boolean isRight = false;
			isRight = ModeRightInfo.checkUserRight(type);
			if(!isRight){
				if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
					response.sendRedirect("/notice/noright.jsp");
					return;
				}
			}
		}
		ImpExcelServer impExcelServer = new ImpExcelServer();
		impExcelServer.setClientaddress(clientaddress);
		impExcelServer.setUser(user);
		
		ModeDataBatchImport.setClientaddress(clientaddress);
		ModeDataBatchImport.setUser(user);
		
		int isnew = Util.getIntValue(fu.getParameter("isnew"),0);
		String msg = "";
		if(isnew==1){
		    msg=impExcelServer.ImportData(fu,user,request);
		}else{
		    msg=ModeDataBatchImport.ImportData(fu,user);
		    flag = System.currentTimeMillis() + "_DataBatchImport";
		    session.setAttribute(flag,msg);
		    response.sendRedirect("/formmode/interfaces/ModeDataBatchImport.jsp?modeid="+modeid+"&flag="+flag+"&pageexpandid="+pageexpandid+"&sourcetype="+sourcetype);
		    return;
		}
	} else if ("save".equals(method)) {
		String interfacePath = Util.null2String(fu.getParameter("interfacePath"));
		String formId = Util.null2String(fu.getParameter("formId"));
		int importorder = Util.getIntValue(fu.getParameter("importorder"),0);
		String isUse = Util.null2String(fu.getParameter("isUse"));
		String validateid = Util.null2String(fu.getParameter("importValidationId"));
		rs.executeSql("delete mode_DataBatchImport where modeid="+modeid);
		rs.executeSql("insert into mode_DataBatchImport(modeid,interfacepath,isuse,validateid,importorder) values("+modeid+",'"+interfacePath+"','"+isUse+"','"+validateid+"',"+importorder+")");
		String url = "/formmode/interfaces/ModeDataBatchImport.jsp?modeid="+modeid+"&sourcetype="+sourcetype;
		out.println("<script>window.parent.location.href ='"+url+"'+'&t='+new Date().getTime();</script>");
		return;
	}
%>