<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CptCapital:Mend", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String from = Util.null2String (request.getParameter("from"));
String userequest = Util.fromScreen(request.getParameter("userequest"),user.getLanguage());
String menddate = "";
String maintaincompany = "";
String resourceid = "";
String mendperioddate = "";
String cost = "";
String remark = "";
String capitalid = "";
String departmentid="";
if("one".equalsIgnoreCase(from)){//单一的资产送修
	menddate = Util.null2String (request.getParameter("menddate"));
	maintaincompany = Util.null2String (request.getParameter("maintaincompany"));
	resourceid = Util.null2String (request.getParameter("operator"));
	mendperioddate = Util.null2String (request.getParameter("mendperioddate"));
	cost = Util.null2s(Util.null2String (request.getParameter("cost")), "0");
	remark = Util.null2String (request.getParameter("remark"));
	capitalid = Util.null2String (request.getParameter("capitalid"));
	
	String sql="";
	sql="select departmentid from CptCapital where id="+ capitalid;
	RecordSetM.executeSql(sql);
	RecordSetM.next(); 
	departmentid =  RecordSetM.getString("departmentid");

	char separator = Util.getSeparator() ;
	String para = "";

    para = capitalid;
    para +=separator+menddate;
    para +=separator+"";
    para +=separator+"";
    para +=separator+"1";
    para +=separator+"";
    para +=separator+"0";
    para +=separator+maintaincompany;
    para +=separator+cost;
    para +=separator+"4";
    para +=separator+remark;
    para +=separator+resourceid;
    para +=separator+mendperioddate;
	para +=separator+departmentid;

    RecordSet.executeProc("CptUseLogMend_Insert2",para);

	CapitalComInfo.removeCapitalCache();
	
	%>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent.window);
try{
	//$(parent.window.document).find("#cptstatus_span").html("<%=SystemEnv.getHtmlLabelName(1382,user.getLanguage()) %>");
	parentWin._table.reLoad();
}catch(e){
	
}
parentWin.closeDialog();
</script>
	
	
	<%
	return;
	
}



String dtinfo = Util.null2String(request.getParameter("dtinfo"));
dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
//System.out.println("dtinfo:"+dtinfo);
JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
if(dtJsonArray!=null&&dtJsonArray.size()>0){
	for(int i=0;i<dtJsonArray.size();i++){
		JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
		if(dtJsonArray2!=null&&dtJsonArray2.size()>=10){
			cost= Util.null2s(dtJsonArray2.getJSONObject(3).getString("cost"),"0");
			remark= dtJsonArray2.getJSONObject(4).getString("remark");
			resourceid= dtJsonArray2.getJSONObject(5).getString("operator");
			menddate= dtJsonArray2.getJSONObject(6).getString("menddate");
			mendperioddate= dtJsonArray2.getJSONObject(7).getString("mendperioddate");
			maintaincompany= dtJsonArray2.getJSONObject(8).getString("maintaincompany");
			capitalid= dtJsonArray2.getJSONObject(9).getString("capitalid");
			
			String sql="";
			sql="select departmentid from CptCapital where id="+ capitalid;
			RecordSetM.executeSql(sql);
			RecordSetM.next(); 
			departmentid =  RecordSetM.getString("departmentid");

			char separator = Util.getSeparator() ;
			String para = "";

		    para = capitalid;
		    para +=separator+menddate;
		    para +=separator+"";
		    para +=separator+"";
		    para +=separator+"1";
		    para +=separator+"";
		    para +=separator+"0";
		    para +=separator+maintaincompany;
		    para +=separator+cost;
		    para +=separator+"4";
		    para +=separator+remark;
		    para +=separator+resourceid;
		    para +=separator+mendperioddate;
			para +=separator+departmentid;

		    RecordSet.executeProc("CptUseLogMend_Insert2",para);

			CapitalComInfo.removeCapitalCache();
		}
	}
}


response.sendRedirect("CptCapitalMendTab.jsp");
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">