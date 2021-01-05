
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>
<%@page import="weaver.join.hrm.in.IHrmImportAdapt"%>
<%@page import="weaver.join.hrm.in.HrmResourceVo"%>
<%@page import="weaver.join.hrm.in.IHrmImportProcess"%>
<%@page import="weaver.join.hrm.in.processImpl.HrmImportProcess"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.matrix.MatrixImportProcess"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	//if (!HrmUserVarify.checkUserRight("Matrix:Maint",
	//		user)) {
	//	response.sendRedirect("/notice/noright.jsp");
	//	return;
	//}

%>
<%
 /*综合考虑多数据源后，实现通过配置文件配置适配器和解析类*/
  StaticObj staticObj=StaticObj.getInstance();  

  MatrixImportProcess importAdapt= new MatrixImportProcess();
  
  FileUploadToPath fu = new FileUploadToPath(request) ; 
  
  String issystem = fu.getParameter("issystem");
  String matrixid = fu.getParameter("matrixid");
  List errorInfo=importAdapt.creatImportMap(fu);  
  
  //如果读取数据和验证模板没有发生错误
  if(errorInfo.isEmpty()){
	  List resultInfo = importAdapt.processMap();
	  
	  staticObj.putObject("matrixImportStatus","over");
	  int issystemValue = Util.getIntValue(issystem,-1);
	  if(issystemValue != -1){
		  MatrixUtil.sysMatrixDataToSubOrDep(matrixid,issystemValue);
	  }
  }else{
	  staticObj.putObject("matrixImportStatus","error");
	  staticObj.putObject("matrix_errorInfo",errorInfo);
  }
%>


