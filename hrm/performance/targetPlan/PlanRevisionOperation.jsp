<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String years=Util.null2String(request.getParameter("years"));
String months=Util.null2String(request.getParameter("months"));
String quarters=Util.null2String(request.getParameter("quarters"));
String weeks=Util.null2String(request.getParameter("weeks"));
String type=Util.null2String(request.getParameter("type"));
int id = Util.getIntValue(request.getParameter("id"));
String operateType = Util.null2String(request.getParameter("operateType"));

rs.executeSql("SELECT modifyStatus FROM workPlan WHERE id="+id+"");
if(rs.next()){
	if(operateType.equals("1")){
		//Åú×¼====================================================================================
		if(rs.getString("modifyStatus").equals("1")){//Ìí¼Ó
			rs2.executeSql("UPDATE workPlan SET status='6',modifyStatus='' WHERE id="+id+"");
		}else if(rs.getString("modifyStatus").equals("2")){//±à¼­
			rs2.executeSql("UPDATE workPlan SET modifyStatus='' WHERE id="+id+"");
			rs2.executeSql("DELETE FROM WorkplanRevisionLog WHERE id="+id+"");
		}else if(rs.getString("modifyStatus").equals("3")){//É¾³ý
			rs2.executeSql("DELETE FROM workPlan WHERE id="+id+"");
		}
	}else{
		//ÍË»Ø====================================================================================
		if(rs.getString("modifyStatus").equals("1")){//Ìí¼Ó
			rs2.executeSql("DELETE FROM workPlan WHERE id="+id+"");
		}else if(rs.getString("modifyStatus").equals("2")){//±à¼­
			rs2.executeSql("UPDATE workPlan SET modifyStatus='' WHERE id="+id+"");
			rs2.executeSql("SELECT * FROM WorkplanRevisionLog WHERE id="+id+"");
			if(rs2.next()){
				rs3.executeSql("UPDATE workPlan SET name='"+rs2.getString("name")+"',oppositeGoal="+rs2.getInt("oppositeGoal")+",planProperty="+rs2.getInt("planProperty")+",isremind="+rs2.getInt("isremind")+",waketime="+rs2.getInt("waketime")+",principal='"+rs2.getString("principal")+"',cowork='"+rs2.getString("cowork")+"',upPrincipal='"+rs2.getString("upPrincipals")+"',downPrincipal='"+rs2.getString("downPrincipals")+"',rbeginDate='"+rs2.getString("rbegindate")+"',rbeginTime='"+rs2.getString("rbegintime")+"',rendDate='"+rs2.getString("renddate")+"',rendTime='"+rs2.getString("rendtime")+"',begindate='"+rs2.getString("begindate")+"',begintime='"+rs2.getString("begintime")+"',enddate='"+rs2.getString("enddate")+"',endtime='"+rs2.getString("endtime")+"',crmid='"+rs2.getString("crmid")+"',docid='"+rs2.getString("docid")+"',projectid='"+rs2.getString("projectid")+"',requestid='"+rs2.getString("requestid")+"',description='"+rs2.getString("description")+"',teamRequest='"+rs2.getString("teamRequest")+"',percent_n='"+rs2.getString("percent_n")+"' WHERE id="+id+"");
			}
			rs2.executeSql("DELETE FROM WorkplanRevisionLog WHERE id="+id+"");
		}else if(rs.getString("modifyStatus").equals("3")){//É¾³ý
			rs2.executeSql("UPDATE workPlan SET modifyStatus='' WHERE id="+id+"");
		}
	}
}

response.sendRedirect("MyPlan.jsp?years="+years+"&months="+months+"&quarters="+quarters+"&weeks="+weeks+"&type="+type+"");
%>