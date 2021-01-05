
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	String docid = Util.null2String(request.getParameter("docid"));
	String showType = Util.null2String(request.getParameter("showType"));
	boolean canEdit = Util.null2String(request.getParameter("canEdit")).equals("true");
	int coworkid = Util.getIntValue(request.getParameter("coworkid"));
	int meetingid = Util.getIntValue(request.getParameter("meetingid"));
	int requestid = Util.getIntValue(request.getParameter("requestid"));
	String isrequest="";
	if(requestid>0){
		isrequest="1";
	}

	JSONObject oJson= new JSONObject();
	ArrayList dataList=new ArrayList();
	DocDsp.setIsRequest(isrequest);
	DocDsp.setRequestId(requestid);
	//dataList=DocDsp.getDocAccessoryArrayList(Util.getIntValue(docid), showType, canEdit, coworkid);
	dataList=DocDsp.getDocAccessoryArrayList(Util.getIntValue(docid), showType, canEdit, coworkid,meetingid,true);

	oJson.put("data",dataList);
    out.print(oJson.toString());
%>