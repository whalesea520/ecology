
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.general.FnaGlobalExpImp"%>
<%@page import="weaver.fna.general.FnaLanguage"%><%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.fna.budget.FnaBudgetBatchObj"%><%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%><%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%><%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%><%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%><%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%><%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%><%@page import="java.io.FileInputStream"%><%@page import="weaver.file.FileManage"%><%@page import="weaver.file.FileUpload"%><%@page import="java.lang.Exception"%><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.fna.budget.FnaBudgetUtil"%><%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%><%@page import="weaver.fna.budget.BudgetHandler"%><%@page import="weaver.fna.maintenance.FnaBudgetControl"%><%@page import="weaver.hrm.company.CompanyComInfo"%><%@page import="weaver.hrm.company.SubCompanyComInfo"%><%@page import="weaver.hrm.company.DepartmentComInfo"%><%@page import="weaver.hrm.resource.ResourceComInfo"%><%@page import="weaver.conn.RecordSet"%><%@page import="org.apache.commons.lang.StringEscapeUtils"%><%@page import="java.text.DecimalFormat"%><%@ page import="weaver.fna.maintenance.FnaBudgetInfo" %><%@page import="java.text.SimpleDateFormat"%><%@page import="weaver.general.BaseBean"%><%@page import="weaver.general.TimeUtil"%><%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@ page import="weaver.general.GCONST" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%>
<%
BaseBean bb = new BaseBean();
String result = "";

User user = HrmUserVarify.getUser (request , response) ;

