<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.List"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="weaver.conn.ConnStatement"%>
<%@page import="oracle.sql.CLOB"%>
<%@page import="java.io.Writer"%>
<%@page import="weaver.fna.general.FnaCommon"%><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="org.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("##############################0.00");
String operation = Util.null2String(request.getParameter("operation"));


if(operation.equals("doSave")){
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"),0);
	
	String dSetName = Util.null2String(request.getParameter("dSetName")).trim();
	String dataSourceName = Util.null2String(request.getParameter("dataSourceName")).trim();
	String dsMemo = Util.null2String(request.getParameter("dsMemo")).trim();
	String dSetType = Util.null2String(request.getParameter("dSetType")).trim();
	String dSetStr = Util.null2String(request.getParameter("dSetStr")).trim();

    Des desObj = new Des();
	dSetStr = desObj.strDec(dSetStr, Des.KEY1, Des.KEY2, Des.KEY3);
	
	rs.executeSql("select count(*) cnt from fnaDataSet "+
		" where id <> "+id+" and dSetName = '"+StringEscapeUtils.escapeSql(dSetName)+"'");
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelNames("195,18082",user.getLanguage()))+"}");
		out.flush();
		return;
	}

	if(id<=0){
		rs.executeSql("insert into fnaDataSet (dSetName, dataSourceName, dsMemo, dSetType, fnaVoucherXmlId) "+
			" values ('"+StringEscapeUtils.escapeSql(dSetName)+"', '"+StringEscapeUtils.escapeSql(dataSourceName)+"', "+
			" '"+StringEscapeUtils.escapeSql(dsMemo)+"', '"+StringEscapeUtils.escapeSql(dSetType)+"', "+
			" "+fnaVoucherXmlId+") ");
		rs.executeSql("select max(id) maxId from fnaDataSet "+
			" where fnaVoucherXmlId = "+fnaVoucherXmlId+" and dSetName = '"+StringEscapeUtils.escapeSql(dSetName)+"' ");
		if(rs.next()){
			id = rs.getInt("maxId");
		}
	}else{
		rs.executeSql("update fnaDataSet "+
			" set dSetName = '"+StringEscapeUtils.escapeSql(dSetName)+"', "+
			" dataSourceName = '"+StringEscapeUtils.escapeSql(dataSourceName)+"', "+
			" dsMemo = '"+StringEscapeUtils.escapeSql(dsMemo)+"', "+
			" dSetType = '"+StringEscapeUtils.escapeSql(dSetType)+"' "+
			" where id = "+id);
	}
	
	FnaCommon.updateDbClobOrTextFieldValue("fnaDataSet", 
			"DSETSTR", dSetStr, 
			"id", id+"", "int");

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
	out.flush();
	return;
	
}else if(operation.equals("delete") || operation.equals("batchDel")){

	String batchDelIds = Util.null2String(request.getParameter("batchDelIds"));
	if(operation.equals("delete")){
		int id = Util.getIntValue(request.getParameter("id"));
		batchDelIds = id+"";
	}
	String[] batchDelIdsArray = batchDelIds.split(",");
	
	for(int i=0;i<batchDelIdsArray.length;i++){
		int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
		if(_delId > 0){
			rs.executeSql("select count(*) cnt \n" +
					"from fnaVoucherXmlContentDset b \n" +
					"where b.fnaDataSetId = "+_delId);
			if(rs.next() && rs.getInt("cnt") > 0){
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(124794,user.getLanguage()))+"}");//数据集正在被使用不能删除
				out.flush();
				return;
			}
		}
	}
	
	for(int i=0;i<batchDelIdsArray.length;i++){
		int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
		if(_delId > 0){
			rs.executeSql("delete from fnaDataSet where id = "+_delId);
		}
	}
	out.println("{\"flag\":true}");//删除成功
	out.flush();
	return;
}	
%>
