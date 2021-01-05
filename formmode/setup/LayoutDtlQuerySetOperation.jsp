<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.service.CustomSearchService"%>
<%@page import="org.apache.lucene.util.StringHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
int id = Util.getIntValue(request.getParameter("id"), 0);
String searchconditiontype = "1";
String defaultsql = "" + Util.fromScreen(request.getParameter("defaultsql"),user.getLanguage());
String javafileAddress = Util.null2String(request.getParameter("javafileAddress"));
String javafilename = Util.null2String(request.getParameter("javafilename"));
String action = Util.null2String(request.getParameter("action"));
String type = Util.null2String(request.getParameter("type"));
String modeId = Util.null2String(request.getParameter("modeId"));
String formId = Util.null2String(request.getParameter("formId"));
String layoutid = Util.null2String(request.getParameter("layoutid"));
String[] searchConditionTypeArr = request.getParameterValues("searchConditionType");
if(searchConditionTypeArr != null && searchConditionTypeArr.length > 0){
	searchconditiontype = searchConditionTypeArr[0];
}
String sql = "";
if("save".equals(action)){
	if(id>0){//修改
		sql = "update mode_layout_querySql set queryType='"+searchconditiontype+"',sqlConetent='"+defaultsql+"',javaFileName='"+javafilename+"',javafileAddress='"+javafileAddress+"' where id = '"+id+"'";
	}else{//新增
		sql = "insert into mode_layout_querySql(modeid,formid,layoutid,detailtype,queryType,sqlConetent,javaFileName,javafileAddress) values('"+modeId+"','"+formId+"','"+layoutid+"','"+type+"','"+searchconditiontype+"','"+defaultsql+"','"+javafilename+"','"+javafileAddress+"')";
	}
	rs.executeSql(sql);
	String close = Util.null2String(request.getParameter("close"));
	if("1".equals(close)){
%>
<script language="javascript">
	window.parent.parent.close();
</script>
<%
	return;
	}else{
		sql = "select * from mode_layout_querySql where modeid = '"+modeId+"' and formId='"+formId+"' and layoutid ='"+layoutid+"' and detailtype='"+type+"' order by id desc";
		rs.executeSql(sql);
		if(rs.next()){
			id = Util.getIntValue(rs.getString("id"), 0);
		}
		response.sendRedirect("/formmode/setup/LayoutDtlQuerySet.jsp?layoutid="+layoutid+"&type="+type+"&modeId="+modeId+"&formId="+formId+"&id="+id+"&success=1");
	}
}else if("clear".equals(action)){
	sql = "delete mode_layout_querySql where id = '"+id+"'";
	rs.executeSql(sql);
	%>
	<script language="javascript">
		window.parent.parent.close();
	</script>
	<%
}
%>