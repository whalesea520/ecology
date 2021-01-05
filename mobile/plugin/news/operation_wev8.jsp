<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="net.sf.json.JSONObject"%>
<%
	int status = 1;String msg = "";
	JSONObject json = new JSONObject();
	try{
		DocManager.resetParameter();
		DocManager.setClientAddress(Util.getIpAddr(request));
		DocManager.setUserid(user.getUID());
		DocManager.setLanguageid(user.getLanguage());
		DocManager.setUsertype(""+user.getLogintype());	 
		String message = DocManager.UploadDoc(request);
		int docId=DocManager.getId();
		DocComInfo.addDocInfoCache(""+docId);
		DocViewer.setDocShareByDoc(""+docId);
		rs.executeSql("update DocDetail set docStatus='1' where id="+docId);
		status = 0;
	}catch(Exception e){
		e.printStackTrace();
		msg = "保存回复文档失败:"+e.getMessage();
	}
	json.put("status",status);
	json.put("msg",msg);
	out.print(json.toString());
%>