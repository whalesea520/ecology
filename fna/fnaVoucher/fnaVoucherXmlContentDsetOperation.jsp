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

if(operation.equals("edit")){
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"), 0);
	int fnaVoucherXmlContentId = Util.getIntValue(request.getParameter("fnaVoucherXmlContentId"), 0);
	
	String fnaDataSetId = Util.null2String(request.getParameter("fnaDataSetId")).trim();
	String dSetAlias = Util.null2String(request.getParameter("dSetAlias")).trim();
	String parameter = Util.null2String(request.getParameter("parameter")).trim();
	String dsetMemo = Util.null2String(request.getParameter("dsetMemo")).trim();
	double orderId = Util.getDoubleValue(request.getParameter("orderId"), 0.00);
	int initTiming = Util.getIntValue(request.getParameter("initTiming"), 0);
	
	if(!dSetAlias.equals(dSetAlias.replaceAll("[^(a-zA-Z0-9)]", ""))){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(84744,user.getLanguage()))+"}");
		out.flush();
		return;
	}
	
	String sql = "select count(*) cnt from fnaVoucherXmlContentDset "+
			" where dSetAlias = '"+StringEscapeUtils.escapeSql(dSetAlias)+"' and id <> "+id+" "+
			" and fnaVoucherXmlId = "+fnaVoucherXmlId+" ";
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(84745,user.getLanguage()))+"}");//当前XML模板中已存在相同别名数据集
		out.flush();
		return;
	}
	

    Des desObj = new Des();
    parameter = desObj.strDec(parameter, Des.KEY1, Des.KEY2, Des.KEY3);

	if(id<=0){
		sql = "insert into fnaVoucherXmlContentDset (fnaVoucherXmlId, fnaVoucherXmlContentId, dSetAlias, "+
			" fnaDataSetId, "+
			" dsetMemo, orderId, initTiming) "+
			" values ("+fnaVoucherXmlId+", "+fnaVoucherXmlContentId+", '"+StringEscapeUtils.escapeSql(dSetAlias)+"', "+
			" "+fnaDataSetId+", "+
			" '"+StringEscapeUtils.escapeSql(dsetMemo)+"', "+df.format(orderId)+", "+initTiming+") ";
		rs.executeSql(sql);
		rs.executeSql("select max(id) maxId from fnaVoucherXmlContentDset "+
			" where dSetAlias = '"+StringEscapeUtils.escapeSql(dSetAlias)+"' and fnaDataSetId = "+fnaDataSetId+" "+
			" and fnaVoucherXmlContentId = "+fnaVoucherXmlContentId+" and fnaVoucherXmlId = "+fnaVoucherXmlId);
		if(rs.next()){
			id = rs.getInt("maxId");
		}
	}else{
		sql = "update fnaVoucherXmlContentDset "+
			" set fnaDataSetId = "+fnaDataSetId+", "+
			" dSetAlias = '"+StringEscapeUtils.escapeSql(dSetAlias)+"', "+
			" dsetMemo = '"+StringEscapeUtils.escapeSql(dsetMemo)+"', "+
			" orderId = "+df.format(orderId)+", "+
			" initTiming = "+initTiming+" "+
			" where id = "+id;
		rs.executeSql(sql);
	}
	
	FnaCommon.updateDbClobOrTextFieldValue("fnaVoucherXmlContentDset", 
			"PARAMETER", parameter, 
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
			rs.executeSql("delete from fnaVoucherXmlContentDset where id = "+_delId);
		}
	}
	out.println("{\"flag\":true}");//删除成功
	out.flush();
	return;

}
%>
