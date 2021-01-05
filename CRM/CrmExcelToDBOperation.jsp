
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmExcelToDB" class="weaver.crm.ExcelToDB.CrmExcelToDB" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
response.setHeader("cache-control", "no-cache"); 
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
if(null==user){
	return;
}

FileUpload fu = new FileUpload(request,false);
String operation = Util.null2String(request.getParameter("operation"));
String filepath="";
if("deleteFile".equals(operation)){
	filepath = Util.null2String(session.getAttribute("crmImportFilePath"));
	File file = new File(filepath);
	if(file.exists()){
		file.delete();
	}
	return;
}

FileManage fm = new FileManage();

String manager=fu.getParameter("manager");
if("".equals(manager)){
	manager = ""+user.getUID();
}

String department= ResourceComInfo.getDepartmentID(manager);
String subcompanyid1=DepartmentComInfo.getSubcompanyid1(department);
String CustomerStatus=fu.getParameter("CustomerStatus");


String isaesencrypt="";
String aescode="";
 
try {
	int fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
    String filename = UUID.randomUUID().toString()+".xls";
    String sql = "select  isaesencrypt,aescode,filerealpath from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    if(RecordSet.next()){
    	uploadfilepath =  RecordSet.getString("filerealpath");
    	isaesencrypt = RecordSet.getString("isaesencrypt");
        aescode = RecordSet.getString("aescode");
    }

 	if(!uploadfilepath.equals("")){
 		filepath = GCONST.getRootPath()+"Crm"+File.separatorChar+filename ;
        fm.copy(uploadfilepath,filepath,isaesencrypt,aescode);
    }

	CrmExcelToDB.resetInfo();
	CrmExcelToDB.setManager(manager);
	CrmExcelToDB.setCrmStatus(CustomerStatus);
	CrmExcelToDB.setDepartment(department);
	CrmExcelToDB.setSubcompanyid(subcompanyid1);
	CrmExcelToDB.setUser(user);
	
	CrmExcelToDB.ExcelToDB(filepath);   
	
	String sqlCity = "select id from crm_customerinfo where deleted = '0' and city = '0' and country != '0' and province != '0' ";
	   RecordSet.executeSql(sqlCity);
	   while(RecordSet.next()){
	       String upsql = "update CRM_CustomerInfo set country = '0',province = '0' where id = "+RecordSet.getString("id");
	       RecordSet.execute(upsql);
	   }
	if(CrmExcelToDB.isNUllData()){
		response.sendRedirect("CrmExcelToDB.jsp?isNUllData=true");
		fm.DeleteFile(filepath);
		return;
	}
	if(CrmExcelToDB.isErrTemplate()){
		response.sendRedirect("CrmExcelToDB.jsp?isErrTemplate=true");
		fm.DeleteFile(filepath);
		return;
	}
	
	if(CrmExcelToDB.isErreData()){
		session.setAttribute("crmImportFilePath", filepath);
		session.setAttribute("crmImportFileId", fileid);
		response.sendRedirect("CrmExcelToDB.jsp?isErreData=true");
		return;
	}
	
	if(!CrmExcelToDB.isSaveSuccess()){
		response.sendRedirect("CrmExcelToDB.jsp?success=false");
		fm.DeleteFile(filepath);
		return;
	}
	response.sendRedirect("CrmExcelToDB.jsp?success=true");
}catch(Exception e) {
	e.printStackTrace();
}



%>
