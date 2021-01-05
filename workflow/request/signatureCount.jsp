<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="RequestSignatureManager" class="weaver.workflow.request.RequestSignatureManager" scope="page" />
<%

int requestId = Util.getIntValue(request.getParameter("requestId"),0);
int nodeId = Util.getIntValue(request.getParameter("nodeId"),0);
int userId = Util.getIntValue(request.getParameter("userId"),0);
int loginType = Util.getIntValue(request.getParameter("loginType"),1);

JSONArray resultArray = new JSONArray();
JSONObject json = new JSONObject();

boolean hasSignatureSucceed = RequestSignatureManager.ifHasSignatureSucceed(requestId,nodeId,userId,loginType);
json.put("signatureCount",hasSignatureSucceed);
resultArray.add(json);


out.print(resultArray.toString());
%>