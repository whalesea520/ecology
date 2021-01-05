<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.RecordSet" %>
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
		DocManager.setClientAddress(this.getIpAddr(request));
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
		msg = "±£´æ»Ø¸´ÎÄµµÊ§°Ü:"+e.getMessage();
	}
	json.put("status",status);
	json.put("msg",msg);
	out.print(json.toString());
%>
<%!
public String getIpAddr(HttpServletRequest request) {      
    String ip = request.getHeader("x-forwarded-for");      
    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
        ip = request.getHeader("Proxy-Client-IP");      
    }      
    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
        ip = request.getHeader("WL-Proxy-Client-IP");      
    }      
    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
        ip = request.getRemoteAddr();      
    }   
    if ((ip.indexOf(",") >= 0)){
        ip = ip.substring(0 , ip.indexOf(","));
    }
    return ip;      
}
%>