<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("CostStandardDimension:Set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("###################################################0.00");

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("add")){//新增
    Des desObj = new Des();
	
	String name = Util.null2String(request.getParameter("name")).trim();
	int enabled = Util.getIntValue(request.getParameter("enabled"), 0);
	int paramtype = Util.getIntValue(request.getParameter("paramtype"), 0);
	int browsertype = Util.getIntValue(request.getParameter("browsertype"), 0);
	String compareoption1 = Util.null2String(request.getParameter("compareoption1")).trim();
	String description = Util.null2String(request.getParameter("description")).trim();
	description = desObj.strDec(description, Des.KEY1, Des.KEY2, Des.KEY3);
	double orderNumber = Util.getDoubleValue(request.getParameter("orderNumber"), 999);
	String definebroswerType = Util.null2String(request.getParameter("definebroswerType")).trim();
	String fielddbtype1 = Util.null2String(request.getParameter("fielddbtype1")).trim();
	String fielddbtype2 = Util.null2String(request.getParameter("fielddbtype2")).trim();

	String fielddbtype = "";
	if(161==browsertype||162==browsertype){
		fielddbtype = fielddbtype1;
	}else if(256==browsertype||257==browsertype){
		fielddbtype = fielddbtype2;
	}
	
	String browsertypeSqlStr = "NULL";
	if(browsertype>0 && paramtype==3){
		browsertypeSqlStr = browsertype+"";
	}
	
	String sql = "select count(*) cnt from FnaCostStandard where name = '"+StringEscapeUtils.escapeSql(name)+"'";
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(26603,user.getLanguage()))+"}");//名称重复
		out.flush();
		return;
		
	}else{
		String guid1 = FnaCommon.getPrimaryKeyGuid1();
		sql = "INSERT INTO FnaCostStandard \n" +
			" (guid1, name, paramtype, browsertype, compareoption1, enabled, orderNumber, description, definebroswerType, fielddbtype)\n" +
			" VALUES\n" +
			" ('"+StringEscapeUtils.escapeSql(guid1)+"', '"+StringEscapeUtils.escapeSql(name)+"', "+paramtype+", "+
			" "+browsertypeSqlStr+", "+compareoption1+", "+enabled+", "+df.format(orderNumber)+", '"+StringEscapeUtils.escapeSql(description)+"', "+
			" '"+StringEscapeUtils.escapeSql(definebroswerType)+"', '"+StringEscapeUtils.escapeSql(fielddbtype)+"')";
		rs.executeSql(sql);
	
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"guid1\":"+JSONObject.quote(guid1)+"}");//保存成功
		out.flush();
		return;
		
	}
	
}else if(operation.equals("edit")){//编辑
    Des desObj = new Des();

	String guid1 = Util.null2String(request.getParameter("guid")).trim();
	String name = Util.null2String(request.getParameter("name")).trim();
	int enabled = Util.getIntValue(request.getParameter("enabled"), 0);
	int paramtype = Util.getIntValue(request.getParameter("paramtype"), 0);
	int browsertype = Util.getIntValue(request.getParameter("browsertype"), 0);
	String compareoption1 = Util.null2String(request.getParameter("compareoption1")).trim();
	String description = Util.null2String(request.getParameter("description")).trim();
	description = desObj.strDec(description, Des.KEY1, Des.KEY2, Des.KEY3);
	double orderNumber = Util.getDoubleValue(request.getParameter("orderNumber"), 999);
	String definebroswerType = Util.null2String(request.getParameter("definebroswerType")).trim();
	String fielddbtype1 = Util.null2String(request.getParameter("fielddbtype1")).trim();
	String fielddbtype2 = Util.null2String(request.getParameter("fielddbtype2")).trim();

	String fielddbtype = "";
	if(161==browsertype||162==browsertype){
		fielddbtype = fielddbtype1;
	}else if(256==browsertype||257==browsertype){
		fielddbtype = fielddbtype2;
	}
	
	String browsertypeSqlStr = "NULL";
	if(browsertype>0 && paramtype==3){
		browsertypeSqlStr = browsertype+"";
	}
	
	String sql = "select count(*) cnt from FnaCostStandard where name = '"+StringEscapeUtils.escapeSql(name)+"' and guid1 <> '"+StringEscapeUtils.escapeSql(guid1)+"'";
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(26603,user.getLanguage()))+"}");//名称重复
		out.flush();
		return;
		
	}else{
		boolean haveRecord_fnaCostStandardDefiDtl = false;
		if(!"".equals(guid1)){
			sql = "select count(*) cnt from FnaCostStandardDefiDtl where fcsGuid1 = '"+StringEscapeUtils.escapeSql(guid1)+"'";
			rs.executeQuery(sql);
			haveRecord_fnaCostStandardDefiDtl = (rs.next() && rs.getInt("cnt") > 0);
		}
		
		if(haveRecord_fnaCostStandardDefiDtl){
			sql = "update FnaCostStandard \n" +
					" set name = '"+StringEscapeUtils.escapeSql(name)+"', "+
					" compareoption1 = "+compareoption1+", "+
					" enabled = "+enabled+", "+
					" orderNumber = "+df.format(orderNumber)+", "+
					" definebroswerType = '"+StringEscapeUtils.escapeSql(definebroswerType)+"', "+
					" description = '"+StringEscapeUtils.escapeSql(description)+"' "+
					" where guid1 = '"+StringEscapeUtils.escapeSql(guid1)+"'";
		}else{
			sql = "update FnaCostStandard \n" +
				" set name = '"+StringEscapeUtils.escapeSql(name)+"', "+
				" paramtype = "+paramtype+", "+
				" browsertype = "+browsertypeSqlStr+", "+
				" compareoption1 = "+compareoption1+", "+
				" enabled = "+enabled+", "+
				" orderNumber = "+df.format(orderNumber)+", "+
				" definebroswerType = '"+StringEscapeUtils.escapeSql(definebroswerType)+"', "+
				" fielddbtype = '"+StringEscapeUtils.escapeSql(fielddbtype)+"', "+
				" description = '"+StringEscapeUtils.escapeSql(description)+"' "+
				" where guid1 = '"+StringEscapeUtils.escapeSql(guid1)+"'";
		}
		rs.executeSql(sql);
	
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"guid1\":"+JSONObject.quote(guid1)+"}");//保存成功
		out.flush();
		return;
		
	}
	
}else if(operation.equals("del")){//删除、批量删除费控流程
	String ids = Util.null2String(request.getParameter("guid"));
	
	String sql = "";

	String[] idsArray = ids.split(",");
	for(int i=0;i<idsArray.length;i++){
		sql = "select count(*) cnt from FnaCostStandardDefiDtl where fcsGuid1 = '"+StringEscapeUtils.escapeSql(idsArray[i])+"'";
		rs.executeQuery(sql);
		boolean haveRecord_fnaCostStandardDefiDtl = (rs.next() && rs.getInt("cnt") > 0);
		if(!haveRecord_fnaCostStandardDefiDtl){
			sql = "select fcsdGuid1 from FnaCostStandardDefiDtl where fcsGuid1 = '"+StringEscapeUtils.escapeSql(idsArray[i])+"'";
			rs.executeSql(sql);
			while(rs.next()){
				String fcsdGuid1 = Util.null2String(rs.getString("fcsdGuid1"));
				
				sql = "delete from FnaCostStandardDefiDtl where fcsdGuid1 = '"+StringEscapeUtils.escapeSql(fcsdGuid1)+"'";
				rs1.executeSql(sql);
				
				sql = "delete from FnaCostStandardDefi where guid1 = '"+StringEscapeUtils.escapeSql(fcsdGuid1)+"'";
				rs1.executeSql(sql);
			}
			sql = "delete from FnaCostStandard where guid1 = '"+StringEscapeUtils.escapeSql(idsArray[i])+"'";
			rs.executeSql(sql);
		}
	}
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("enable")){//启用、禁用 流程
	String id = Util.null2String(request.getParameter("guid"));
	int enabled = 0;
	
	String sql = "select enabled from FnaCostStandard where guid1 = '"+StringEscapeUtils.escapeSql(id)+"'";
	rs.executeSql(sql);
	if(rs.next()){
		enabled = rs.getInt("enabled");
		
		if(enabled == 1){
			enabled = 0;
		}else{
			enabled = 1;
		}

		sql = "update FnaCostStandard set enabled = "+enabled+" where guid1 = '"+StringEscapeUtils.escapeSql(id)+"'";
		rs.executeSql(sql);
	}
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote("")+",\"enable\":"+enabled+"}");
	out.flush();
	return;
	
}
%>
