
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmExcelToDBNew" class="weaver.crm.ExcelToDB.CrmExcelToDBNew" scope="page" />
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
//客户经理
String managerId = Util.null2String(fu.getParameter("managerId"));
if("".equals(managerId)){
	managerId = user.getUID()+"";
}
//客户状态
String crmStatus = Util.null2String(fu.getParameter("CustomerStatus"));
if("".equals(crmStatus)){
	crmStatus = "1";
}
//客户级别
String rating = Util.null2String(fu.getParameter("rating"));
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
        Excelfilepath = GCONST.getRootPath()+"crm/ExcelToDB"+File.separatorChar+filename ;
		//System.out.println("Excelfilepath＝"+Excelfilepath);
        fm.copy(uploadfilepath,Excelfilepath);
    }
	String msg="";
	String msg2="";
	
	int importCount = 200;
	RecordSet.executeSql("select importCount from CRM_BatchOperateSetting");
	if(RecordSet.next()){
		importCount = RecordSet.getInt(1);
	}
	CrmExcelToDBNew.setMaxNum(importCount);
	CrmExcelToDBNew.setUserId(userId);
	CrmExcelToDBNew.setUserLanguage(Integer.parseInt(userLanguage));
	CrmExcelToDBNew.setManagerId(managerId);
	CrmExcelToDBNew.setCrmStatus(crmStatus);
	CrmExcelToDBNew.setCrmRating(rating);
	boolean result = CrmExcelToDBNew.ExcelToDB(Excelfilepath);
	if(result){
		msg += "客户导入完成!<br>";
		
		int total = CrmExcelToDBNew.getTotal();
		int success = CrmExcelToDBNew.getSuccess();
		int fail = CrmExcelToDBNew.getFail();
		
		msg += "总计："+total+"个; 成功："+success+"个; 失败："+fail+"个;";
		String errormsg = CrmExcelToDBNew.getErrormsg().toString();
		request.getSession().setAttribute("CRM_IMPORT_INFO",msg+"<br><br>"+errormsg);
	}else{
		msg2 += "操作失败！每次导入记录条数不能大于"+importCount+"。";
	}
	
	response.sendRedirect("CustomerImport.jsp?msg="+URLEncoder.encode(msg)+"&msg2="+URLEncoder.encode(msg2));
}
catch(Exception e) {

}
%>
