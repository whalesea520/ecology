<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ page import="weaver.hrm.schedule.HrmPaidSickImport"%>
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
String PSLyear = Util.null2String(fu.getParameter("PSLyear"));
String leavetype = Util.null2String(fu.getParameter("leavetype"));
String sql="";

if(operation.equals("import")){
	if(!HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){
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
    if(RecordSet.next()){
      uploadfilepath =  RecordSet.getString("filerealpath");
      isaesencrypt =  RecordSet.getString("isaesencrypt");
      aescode =  RecordSet.getString("aescode");
    } 
    if(!uploadfilepath.equals("")){
      Excelfilepath = GCONST.getRootPath()+"hrm/ExcelToDB"+File.separatorChar+filename;
      fm.copy(uploadfilepath,Excelfilepath,isaesencrypt,aescode);
  	}
    
    HrmPaidSickImport hrmPaidSickImport = new HrmPaidSickImport();
    if(hrmPaidSickImport.initCheck(Excelfilepath)){
	    hrmPaidSickImport.setIsaesencrypt(isaesencrypt);
	    hrmPaidSickImport.setAescode(aescode);
	    hrmPaidSickImport.ScanFile(Excelfilepath);
	    if(hrmPaidSickImport.getMsg1().size()==0){
	       hrmPaidSickImport.ExcelToDB(Excelfilepath,subcompanyid,departmentid,PSLyear,leavetype);
	       msg="sucess";
	       response.sendRedirect("PaidSickLeaveImport.jsp?msg="+msg+"&PSLyear="+PSLyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&leavetype="+leavetype);
	       return;
	    }else{
	       for (int i = 0; i <hrmPaidSickImport.getMsg1().size();i++){
	         msg1=msg1+(String)hrmPaidSickImport.getMsg1().elementAt(i)+",";
	         msg2=msg2+(String)hrmPaidSickImport.getMsg2().elementAt(i)+",";
	       }
	       response.sendRedirect("PaidSickLeaveImport.jsp?msg="+msg+"&msg1="+msg1+"&msg2="+msg2+"&PSLyear="+PSLyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&leavetype="+leavetype);
	       return;
	    }
    }else{
		response.sendRedirect("PaidSickLeaveImport.jsp?msg=formatError&PSLyear="+PSLyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);
		return;
    }
   }catch(Exception e){
 
   }  
      
   response.sendRedirect("PaidSickLeaveImport.jsp?PSLyear="+PSLyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);
   return;
}


%>