boolean imp = HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user);//预算草稿批量导入
if(!imp){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

RecordSet rs = new RecordSet();

ResourceComInfo resourceComInfo = new ResourceComInfo();
DepartmentComInfo departmentComInfo = new DepartmentComInfo();
SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
CompanyComInfo companyComInfo = new CompanyComInfo();
BudgetfeeTypeComInfo btc = new BudgetfeeTypeComInfo();

String timestrformart = "yyyyMMddHHmmss" ;
SimpleDateFormat SDF = new SimpleDateFormat(timestrformart) ;
Calendar calendar = Calendar.getInstance() ;

String dateTime = SDF.format(calendar.getTime());

int _index = 0;
DecimalFormat df = new DecimalFormat("################################################0.00");

FileUpload fu = new FileUpload(request,false);
String operation = Util.null2String(fu.getParameter("operation")).trim();
String _guid1 = Util.null2String(fu.getParameter("_guid1")).trim();

request.getSession().removeAttribute("index:"+_guid1);
request.getSession().removeAttribute("isDone:"+_guid1);

request.getSession().setAttribute("index:"+_guid1, SystemEnv.getHtmlLabelName(34116,user.getLanguage()));//开始预备数据 
request.getSession().setAttribute("isDone:"+_guid1, "");

if("import".equals(operation)){
    char separator = Util.getSeparator();
    List<String> errStrList = new ArrayList<String>();
   	String errStr = "";

	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	int currentMM = today.get(Calendar.MONTH) + 1;
   	
	RecordSet rs1 = new RecordSet();
	RecordSet rs2 = new RecordSet();
	RecordSet rs3 = new RecordSet();

	String Excelfilepath = "";
	int fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
	String filename = fileid+"_"+FnaCommon.getPrimaryKeyGuid1()+".xls";
   	try{
   		String sql = "select filerealpath, isaesencrypt, aescode from imagefile where imagefileid = "+fileid;
   		rs.executeSql(sql);
   		String uploadfilepath="";
   		String isaesencrypt = "";
   		String aescode = "";
   		if(rs.next()){
   			uploadfilepath = rs.getString("filerealpath");
   			isaesencrypt = Util.null2String(rs.getString("isaesencrypt"));
   			aescode = Util.null2String(rs.getString("aescode"));
   		}

		String upZipExcelfilepath = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")))+"\\";
   		if(!uploadfilepath.equals("")) {
   			Excelfilepath = upZipExcelfilepath+filename ;
   			//FileManage.copy(uploadfilepath,Excelfilepath);
   			FileManage.copy(uploadfilepath, Excelfilepath, isaesencrypt, aescode);
   		}

		int impRowCnt = 0;
		if(fileid>0 && filename!=null && !"".equals(filename) && Excelfilepath!=null && !"".equals(Excelfilepath)){
			//upZipExcelfilepath = "I:\\upload\\";
			FnaGlobalExpImp.fnaGlobalImp(Excelfilepath, upZipExcelfilepath, user.getUID(), user.getLanguage(), _guid1, request);
			
		}else{
			String _str1 = SystemEnv.getHtmlLabelName(34117,user.getLanguage());//导入文件上传失败
			if(!errStrList.contains(_str1)){
				errStrList.add(_str1);
				errStr += _str1;
			}
		}
   	}catch(Exception ex1){
   		bb.writeLog(ex1);
		String _str1 = SystemEnv.getHtmlLabelName(34118,user.getLanguage())+":\r"+ex1.getMessage()+"\r";//解析导入文件出错
		if(!errStrList.contains(_str1)){
			errStrList.add(_str1);
			errStr += _str1;
		}
   	}finally{
   		try{
   			if(fileid>0 && filename!=null && !"".equals(filename) && Excelfilepath!=null && !"".equals(Excelfilepath)){
   				FileManage.DeleteFile(Excelfilepath);
   			}
   		}catch(Exception e){}
   	}
   	
   	if("".equals(errStr)){
   		result = "";//导入成功
   	}else{
   		result = errStr;
   	}
   	
   	
}else if("doInitImp".equals(operation) && user.getUID()==1 && false){
    char separator = Util.getSeparator();
    List<String> errStrList = new ArrayList<String>();
   	String errStr = "";

	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	int currentMM = today.get(Calendar.MONTH) + 1;
   	
	RecordSet rs1 = new RecordSet();
	RecordSet rs2 = new RecordSet();
	RecordSet rs3 = new RecordSet();

	String Excelfilepath = "";
	int fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
	String filename = fileid+"_"+FnaCommon.getPrimaryKeyGuid1()+".xls";
   	try{
   		String sql = "select filerealpath, isaesencrypt, aescode from imagefile where imagefileid = "+fileid;
   		rs.executeSql(sql);
   		String uploadfilepath="";
   		String isaesencrypt = "";
   		String aescode = "";
   		if(rs.next()){
   			uploadfilepath = rs.getString("filerealpath");
   			isaesencrypt = Util.null2String(rs.getString("isaesencrypt"));
   			aescode = Util.null2String(rs.getString("aescode"));
   		}

		String upZipExcelfilepath = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")))+"\\";
   		if(!uploadfilepath.equals("")) {
   			Excelfilepath = upZipExcelfilepath+filename ;
   			//FileManage.copy(uploadfilepath,Excelfilepath);
   			FileManage.copy(uploadfilepath, Excelfilepath, isaesencrypt, aescode);
   		}

		int impRowCnt = 0;
		if(fileid>0 && filename!=null && !"".equals(filename) && Excelfilepath!=null && !"".equals(Excelfilepath)){
			upZipExcelfilepath = "I:\\upload\\";
			FnaGlobalExpImp.doInitImp(Excelfilepath, upZipExcelfilepath, user.getUID(), user.getLanguage());
			
		}else{
			String _str1 = SystemEnv.getHtmlLabelName(34117,user.getLanguage());//导入文件上传失败
			if(!errStrList.contains(_str1)){
				errStrList.add(_str1);
				errStr += _str1;
			}
		}
   	}catch(Exception ex1){
   		bb.writeLog(ex1);
		String _str1 = SystemEnv.getHtmlLabelName(34118,user.getLanguage())+":\r"+ex1.getMessage()+"\r";//解析导入文件出错
		if(!errStrList.contains(_str1)){
			errStrList.add(_str1);
			errStr += _str1;
		}
   	}finally{
   		try{
   			if(fileid>0 && filename!=null && !"".equals(filename) && Excelfilepath!=null && !"".equals(Excelfilepath)){
   				FileManage.DeleteFile(Excelfilepath);
   			}
   		}catch(Exception e){}
   	}
   	
   	if("".equals(errStr)){
   		result = "";//导入成功
   	}else{
   		result = errStr;
   	}
   	
   	
}else{
	result = SystemEnv.getHtmlLabelName(34115,user.getLanguage());//请正确提交数据
}
request.getSession().setAttribute("errorInfo:"+_guid1, result);
request.getSession().setAttribute("isDone:"+_guid1, "true");






































%><%=result %>