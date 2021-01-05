<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
<%

String type = Util.null2String(request.getParameter("type")).trim();
String imagefileId = Util.null2String(request.getParameter("imagefileId")).trim();
String userName = Util.null2String(request.getParameter("userName")).trim();
String requestId = Util.null2String(request.getParameter("requestId")).trim();
String nodeId = Util.null2String(request.getParameter("nodeId")).trim();
String userId = Util.null2String(request.getParameter("userId")).trim();
String loginType = Util.null2String(request.getParameter("loginType")).trim();

JSONArray resultArray = new JSONArray();
JSONObject json = new JSONObject();
if("versionDetail".equals(type)) {
	String otherParams = Util.null2String(request.getParameter("otherParams")).trim();
	String versionDetail = userName + " " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + " " + otherParams + ".";
	rs.executeUpdate("UPDATE DocImageFile SET versionDetail = ? WHERE imagefileid = ?", versionDetail, imagefileId);
	json.put("versionDetail","versionDetail="+versionDetail+",imagefileId="+imagefileId);
	resultArray.add(json);
} else if("signatureCount".equals(type)) {
	int signatureCount = Util.getIntValue(request.getParameter("signatureCount"),0);// 签章个数
	int oldSignatureCount = Util.getIntValue(request.getParameter("initSignatureCount"),0);// 初始签章个数
	if(signatureCount > oldSignatureCount) {
		DocCheckInOutUtil.saveIsignatureFun(requestId,nodeId,userId,loginType,""+(signatureCount - oldSignatureCount));
	}
	json.put("signatureCount","requestId="+requestId+",nodeId="+nodeId+",userId="+userId+",loginType="+loginType+",signatureCount"+signatureCount+",oldSignatureCount"+oldSignatureCount);
	resultArray.add(json);
}

out.print(resultArray.toString());
%>