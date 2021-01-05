<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<%

if(!HrmUserVarify.checkUserRight("CptCapital:MoveIn", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String CptDept_to = "";
String hrmid = "";
String usecount="1"; 
String usestatus ="-4";
String replacecapitalid="";
String remark="";
String location="";
String CptDept_from="";

String dtinfo = Util.null2String(request.getParameter("dtinfo"));
dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
//System.out.println("dtinfo:"+dtinfo);
JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
if(dtJsonArray!=null&&dtJsonArray.size()>0){
	for(int i=0;i<dtJsonArray.size();i++){
		JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
		if(dtJsonArray2!=null&&dtJsonArray2.size()>=8){
			location= dtJsonArray2.getJSONObject(3).getString("location");
			remark= dtJsonArray2.getJSONObject(4).getString("remark");
			hrmid=dtJsonArray2.getJSONObject(5).getString("hrmid");
			CptDept_to=dtJsonArray2.getJSONObject(6).getString("CptDept_to");
			replacecapitalid= dtJsonArray2.getJSONObject(7).getString("capitalid");
			CptDept_from = CapitalComInfo.getDepartmentid(replacecapitalid);
			
			
			char flag=2;
			String para = "";

		    para = replacecapitalid ;
		    para +=flag+currentdate;
		    para +=flag+CptDept_to;
		    para +=flag+hrmid;
		    para +=flag+usecount;
		    para +=flag+location;	
		    para +=flag+usestatus;
		    para +=flag+remark;    
		    para +=flag+CptDept_from;

			RecordSet.executeProc("Capital_Adjust",para);
			RecordSet.executeSql("update cptcapital set location='"+location+"' where id='"+replacecapitalid+"' ");
			
			CapitalComInfo.removeCapitalCache();
			CptShare.setCptShareByCpt(replacecapitalid); 
			
		}
	}
}


response.sendRedirect("CptCapitalMoveTab.jsp"); 
 
%>

