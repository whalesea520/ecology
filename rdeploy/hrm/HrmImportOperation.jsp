<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUploadToPath"%>
<%@ page import="weaver.rdeploy.hrm.HrmResourceVo"%>
<%@ page import="weaver.general.StaticObj"%>
<%@page import="weaver.rdeploy.hrm.HrmImportProcessRd"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
StaticObj staticObj=StaticObj.getInstance();  
FileUploadToPath fu = new FileUploadToPath(request) ; 
String cmd = Util.null2String(fu.getParameter("cmd"));
if(cmd.equals("savefile")){
	String fileName = fu.uploadFiles1("excelfile");
	//存储fileName
	boolean hasRecord = false;
	String sql = " select count(*) from HrmImportFieldSetting where resourceid ="+user.getUID();
	rs.executeSql(sql);
	if(rs.next()){
		if(rs.getInt(1)>0){
			hasRecord = true;
		}
	}
	if(hasRecord){
		sql = " update HrmImportFieldSetting set filename='"+fileName+"' where resourceid = "+user.getUID();
		rs.executeSql(sql);
	}else{
		sql = " insert into HrmImportFieldSetting (resourceid,filename) "
				+ " values("+user.getUID()+",'"+fileName+"') ";
		rs.executeSql(sql);
	}
	response.sendRedirect("HrmImportFile.jsp?result=1");
	return;
}else if(cmd.equals("save")){
	String lastname = Util.null2String(fu.getParameter("lastname"));
	String sex = Util.null2String(fu.getParameter("sex"));
	String telephone = Util.null2String(fu.getParameter("telephone"));
	String mobile = Util.null2String(fu.getParameter("mobile"));
	String email = Util.null2String(fu.getParameter("email"));
	String firstrow = Util.null2String(fu.getParameter("firstrow"));
	String sql = " update HrmImportFieldSetting set lastname='"+lastname+"', sex='"+sex+"'," 
						 + " telephone='"+telephone+"',mobile='"+mobile+"',email='"+email+"',firstrow="+firstrow
						 + " where resourceid = "+user.getUID();
	rs.executeSql(sql);
	HrmImportProcessRd  HrmImportProcessRd = new HrmImportProcessRd();
	Map<Integer,String> errorInfo = HrmImportProcessRd.readExcel(user);
	List<HrmResourceVo> lsHrmResource = HrmImportProcessRd.getLsHrmResource();
	staticObj.putObject("lsHrmResource",lsHrmResource);
  staticObj.putObject("errorInfo",errorInfo);
	response.sendRedirect("HrmImportFieldSetting.jsp?result=1");
	return;
}else if(cmd.equals("import")){
	HrmImportProcessRd  HrmImportProcessRd = new HrmImportProcessRd();
	int resultCount = HrmImportProcessRd.creatImportMap(user);
	List<HrmResourceVo> lsHrmResource = HrmImportProcessRd.getLsHrmResource();
	int sumRecord = lsHrmResource.size();
	response.sendRedirect("HrmImportOK.jsp?result=1&sumRecord="+sumRecord+"&successRecord="+resultCount);
	return;
}
%>