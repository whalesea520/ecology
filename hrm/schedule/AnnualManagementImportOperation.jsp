<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualImport"%>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<%
FileUpload fu = new FileUpload(request,false);
FileManage fm = new FileManage();
String operation = Util.null2String(fu.getParameter("operation"));
String subcompanyid = Util.null2String(fu.getParameter("subCompanyId"));
String departmentid = Util.null2String(fu.getParameter("departmentid"));
String annualyear = Util.null2String(fu.getParameter("annualyear"));
String sql="";

if(operation.equals("import")){
   if(!HrmUserVarify.checkUserRight("AnnualLeave:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   
   int fileid = 0 ;   
   String msg="";
   String msg1="";
   String msg2="";
   String Excelfilepath="";
   
   try {      
    fileid = Util.getIntValue(fu.uploadFiles("excelfile"),0);     
    String filename = fu.getFileName();
    sql = "select filerealpath,isaesencrypt,aescode from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    String isaesencrypt="";
    String aescode="";
    if(RecordSet.next()) {
      uploadfilepath =  RecordSet.getString("filerealpath");
      isaesencrypt =  RecordSet.getString("isaesencrypt");
      aescode =  RecordSet.getString("aescode");
    }
    if(!uploadfilepath.equals("")){
      Excelfilepath = GCONST.getRootPath()+"hrm/ExcelToDB"+File.separatorChar+filename;
      fm.copy(uploadfilepath,Excelfilepath,isaesencrypt,aescode);
  	}
    HrmAnnualImport HrmAnnualImport = new HrmAnnualImport();
    if(HrmAnnualImport.initCheck(Excelfilepath)){
	    HrmAnnualImport.setIsaesencrypt(isaesencrypt);
	    HrmAnnualImport.setAescode(aescode);
	    HrmAnnualImport.ScanFile(Excelfilepath);
	    if(HrmAnnualImport.getMsg1().size()==0){
	       HrmAnnualImport.ExcelToDB(Excelfilepath,subcompanyid,departmentid,annualyear);
	       msg="sucess";
	       response.sendRedirect("AnnualManagementImport.jsp?msg="+msg+"&annualyear="+annualyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);
	    }else{
	       for (int i = 0; i <HrmAnnualImport.getMsg1().size();i++){
	         msg1=msg1+(String)HrmAnnualImport.getMsg1().elementAt(i)+",";
	         msg2=msg2+(String)HrmAnnualImport.getMsg2().elementAt(i)+",";
	       }
	       response.sendRedirect("AnnualManagementImport.jsp?msg="+msg+"&msg1="+msg1+"&msg2="+msg2+"&annualyear="+annualyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);    
	    }
    }else{
		response.sendRedirect("AnnualManagementImport.jsp?msg=formatError&annualyear="+annualyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);
    }
   }catch(Exception e){
 
   }  
      
   response.sendRedirect("AnnualManagementImport.jsp?annualyear="+annualyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);
}


%>