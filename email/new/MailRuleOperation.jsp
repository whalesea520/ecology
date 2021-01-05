
<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.domain.*" %>
<%@ page import="java.lang.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="mrs" class="weaver.email.service.MailRuleService" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
int userId = user.getUID();

if(operation.equals("add")){
	MailRule rule = new MailRule();
	
	String ruleName = Util.null2String(request.getParameter("ruleName"));
	String matchAll = Util.null2String(request.getParameter("matchAll"));
	String applyTime = Util.null2String(request.getParameter("applyTime"));
	String mailAccountId = Util.null2String(request.getParameter("mailAccountId"));
	
	rule.setUserId(userId);
	rule.setRuleName(ruleName);
	rule.setMatchAll(matchAll);
	rule.setApplyTime(applyTime);
	rule.setMailAccountId(mailAccountId);


	String cSourceArrays = Util.null2String(request.getParameter("cSource"));
	String operatorArrays = Util.null2String(request.getParameter("operator"));
	String cTargetArrays = Util.null2String(request.getParameter("cTarget"));
	String cTargetPriorityArrays = Util.null2String(request.getParameter("cTargetPriority"));
	String SendDateArrays=Util.null2String(request.getParameter("SendDateArrayass"));

	String [] cSourceNum=cSourceArrays.split(",");
	String [] operatorNum=operatorArrays.split(",");
	String [] cTargetNum=cTargetArrays.split(",");
	String [] cTargetPriorityNum=cTargetPriorityArrays.split(",");
	String [] SendDateNum=SendDateArrays.split(",");
	
	for(int i=0; i<cSourceNum.length; i++) {
		try{
			MailRuleCondition condition = new MailRuleCondition();
			condition.setcSource(Util.null2String(cSourceNum[i]));
			condition.setOperator(Util.null2String(operatorNum[i]));
			condition.setcTarget(Util.null2String(cTargetNum[i]));
			condition.setcTargetPriority(Util.null2String(cTargetPriorityNum[i]));
			condition.setcSendDate(Util.null2String(SendDateNum[i].substring(0,SendDateNum[i].lastIndexOf("a"))));
			rule.getConditions().add(condition);
	    }catch(Exception e){
	        e.printStackTrace();
	    }
	}

	String aSourceArrays = Util.null2String(request.getParameter("aSource"));
	String aTargetFolderIdArrays = Util.null2String(request.getParameter("aTargetFolderId"));

	String [] aSourceNum=aSourceArrays.split(",");
	String [] aTargetFolderIdNum=aTargetFolderIdArrays.split(",");
	
	for(int i=0; i<aSourceNum.length; i++) {
		try{
			MailRuleAction action = new MailRuleAction();
			action.setaSource(Util.null2String(aSourceNum[i]));
			action.setaTargetFolderId(Util.null2String(aTargetFolderIdNum[i]));
			rule.getActions().add(action);
	    }catch(Exception e){
	        e.printStackTrace();
	    }
	}
	mrs.addRule(rule);
}
%>