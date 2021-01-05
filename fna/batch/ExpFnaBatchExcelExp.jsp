<%@page import="weaver.file.ExcelFile"%>
<%@page import="weaver.fna.interfaces.thread.ExpFnaBatchExcelExpThread"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*" %>

<%@page import="weaver.fna.general.FnaLanguage"%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}

	boolean effect = HrmUserVarify.checkUserRight("BudgetDraftBatchEffect:effect", user);//预算草稿批量生效
	boolean imp = HrmUserVarify.checkUserRight("BudgetDraftBatchImport:imp", user);//预算草稿批量导入
	if(!effect && !imp){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
	int gotoDl = Util.getIntValue(request.getParameter("gotoDl"));
	if(gotoDl != 1){
		String budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), -1)+"";//预算年度ID
		int expType = Util.getIntValue(request.getParameter("expType"));//导出预算版本
		boolean dlData = 1==Util.getIntValue(request.getParameter("dlType"));//是否下载模板包含数据
	
		boolean zb = "1".equals(Util.null2String(request.getSession().getAttribute("ExpFnaBatchExcel1.jsp_zb:"+_guid1)).trim());//总部
		String fb = Util.null2String(request.getSession().getAttribute("ExpFnaBatchExcel1.jsp_fb:"+_guid1)).trim();//分部ID
		String bm = Util.null2String(request.getSession().getAttribute("ExpFnaBatchExcel1.jsp_bm:"+_guid1)).trim();//部门ID
		String ry = Util.null2String(request.getSession().getAttribute("ExpFnaBatchExcel1.jsp_ry:"+_guid1)).trim();//人员ID
		String fccIds = Util.null2String(request.getSession().getAttribute("ExpFnaBatchExcel1.jsp_fccIds:"+_guid1)).trim();//成本中心ID
		String subjectIds = Util.null2String(request.getSession().getAttribute("ExpFnaBatchExcel1.jsp_subjectId:"+_guid1)).trim();//科目ID
		int keyWord = Util.getIntValue((String)request.getSession().getAttribute("ExpFnaBatchExcel1.jsp_keyWord:"+_guid1));//承担主体重复验证字段
		int keyWord2 = Util.getIntValue((String)request.getSession().getAttribute("ExpFnaBatchExcel1.jsp_keyWord2:"+_guid1));//科目重复验证字段
		
		ExpFnaBatchExcelExpThread expFnaBatchExcelExpThread = new ExpFnaBatchExcelExpThread();
	
		expFnaBatchExcelExpThread.setGuid(_guid1);
		expFnaBatchExcelExpThread.setBudgetperiods(budgetperiods);
		expFnaBatchExcelExpThread.setExpType(expType);
		expFnaBatchExcelExpThread.setDlData(dlData);
	
		expFnaBatchExcelExpThread.setZb(zb);
		expFnaBatchExcelExpThread.setFb(fb);
		expFnaBatchExcelExpThread.setBm(bm);
		expFnaBatchExcelExpThread.setRy(ry);
		expFnaBatchExcelExpThread.setFccIds(fccIds);
		expFnaBatchExcelExpThread.setSubjectIds(subjectIds);
		expFnaBatchExcelExpThread.setKeyWord(keyWord);
		expFnaBatchExcelExpThread.setKeyWord2(keyWord2);
		
		expFnaBatchExcelExpThread.setUser(user);
		
		expFnaBatchExcelExpThread.setIsprint(false);
	
	
	    Thread thread_1 = new Thread(expFnaBatchExcelExpThread);
	    thread_1.start();
	}else{
		ExcelFile excelFile = (ExcelFile)session.getAttribute("FnaLoadingAjax_"+_guid1+"_excelFile");
		session.setAttribute("ExcelFile", excelFile);
		session.removeAttribute("FnaLoadingAjax_"+_guid1+"_excelFile");
%>
		<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
		<script type="text/javascript">
		var iframe_ExcelOut = document.getElementById("ExcelOut");
		iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
		</script>
<%
	}
%>