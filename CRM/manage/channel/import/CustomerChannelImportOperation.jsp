
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLDecoder.*"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.*"%>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<jsp:useBean id="ExcelParse" class="weaver.file.ExcelParse" scope="page" />
<jsp:useBean id="FileManage" class="weaver.file.FileManage" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerChannelImport" class="weaver.crm.channel.CustomerChannelImport" scope="page" />

<%
response.setHeader("cache-control", "no-cache"); 
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
FileUpload fu = new FileUpload(request,false);
FileManage fm = new FileManage();
String userId = Util.null2String(fu.getParameter("userId"));
String userLanguage = Util.null2String(fu.getParameter("userLanguage"));
String managerId = Util.null2String(fu.getParameter("managerId"));
if("".equals(managerId)){
	managerId = user.getUID()+"";
}

String Excelfilepath="";
 
int fileid = 0 ;

try {
    fileid = Util.getIntValue(fu.uploadFiles("filename"),0);

    String filename = fu.getFileName();

    String sql = "select filerealpath from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    if(RecordSet.next()) uploadfilepath =  RecordSet.getString("filerealpath");

 	if(!uploadfilepath.equals("")){
        Excelfilepath = GCONST.getRootPath()+"crm/channel/file"+File.separatorChar+filename ;
		//System.out.println("Excelfilepath＝"+Excelfilepath);
        fm.copy(uploadfilepath,Excelfilepath);
    }

	String msg="";
	
	String type = Util.null2o(fu.getParameter("type"));
	
	CustomerChannelImport.setUserId(userId);
	CustomerChannelImport.setUserLanguage(Integer.parseInt(userLanguage));
	CustomerChannelImport.setManagerId(managerId);
	CustomerChannelImport.ExcelToDB(Excelfilepath);
	msg += "渠道客户记录导入完成!<br>";
	
	int total = CustomerChannelImport.getTotal();
	int success = CustomerChannelImport.getSuccess();
	int fail = CustomerChannelImport.getFail();
	
	msg += "总计："+total+"个; 成功："+success+"个; 失败："+fail+"个;";
	String errormsg = CustomerChannelImport.getErrormsg().toString();
	request.getSession().setAttribute("CRM_IMPORT_ERROR",msg+"<br><br>"+errormsg);
	
	response.sendRedirect("CustomerChannelImport.jsp?msg="+URLEncoder.encode(msg)+"&type="+type);
}
catch(Exception e) {

}
%>
