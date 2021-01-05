
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>
<%@page import="weaver.join.hrm.in.IHrmImportAdapt"%>
<%@page import="weaver.join.hrm.in.HrmResourceVo"%>
<%@page import="weaver.join.hrm.in.IHrmImportProcess"%>
<%@page import="weaver.join.hrm.in.processImpl.HrmImportProcess"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",
			user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

%>
<%
 /*综合考虑多数据源后，实现通过配置文件配置适配器和解析类*/

  IHrmImportAdapt importAdapt=(IHrmImportAdapt)Class.forName("weaver.join.hrm.in.adaptImpl.HrmImportAdaptExcel").newInstance();
  
  FileUploadToPath fu = new FileUploadToPath(request) ; 
  
  //重复性字段，数据库中有相同的则会update
  String keyField=fu.getParameter("keyField");
  
  //将重复性验证字段放入缓存，在HrmImportLog.jsp中获取，用于判断关键字段列
  session.setAttribute("keyField",keyField);
  
  //导入类型  添加|更新
  String importType=fu.getParameter("importType");
  
  List errorInfo=importAdapt.creatImportMap(fu);  
  
  
  //如果读取数据和验证模板没有发生错误
  if(errorInfo.isEmpty()){
	  Map hrMap=importAdapt.getHrmImportMap();
	
	  IHrmImportProcess importProcess=(IHrmImportProcess)Class.forName("weaver.join.hrm.in.processImpl.HrmImportProcess").newInstance();
	  
	  importProcess.processMap(keyField,hrMap,importType,session); 
	  
	  session.setAttribute("importStatus","over");
	//同步部门数据到矩阵
	  MatrixUtil.sysDepartmentData();
	  //同步分部数据到矩阵
      MatrixUtil.sysSubcompayData();
  }else{
  	session.setAttribute("importStatus","error");
  	session.setAttribute("errorInfo",errorInfo);
  }
%>


