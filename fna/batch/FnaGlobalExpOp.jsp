
<%@page import="com.weaver.formmodel.util.FileHelper"%><%@ page language="java" contentType="application/x-download" %>
<%@page import="java.io.IOException"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.BufferedInputStream"%><%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.io.File"%>
<%@page import="weaver.fna.general.FnaGlobalExpImp"%>
<%@page import="weaver.fna.general.FnaLanguage"%><%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.fna.budget.FnaBudgetBatchObj"%><%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%><%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%><%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%><%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%><%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%><%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%><%@page import="java.io.FileInputStream"%><%@page import="weaver.file.FileManage"%><%@page import="weaver.file.FileUpload"%><%@page import="java.lang.Exception"%><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.fna.budget.FnaBudgetUtil"%><%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%><%@page import="weaver.fna.budget.BudgetHandler"%><%@page import="weaver.fna.maintenance.FnaBudgetControl"%><%@page import="weaver.hrm.company.CompanyComInfo"%><%@page import="weaver.hrm.company.SubCompanyComInfo"%><%@page import="weaver.hrm.company.DepartmentComInfo"%><%@page import="weaver.hrm.resource.ResourceComInfo"%><%@page import="weaver.conn.RecordSet"%><%@page import="org.apache.commons.lang.StringEscapeUtils"%><%@page import="java.text.DecimalFormat"%><%@ page import="weaver.fna.maintenance.FnaBudgetInfo" %><%@page import="java.text.SimpleDateFormat"%><%@page import="weaver.general.BaseBean"%><%@page import="weaver.general.TimeUtil"%><%@page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@ page import="weaver.general.GCONST" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%>
<%
BaseBean bb = new BaseBean();
String result = "";

User user = HrmUserVarify.getUser (request , response) ;

boolean imp = HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user);
if(!imp){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operation = Util.null2String(request.getParameter("operation")).trim();
String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
int expSubject = Util.getIntValue(request.getParameter("expSubject"), 0);
int expFcc = Util.getIntValue(request.getParameter("expFcc"), 0);
String wfIds = Util.null2String(request.getParameter("wfIds")).trim();
if("".equals(operation)){
	FileUpload fu = new FileUpload(request,false);
	operation = Util.null2String(fu.getParameter("operation")).trim();
	_guid1 = Util.null2String(fu.getParameter("_guid1")).trim();
	expSubject = Util.getIntValue(fu.getParameter("expSubject"), 0);
	expFcc = Util.getIntValue(fu.getParameter("expFcc"), 0);
	wfIds = Util.null2String(fu.getParameter("wfIds")).trim();
}

request.getSession().removeAttribute("index:"+_guid1);
request.getSession().removeAttribute("isDone:"+_guid1);

request.getSession().setAttribute("index:"+_guid1, SystemEnv.getHtmlLabelName(128093,user.getLanguage()));
request.getSession().setAttribute("isDone:"+_guid1, "");


String primaryKeyGuid1 = FnaCommon.getPrimaryKeyGuid1();

String fnaBatch_filepath0 = GCONST.getRootPath()+
	"fna"+File.separatorChar+
	"batch"+File.separatorChar;

String fnaBatch_filepath1 = fnaBatch_filepath0+
	user.getUID()+File.separatorChar;

String fnaBatch_filepath = fnaBatch_filepath1+
	primaryKeyGuid1+File.separatorChar;	

String zipFileName = fnaBatch_filepath0+"fnaExp_"+user.getUID()+"_"+primaryKeyGuid1+".zip";

if("export".equals(operation)){
	
	FnaGlobalExpImp.fnaGlobalExp(fnaBatch_filepath, zipFileName, expSubject, expFcc, wfIds, user.getUID(), user.getLanguage(), _guid1, request);
	
	String downLoadZipFileName_encode=new String(("fnaExp.zip").getBytes("iso-8859-1"),"UTF-8");

	//request.setCharacterEncoding("UTF-8");
	response.setHeader("Content-disposition","attachment; filename="+downLoadZipFileName_encode);

	BufferedInputStream bis = null;
	BufferedOutputStream bos = null;
	try {
		FileInputStream fis = new FileInputStream(zipFileName);
	    bis = new BufferedInputStream(fis);
	    bos = new BufferedOutputStream(response.getOutputStream());

	    byte[] buff = new byte[2048];
	    int bytesRead;

	    while(-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
	        bos.write(buff,0,bytesRead);
	    }

	} finally {
	    try{if(bis != null){bis.close();}}catch(Exception ex){}
	    try{if(bos != null){bos.close();}}catch(Exception ex){}
	    
	    try{FileHelper.recursiveRemoveDir(new File(fnaBatch_filepath1));}catch(Exception ex){}
	    try{FileHelper.deleteFile(zipFileName);}catch(Exception ex){}

		request.getSession().setAttribute("errorInfo:"+_guid1, result);
		request.getSession().setAttribute("isDone:"+_guid1, "true");
	}
	
}else if("doInitExp".equals(operation) && user.getUID()==1 && false){
	
	FnaGlobalExpImp.doInitExp(fnaBatch_filepath, zipFileName, user.getUID(), user.getLanguage());
	
	String downLoadZipFileName_encode=new String(("fnaExp.zip").getBytes("iso-8859-1"),"UTF-8");

	//request.setCharacterEncoding("UTF-8");
	response.setHeader("Content-disposition","attachment; filename="+downLoadZipFileName_encode);

	BufferedInputStream bis = null;
	BufferedOutputStream bos = null;
	try {
		FileInputStream fis = new FileInputStream(zipFileName);
	    bis = new BufferedInputStream(fis);
	    bos = new BufferedOutputStream(response.getOutputStream());

	    byte[] buff = new byte[2048];
	    int bytesRead;

	    while(-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
	        bos.write(buff,0,bytesRead);
	    }

	} finally {
	    try{if(bis != null){bis.close();}}catch(Exception ex){}
	    try{if(bos != null){bos.close();}}catch(Exception ex){}
	    
	    try{FileHelper.recursiveRemoveDir(new File(fnaBatch_filepath1));}catch(Exception ex){}
	    try{FileHelper.deleteFile(zipFileName);}catch(Exception ex){}

		request.getSession().setAttribute("errorInfo:"+_guid1, result);
		request.getSession().setAttribute("isDone:"+_guid1, "true");
	}
	
}else{
	result = SystemEnv.getHtmlLabelName(34115,user.getLanguage())+";operation="+operation;
}
request.getSession().setAttribute("errorInfo:"+_guid1, result);
request.getSession().setAttribute("isDone:"+_guid1, "true");



































%>