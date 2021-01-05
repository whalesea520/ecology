<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.lang.reflect.Method"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("eAssistant:fixedInst", user)) {
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	//check 方式
	List<String> checkedList=new ArrayList<String>();
	checkedList.add("ALLOWSUBMITFAQ");
	checkedList.add("ALLOWAUTOSUBMITFAQ");
	checkedList.add("recordInstruction");
	checkedList.add("EnableWorkbench");
	// input 方式
	List<String> inputList=new ArrayList<String>();
	inputList.add("recordInstructionUrl");
	inputList.add("WorkbenchWaitTimeout");
	inputList.add("WorkbenchProcessTimeout");
	inputList.add("FullEMaskTime");
	inputList.add("FullEMaskTips");
	inputList.add("EStyle");
	
	String key="";
	for(int i=0;i<checkedList.size();i++){
		key=checkedList.get(i);
		RecordSet.execute("update FullSearch_EAssistantSet set sValue  ='" + Util.null2String(request.getParameter(key),"0") +"' where sKey  = '"+key+"'");
	}
	
	for(int i=0;i<inputList.size();i++){
		key=inputList.get(i);
		RecordSet.execute("update FullSearch_EAssistantSet set sValue  ='" + Util.null2String(request.getParameter(key)) +"' where sKey  = '"+key+"'");
	}
	
	//给内存客服工作台重置参数
	try{
        Class clazz = Class.forName("weaver.eassistant.CONSTS");
        Method m = clazz.getMethod("reset");
        m.invoke(clazz);  
    } catch (Exception e) {
    	
    }
	
	response.sendRedirect("/fullsearch/EAssistantSet.jsp");
%>
