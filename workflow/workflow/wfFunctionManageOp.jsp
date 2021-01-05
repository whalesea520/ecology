
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%
int wfid = Util.getIntValue(request.getParameter("wfid"),-1);
int nodeid = -1;
String nodetype = "";
rs.executeSql("delete workflow_function_manage where workflowid = " + wfid + " and operatortype IN (SELECT id FROM workflow_nodebase WHERE (IsFreeNode is null or IsFreeNode!='1') AND workflowid=" + wfid + ")");
rs.executeSql("delete workflow_function_manage where workflowid = " + wfid + " and (operatortype=-1 or operatortype=-9) ");


String watch_sv = Util.null2String(request.getParameter("watch_sv"));
  String watch_dv = Util.null2String(request.getParameter("watch_dv"));
  String watch_zc = Util.null2String(request.getParameter("watch_zc"));
  String watch_mc = Util.null2String(request.getParameter("watch_mc"));
  String watch_fw = Util.null2String(request.getParameter("watch_fw"));
  String watch_rb = Util.null2String(request.getParameter("watch_rb"));
  String watch_ov = Util.null2String(request.getParameter("watch_ov"));
  rs.executeSql("insert into workflow_function_manage (workflowid,typeview,dataview,automatism ,manual,transmit,retract,pigeonhole,operatortype) values ("+wfid+",'"+watch_sv+"','"+watch_dv+"','"+watch_zc+"','"+watch_mc+"','"+watch_fw+"','"+watch_rb+"','"+watch_ov+"',-1)");

/*
  String carete_sv = Util.null2String(request.getParameter("carete_sv"));
  String carete_dv = Util.null2String(request.getParameter("carete_dv"));
  String carete_zc = Util.null2String(request.getParameter("carete_zc"));
  String carete_mc = Util.null2String(request.getParameter("carete_mc"));
  String carete_fw = Util.null2String(request.getParameter("carete_fw"));
  String carete_rb = Util.null2String(request.getParameter("carete_rb"));
  String carete_ov = Util.null2String(request.getParameter("carete_ov"));
  rs.executeSql("insert workflow_function_manage values ("+wfid+",'"+carete_sv+"','"+carete_dv+"','"+carete_zc+"','"+carete_mc+"','"+carete_fw+"','"+carete_rb+"','"+carete_ov+"',-2)");
*/
  
   
String isoverrb = Util.null2String(request.getParameter("isoverrb"));
String isoveriv = Util.null2String(request.getParameter("isoveriv"));
rs.executeSql("update workflow_base set isoverrb='"+isoverrb+"' , isoveriv='"+isoveriv+"' where id="+wfid);
 
int jfreenode = 0;
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode();
while(WFNodeMainManager.next() || jfreenode++ == 0){
nodeid = WFNodeMainManager.getNodeid();
nodetype = WFNodeMainManager.getNodetype() ;
  	if (jfreenode == 1) {
	    nodeid = -9;
	}
  
  String temp_sv = Util.null2String(request.getParameter("node"+nodeid+"_sv"));
  String temp_dv = Util.null2String(request.getParameter("node"+nodeid+"_dv"));
  String temp_zc = Util.null2String(request.getParameter("node"+nodeid+"_zc"));
  String temp_mc = Util.null2String(request.getParameter("node"+nodeid+"_mc"));
  String temp_fw = Util.null2String(request.getParameter("node"+nodeid+"_fw"));
  String temp_rb = Util.null2String(request.getParameter("node"+nodeid+"_rb"));
  String temp_ov = Util.null2String(request.getParameter("node"+nodeid+"_ov"));
  //if(!isoverrb.equals("1")&&nodetype.equals("3")){
  //	temp_rb = "0";
  //}  
  String temp_isDeleSubWf = Util.null2String(request.getParameter("node"+nodeid+"_isDeleSubWf"));
  if( !temp_isDeleSubWf.equals("1")){
  	temp_isDeleSubWf = "0";
  }
  rs.executeSql("insert into workflow_function_manage (workflowid,typeview,dataview,automatism ,manual,transmit,retract,pigeonhole,operatortype,isDeleSubWf)  values ("+wfid+",'"+temp_sv+"','"+temp_dv+"','"+temp_zc+"','"+temp_mc+"','"+temp_fw+"','"+temp_rb+"','"+temp_ov+"',"+nodeid+",'"+temp_isDeleSubWf+"')");
  
  	if (nodeid == -9) {
  	  	rs.executeSql("update workflow_function_manage set retract='" + temp_rb + "', pigeonhole='" + temp_ov + "' WHERE EXISTS (SELECT id FROM workflow_nodebase WHERE workflow_function_manage.operatortype=id and IsFreeNode='1' AND workflowid=" + wfid + ") ");
	}
}
  response.sendRedirect("wfFunctionManage.jsp?ajax=1&wfid="+wfid);
  
%>




