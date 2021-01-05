<%@page import="weaver.fna.interfaces.thread.FnaInvoiceLedgerBatchImpThread"%>
<%@page import="weaver.fna.e9.exception.FnaException"%>
<%@page import="weaver.fna.e9.controller.base.FnaInvoiceLedgerController"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
BaseBean bb = new BaseBean();
try{
	User user = HrmUserVarify.getUser(request, response);
	if(user==null){
		throw new Exception(SystemEnv.getHtmlLabelName(125220, user.getLanguage()));//请重新登录
	}
	boolean canEdit = HrmUserVarify.checkUserRight("FnaInvoiceLedger:settings",user);
	if (!canEdit) {
		throw new Exception(SystemEnv.getHtmlLabelName(2012, user.getLanguage()));//对不起，您暂时没有权限
	}

	FileUpload fu = null;
	String actionName = Util.null2String(request.getParameter("actionName"));
	if("".equals(actionName)){
		fu = new FileUpload(request,false);
		actionName = Util.null2String(fu.getParameter("actionName"));
	}
	if("doActionSave".equals(actionName)){//新建记录
		FnaInvoiceLedgerController.getInstance().insertOrUpdateData(request, response, out, user);
	}else if("btnBatchDelete".equals(actionName)){//批量删除
		FnaInvoiceLedgerController.getInstance().batchDeleteData(request, response, out, user);
	}else if("doImp".equals(actionName)){//导入
		String operation = Util.null2String(fu.getParameter("operation")).trim();
		String _guid1 = Util.null2String(fu.getParameter("_guid1")).trim();
		int impType = Util.getIntValue(fu.getParameter("impType"), -1);

		int fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
		String uploadFileName = fu.getFileName();
		String excelfile_path = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")));
		
		FnaInvoiceLedgerBatchImpThread fnaThread = new FnaInvoiceLedgerBatchImpThread();
		fnaThread.setIsprint(false);
		fnaThread.setUser(user);
		fnaThread.setGuid(_guid1);
		
		fnaThread.setOperation(operation);
		fnaThread.setImpType(impType);
		fnaThread.setFileid(fileid);
		fnaThread.setUploadFileName(uploadFileName);
		fnaThread.setExcelfile_path(excelfile_path);
		
		Thread thread_1 = new Thread(fnaThread);
		thread_1.start();
	}else{
		throw new Exception(SystemEnv.getHtmlLabelName(83677, user.getLanguage()));//没有权限!
	}
}catch(Exception ex1){
	if(!(ex1 instanceof FnaException)){
		bb.writeLog(ex1);
	}
	JSONObject jsonObject = new JSONObject();
	jsonObject.element("flag", false);
	jsonObject.element("msg", ex1.getMessage());
	out.print(jsonObject.toString());
	response.flushBuffer();
}
%>