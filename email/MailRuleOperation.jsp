
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String sql = "";
String operation = Util.null2String(request.getParameter("operation"));
int userId = user.getUID();
int ruleId = Util.getIntValue(request.getParameter("id"));
String ruleName = Util.null2String(request.getParameter("ruleName"));
String matchAll = Util.null2String(request.getParameter("matchAll"));
String applyTime = Util.null2String(request.getParameter("applyTime"));
int mailAccountId = Util.getIntValue(request.getParameter("mailAccountId"));
int maxMailRuleId = 0;

String showTop = Util.null2String(request.getParameter("showTop"));

if(operation.equals("add")){
	sql = "INSERT INTO MailRule (userId, ruleName, matchAll, applyTime, mailAccountId) VALUES ("+userId+", '"+ruleName+"', '"+matchAll+"', '"+applyTime+"', "+mailAccountId+")";
	rs.executeSql(sql);
	out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
	return;
}else if(operation.equals("conditionAdd")){
	String cSource = Util.null2String(request.getParameter("cSource"));
	String operator = Util.null2String(request.getParameter("operator"));
	String cTarget = Util.null2String(request.getParameter("cTarget"));
	String cTargetPriority = Util.null2String(request.getParameter("cTargetPriority"));
	String cSendDate = Util.null2String(request.getParameter("sendDate"));
	
	if(cSource.equals("5"))operator = "3";
	
	sql = "INSERT INTO MailRuleCondition (ruleId, cSource, operator, cTarget, cTargetPriority, cSendDate) VALUES ("+ruleId+", '"+cSource+"','"+operator+"','"+cTarget+"', '"+cTargetPriority+"', '"+cSendDate+"')";
	rs.executeSql(sql);
	if(showTop.equals("")) {
		response.sendRedirect("MailRuleEdit.jsp?id="+ruleId+"");
	} else if(showTop.equals("show800")) {
		response.sendRedirect("MailRuleEdit.jsp?id="+ruleId+"");
	}
	return;

}else if(operation.equals("actionAdd")){
	String aSource = Util.null2String(request.getParameter("aSource"));
	int aTargetFolderId = Util.getIntValue(request.getParameter("aTargetFolderId"));
	int aTargetCRMId = Util.getIntValue(request.getParameter("aTargetCRMId"));
	int mainId = Util.getIntValue(request.getParameter("mainId"));
	int subId = Util.getIntValue(request.getParameter("subId"));
	int secId = Util.getIntValue(request.getParameter("secId"));
	sql = "INSERT INTO MailRuleAction (ruleId, aSource, aTargetFolderId, aTargetCRMId, mainId, subId, secId) VALUES ("+ruleId+", '"+aSource+"',"+aTargetFolderId+","+aTargetCRMId+","+mainId+","+subId+","+secId+")";
	rs.executeSql(sql);
	if(showTop.equals("")) {
		response.sendRedirect("MailRuleEdit.jsp?id="+ruleId+"");
	} else if(showTop.equals("show800")) {
		response.sendRedirect("MailRuleEdit.jsp?id="+ruleId+"");
	}
	return;

}else if(operation.equals("edit")){
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
	

	
					
	for(int i=0;i<cSourceNum.length;i++){
		String cSource=""; 
		String operator="";
		String cTarget="";
		String cTargetPriority="";
		String cSendDate="";
	    boolean boo=false;
	    
	    
		if(cSourceNum.length>0&&cSourceNum[i].length()>0){
			boo=true;
		}
		try{
			cSource = Util.null2String(cSourceNum[i]);
	    }catch(Exception ex){
	        
	    }
	    try{
			operator = Util.null2String(operatorNum[i] );
		}catch(Exception ex){
	        
	    }
	    try{  
			cTarget =Util.null2String(cTargetNum[i]);
		}catch(Exception ex){
	        
	    }
		try{ 
			cTargetPriority=Util.null2String(cTargetPriorityNum[i]);
		}catch(Exception ex){
	        
	    }
		try{ 
			cSendDate=Util.null2String(SendDateNum[i].substring(0,SendDateNum[i].lastIndexOf("a")));
			
		}catch(Exception ex){
	        
	    }
		
		if(cSource.equals("5"))operator = "3";
		
		sql = "INSERT INTO MailRuleCondition (ruleId, cSource, operator, cTarget, cTargetPriority, cSendDate) VALUES ("+ruleId+", '"+cSource+"','"+operator+"','"+cTarget+"', '"+cTargetPriority+"', '"+cSendDate+"')";
		
		if(boo){
			
			rs.executeSql(sql);
		}else{
			
		}
	}
	
	
	String aSourceArrays = Util.null2String(request.getParameter("aSource"));
	String aTargetFolderIdArrays = Util.null2String(request.getParameter("aTargetFolderId"));
	String aTargetCRMIdArrays = Util.null2String(request.getParameter("aTargetCRMId"));
	String mainIdArrays = Util.null2String(request.getParameter("mainId"));
	String subIdArrays = Util.null2String(request.getParameter("subId"));
	String secIdArrays = Util.null2String(request.getParameter("secId"));
	String [] aSourceNum=aSourceArrays.split(",");
	String [] aTargetFolderIdNum=aTargetFolderIdArrays.split(",");
	String [] aTargetCRMIdNum=aTargetCRMIdArrays.split(",");
	String [] mainIdNum=mainIdArrays.split(",");
	String [] subIdNum=subIdArrays.split(",");
	String [] secIdNum=secIdArrays.split(",");
	
	for(int j=0;j<aSourceNum.length;j++){
		String aSource="";	
		int aTargetFolderId=-1;
		int aTargetCRMId=-1;
		int mainId=-1;
		int subId=-1;
		int secId=-1;
		boolean boo=false;
		if(aSourceNum.length>0&&aSourceNum[j].length()>0){
			boo=true;
		}
		try{
			aSource =Util.null2String(aSourceNum[j]);
		}catch(Exception ex){
	        
	    }
		try{
			aTargetFolderId =Util.getIntValue(aTargetFolderIdNum[j]);
		}catch(Exception ex){
	        
	    }
		try{
			aTargetCRMId =Util.getIntValue(aTargetCRMIdNum[j]);
		}catch(Exception ex){
	        
	    }
	
		try{
			mainId =Util.getIntValue(mainIdNum[j]);
		}catch(Exception ex){
	        
	    }
		try{
			subId = Util.getIntValue(subIdNum[j]);
		}catch(Exception ex){
	        
	    }
		try{
			secId =Util.getIntValue(secIdNum[j]);
		}
		catch(Exception ex){
	        
	    }
		sql = "INSERT INTO MailRuleAction (ruleId, aSource, aTargetFolderId, aTargetCRMId, mainId, subId, secId) VALUES ("+ruleId+", '"+aSource+"',"+aTargetFolderId+","+aTargetCRMId+","+mainId+","+subId+","+secId+")";
		if(boo){
         		rs.executeSql(sql);
		}
	}
	
	String conditionId = request.getParameter("conditionId");
	if(conditionId!=""&&!conditionId.equals("")&conditionId!=null){
		sql = "DELETE FROM MailRuleCondition WHERE id in ("+conditionId+")";
		rs.executeSql(sql);
	}
	
	String actionId = request.getParameter("actionId");
	if(actionId!=""&&!actionId.equals("")&&actionId!=null){
		sql = "DELETE FROM MailRuleAction WHERE id in ("+actionId+")";
		rs.executeSql(sql);
	}
	
	sql = "UPDATE MailRule SET ruleName='"+ruleName+"', matchAll='"+matchAll+"', applyTime='"+applyTime+"', mailAccountId="+mailAccountId+" WHERE id="+ruleId+"";
	rs.executeSql(sql);
	
	out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
	return;
	
}else if(operation.equals("deleteRuleAction")){
	String actionId = Util.null2String(request.getParameter("actionId"));
	sql = "DELETE FROM MailRuleAction WHERE id in ("+actionId+")";
	rs.executeSql(sql);
	if(showTop.equals("")) {
		response.sendRedirect("MailRuleEdit.jsp?id="+ruleId+"");
	} else if(showTop.equals("show800")) {
		response.sendRedirect("MailRuleEdit.jsp?id="+ruleId+"");
	}
	return;

}else if(operation.equals("deleteRuleCondition")){
	String conditionId = Util.null2String(request.getParameter("conditionId"));
	sql = "DELETE FROM MailRuleCondition WHERE id in ("+conditionId+")";
	rs.executeSql(sql);
	if(showTop.equals("")) {
		response.sendRedirect("MailRuleEdit.jsp?id="+ruleId+"");
	} else if(showTop.equals("show800")) {
		response.sendRedirect("MailRuleEdit.jsp?id="+ruleId+"");
	}
	return;

}else if(operation.equals("active")){
	String activeRuleIds = Util.null2String(request.getParameter("activeRuleIds"));
	activeRuleIds = activeRuleIds.endsWith(",") ? activeRuleIds.substring(0,activeRuleIds.length()-1) : activeRuleIds;
	sql = "UPDATE MailRule SET isActive='1' WHERE id IN ("+activeRuleIds+")";
	rs.executeSql(sql);
	if(activeRuleIds.equals("")){
		sql = "UPDATE MailRule SET isActive='0' where userId='"+userId+"'";
	}else{
		sql = "UPDATE MailRule SET isActive='0' WHERE userId='"+userId+"' and id NOT IN ("+activeRuleIds+")";
	}
	
	rs.executeSql(sql);

}else{
	sql = "DELETE FROM MailRule WHERE id="+ruleId+"";
	rs.executeSql(sql);
	sql = "DELETE FROM MailRuleCondition WHERE ruleId="+ruleId+"";
	rs.executeSql(sql);
	sql = "DELETE FROM MailRuleAction WHERE ruleId="+ruleId+"";
	rs.executeSql(sql);
}
if(showTop.equals("")) {
	response.sendRedirect("MailRule.jsp");
} else if(showTop.equals("show800")) {
	response.sendRedirect("MailRule.jsp?showTop=show800");
}

%>
