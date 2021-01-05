<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CptCapital:Lend", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//get today
Calendar todaycal = Calendar.getInstance ();
String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
               Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
               Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;

String hrmid = "";
String departmentid = "";
String lenddate = "";
String capitalid = "";
String location = "";
String remark = "";

String dtinfo = Util.null2String(request.getParameter("dtinfo"));
dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
if(dtJsonArray!=null&&dtJsonArray.size()>0){
	for(int i=0;i<dtJsonArray.size();i++){
		JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
		if(dtJsonArray2!=null&&dtJsonArray2.size()>=7){
			location= dtJsonArray2.getJSONObject(2).getString("location");
			remark= dtJsonArray2.getJSONObject(3).getString("remark");
			hrmid= dtJsonArray2.getJSONObject(4).getString("hrmid");
			lenddate= dtJsonArray2.getJSONObject(5).getString("StockInDate");
			capitalid= dtJsonArray2.getJSONObject(6).getString("capitalid");
			departmentid = ResourceComInfo.getDepartmentID(hrmid);
			
			char separator = Util.getSeparator() ;
			String para = "";

		    para = capitalid;
		    para +=separator+lenddate;
		    para +=separator+departmentid;
		    para +=separator+hrmid;
		    para +=separator+"1";
		    para +=separator+location;
		    para +=separator+"0";
		    para +=separator+"";
		    para +=separator+"0";
		    para +=separator+"3";
		    para +=separator+remark;
		    para +=separator+"0";

		    RecordSet.executeProc("CptUseLogLend_Insert",para);
		    CapitalComInfo.removeCapitalCache();
		    CptShare.setCptShareByCpt(capitalid);//更新detail表 
			
		}
	}
}


response.sendRedirect("CptCapitalLendTab.jsp");
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">