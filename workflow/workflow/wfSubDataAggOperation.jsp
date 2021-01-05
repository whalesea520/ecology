
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
//if(!HrmUserVarify.checkUserRight("FLOWCODE:All", user) && !HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
//	response.sendRedirect("/notice/noright.jsp");
//    return;
//}

int mainwfid = Util.getIntValue(request.getParameter("mainwfid"),-1);
int mainformid = Util.getIntValue(request.getParameter("mainformid"),-1);
int subwfid = Util.getIntValue(request.getParameter("subwfid"),-1);
int subformid = Util.getIntValue(request.getParameter("subformid"),-1);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
String postValue=  Util.null2String(request.getParameter("postValue"));

WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(mainwfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if(mainwfid != -1){
	rs.executeSql("delete from Workflow_DistributionSummary where mainwfid="+mainwfid+" and mainformid="+mainformid+" and subwfid="+subwfid+" and subformid="+subformid+" and nodeid="+nodeid);
	String[] members = Util.TokenizerString2(postValue,"\u0007");
	for (int i=0;i<members.length;i++){
		String member = members[i];
		String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
		String mainfieldid = memberAttibutes[0];
		String subfieldidvalue = memberAttibutes[1];
		String subtypevalue = memberAttibutes[2];
		String fieldhtmltypevalue = memberAttibutes[3];
		String typevalue = memberAttibutes[4];
		String iscreatedocvalue = memberAttibutes[5];
		String maindetailnumvalue = memberAttibutes[6];
		String mainfieldnamevalue = memberAttibutes[7];
		String subfieldnamevalue = memberAttibutes[8];
		int subfieldid = -1;
		int subtype = -1;
		String fieldhtmltype = "";
		String mainfieldname = "";
		String subfieldname = "";
		int maindetailnum = -1;
		int type = -1;
		String iscreatedoc = Util.null2String(iscreatedocvalue);
		if (!"[(*_*)]".equals(subfieldidvalue)){
			subfieldid = Util.getIntValue(subfieldidvalue,-1);
		}
		if (!"[(*_*)]".equals(subtypevalue)){
			subtype = Util.getIntValue(subtypevalue,-1);
		}
		if (!"[(*_*)]".equals(fieldhtmltypevalue)){
			fieldhtmltype = Util.null2String(fieldhtmltypevalue);
		}
		if (!"[(*_*)]".equals(typevalue)){
			type = Util.getIntValue(typevalue,-1);
		}
		if("-1".equals(fieldhtmltype)){
			fieldhtmltype = "";
		}
		if (!"[(*_*)]".equals(maindetailnumvalue)){
			maindetailnum = Util.getIntValue(maindetailnumvalue,-1);
		}
		if (!"[(*_*)]".equals(mainfieldnamevalue)){
			mainfieldname = mainfieldnamevalue;
		}
		if (!"[(*_*)]".equals(subfieldnamevalue)){
			subfieldname = subfieldnamevalue;
		}
		String insertStr = "insert into Workflow_DistributionSummary (mainwfid,mainformid,mainfieldid,mainfieldname,maindetailnum,nodeid,subwfid,subformid,subfieldid,subfieldname,subtype,fieldhtmltype,type,iscreatedoc) values ("+mainwfid+","+mainformid+","+mainfieldid+",'"+mainfieldname+"',"+maindetailnum+","+nodeid+","+subwfid+","+subformid+","+subfieldid+",'"+subfieldname+"',"+subtype+",'"+fieldhtmltype+"',"+type+",'"+iscreatedoc+"')";	  
		rs1.executeSql(insertStr);
	}
}
response.sendRedirect("wfSubDataAggregation.jsp?isclose=1&nodeid="+nodeid);
%>