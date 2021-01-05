<%@page import="weaver.fna.fnaVoucher.FnaCreateXml"%>
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

if(!HrmUserVarify.checkUserRight("intergration:financesetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("##############################0.00");
String operation = Util.null2String(request.getParameter("operation"));


if(operation.equals("save_fnaVoucherXml")){
	Des desObj = new Des();
	
	int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"), 0);
	int fnaVoucherXmlContentId = Util.getIntValue(request.getParameter("fnaVoucherXmlContentId"), 0);
	int isXmlContent = Util.getIntValue(request.getParameter("isXmlContent"), 0);
	
	String xmlName = Util.null2String(request.getParameter("xmlName")).trim();
	String xmlEncoding = Util.null2String(request.getParameter("xmlEncoding")).trim();
	String xmlVersion = Util.null2String(request.getParameter("xmlVersion")).trim();
	String xmlMemo = Util.null2String(request.getParameter("xmlMemo")).trim();
	String workflowid = Util.getIntValue(request.getParameter("workflowid"), 0)+"";
	String interfacesAddress = Util.null2String(request.getParameter("interfacesAddress")).trim();
	String datasourceid = Util.null2String(request.getParameter("datasourceid")).trim();

	workflowid = (Util.getIntValue(workflowid, 0)>0?workflowid:"NULL");
	interfacesAddress = desObj.strDec(interfacesAddress, Des.KEY1, Des.KEY2, Des.KEY3);
	datasourceid = desObj.strDec(datasourceid, Des.KEY1, Des.KEY2, Des.KEY3);
	

	
	rs.executeSql("select count(*) cnt from fnaVoucherXml "+
		" where id <> "+fnaVoucherXmlId+" and xmlName = '"+StringEscapeUtils.escapeSql(xmlName)+"'");
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote("XML "+SystemEnv.getHtmlLabelNames("195,18082",user.getLanguage()))+"}");
		out.flush();
		return;
	}

	if(fnaVoucherXmlId<=0){
		rs.executeSql("insert into fnaVoucherXml (xmlName, xmlMemo, xmlVersion, xmlEncoding, workflowid, interfacesAddress, datasourceid, profession) "+
			" values ('"+StringEscapeUtils.escapeSql(xmlName)+"', '"+StringEscapeUtils.escapeSql(xmlMemo)+"', "+
			" '"+StringEscapeUtils.escapeSql(xmlVersion)+"', '"+StringEscapeUtils.escapeSql(xmlEncoding)+"', "+workflowid+", "+
			" '"+StringEscapeUtils.escapeSql(interfacesAddress)+"', '"+StringEscapeUtils.escapeSql(datasourceid)+"', 1) ");
		rs.executeSql("select max(id) maxId from fnaVoucherXml where xmlName = '"+StringEscapeUtils.escapeSql(xmlName)+"'");
		if(rs.next()){
			fnaVoucherXmlId = rs.getInt("maxId");
		}
	}else{
		rs.executeSql("update fnaVoucherXml "+
			" set xmlName = '"+StringEscapeUtils.escapeSql(xmlName)+"', "+
			" xmlMemo = '"+StringEscapeUtils.escapeSql(xmlMemo)+"', "+
			" xmlVersion = '"+StringEscapeUtils.escapeSql(xmlVersion)+"', "+
			" xmlEncoding = '"+StringEscapeUtils.escapeSql(xmlEncoding)+"', "+
			" workflowid = "+workflowid+", "+
			" interfacesAddress = '"+StringEscapeUtils.escapeSql(interfacesAddress)+"', "+
			" datasourceid = '"+StringEscapeUtils.escapeSql(datasourceid)+"', "+
			" profession = 1 "+
			" where id = "+fnaVoucherXmlId);
	}
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+
		",\"fnaVoucherXmlId\":"+fnaVoucherXmlId+",\"parentFnaVoucherXmlContentId\":"+0+"}");
	out.flush();
	return;
	
}else if(operation.equals("delete_fnaVoucherXml") || operation.equals("batchDel_fnaVoucherXml")){

	String batchDelIds = Util.null2String(request.getParameter("batchDelIds"));
	if(operation.equals("delete_fnaVoucherXml")){
		int id = Util.getIntValue(request.getParameter("id"));
		batchDelIds = id+"";
	}
	String[] batchDelIdsArray = batchDelIds.split(",");
	
	for(int i=0;i<batchDelIdsArray.length;i++){
		int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
		if(_delId > 0){
			rs.executeSql("select count(*) cnt \n" +
					"from Workflow_Report b \n" +
					"where b.fnaVoucherXmlId = "+_delId);
			if(rs.next() && rs.getInt("cnt") > 0){
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(124795,user.getLanguage()))+"}");//XML模板正在被使用不能删除
				out.flush();
				return;
			}
			
			rs.executeSql("select count(*) cnt \n" +
					"from financeset b \n" +
					"where b.fnaVoucherXmlId = "+_delId);
			if(rs.next() && rs.getInt("cnt") > 0){
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(124795,user.getLanguage()))+"}");//XML模板正在被使用不能删除
				out.flush();
				return;
			}
		}
	}
	
	for(int i=0;i<batchDelIdsArray.length;i++){
		int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
		if(_delId > 0){
			rs.executeSql("delete from fnaFinancesetting where fnaVoucherXmlId = "+_delId);
			rs.executeSql("delete from fnaDataSet where fnaVoucherXmlId = "+_delId);
			rs.executeSql("delete from fnaVoucherXmlContentDset where fnaVoucherXmlId = "+_delId);
			rs.executeSql("delete from fnaVoucherXmlContent where fnaVoucherXmlId = "+_delId);
			rs.executeSql("delete from fnaVoucherXml where id = "+_delId);
		}
	}
	out.println("{\"flag\":true}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("save_fnaVoucherXmlContent")){
	int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"), 0);
	int fnaVoucherXmlContentId = Util.getIntValue(request.getParameter("fnaVoucherXmlContentId"), 0);
	int isXmlContent = Util.getIntValue(request.getParameter("isXmlContent"), 0);
	
	int contentParentId = Util.getIntValue(request.getParameter("contentParentId"), 0);
	String contentType = Util.null2String(request.getParameter("contentType")).trim();
	String contentName = Util.null2String(request.getParameter("contentName")).trim();
	String contentValueType = Util.null2String(request.getParameter("contentValueType")).trim();
	String contentValue = Util.null2String(request.getParameter("contentValue")).trim();
	String parameter = Util.null2String(request.getParameter("parameter")).trim();
	double orderId = Util.getDoubleValue(request.getParameter("orderId"), 0.00);
	String contentMemo = Util.null2String(request.getParameter("contentMemo")).trim();
	int isNullNotPrint = Util.getIntValue(request.getParameter("isNullNotPrint"), 0);
	int isNullNotPrintNode = Util.getIntValue(request.getParameter("isNullNotPrintNode"), 0);
	String contentValueForContentValueType4 = Util.null2String(request.getParameter("contentValueForContentValueType4")).trim();
	int contentValueForContentValueType6 = Util.getIntValue(request.getParameter("contentValueForContentValueType6"), 0);

	Des desObj = new Des();
	
	if("4".equals(contentValueType)){//表单字段
		contentValue = "";
		parameter = "";
		if("requestid".equals(contentValueForContentValueType4)){
			contentValue = FnaCreateXml.WORKFLOW_MAIN_DATA_SET_ALIAS_NAME1+".requestid";
			
		}else if(Util.getIntValue(contentValueForContentValueType4) > 0){
			String sql = "select fieldname, detailtable, billid from workflow_billfield a where a.id = "+Util.getIntValue(contentValueForContentValueType4);
			rs.executeSql(sql);
			if(rs.next()){
				String fieldname = Util.null2String(rs.getString("fieldname")).trim();
				String detailtable = Util.null2String(rs.getString("detailtable")).trim();
				int formid = Util.getIntValue(rs.getString("billid"));
				int formidABS = Math.abs(formid);
				
				if("".equals(detailtable)){
					contentValue = FnaCreateXml.WORKFLOW_MAIN_DATA_SET_ALIAS_NAME1+"."+fieldname;
				}else{
					int detailtableNumber = Util.getIntValue(detailtable.replaceAll("formtable_main_"+formidABS+"_dt", ""), 0);
					contentValue = FnaCreateXml.WORKFLOW_DETAIL_DATA_SET_ALIAS_NAME1+detailtableNumber+"."+fieldname;
				}
			}
		}
		
	}else if("5".equals(contentValueType)){//流程
		contentValue = "";
		parameter = "";
		
	}else if("6".equals(contentValueType)){//流程明细表
		contentValue = contentValueForContentValueType6+"";
		parameter = "";
		
	}else{
		contentValue = desObj.strDec(contentValue, Des.KEY1, Des.KEY2, Des.KEY3);
		parameter = desObj.strDec(parameter, Des.KEY1, Des.KEY2, Des.KEY3);
	}

	if(fnaVoucherXmlContentId<=0){
		String sql = "insert into fnaVoucherXmlContent (fnaVoucherXmlId, contentType, contentParentId, "+
				" contentName, contentValueType, "+
				" isNullNotPrint, isNullNotPrintNode, "+
				" contentMemo, orderId) "+
				" values ("+fnaVoucherXmlId+", '"+StringEscapeUtils.escapeSql(contentType)+"', "+contentParentId+", "+
				" '"+StringEscapeUtils.escapeSql(contentName)+"', '"+StringEscapeUtils.escapeSql(contentValueType)+"', "+
				" "+isNullNotPrint+", "+isNullNotPrintNode+", "+
				" '"+StringEscapeUtils.escapeSql(contentMemo)+"', "+df.format(orderId)+") ";
		rs.executeSql(sql);
		rs.executeSql("select max(id) maxId from fnaVoucherXmlContent "+
			" where contentValueType = '"+StringEscapeUtils.escapeSql(contentValueType)+"' "+
			" and contentType = '"+StringEscapeUtils.escapeSql(contentType)+"' "+
			" and contentName = '"+StringEscapeUtils.escapeSql(contentName)+"' and orderId = "+df.format(orderId)+" "+
			" and contentParentId = "+contentParentId+" and fnaVoucherXmlId = "+fnaVoucherXmlId);
		if(rs.next()){
			fnaVoucherXmlContentId = rs.getInt("maxId");
		}
	}else{
		String sql = "update fnaVoucherXmlContent "+
			" set contentName = '"+StringEscapeUtils.escapeSql(contentName)+"', "+
			" contentValueType = '"+StringEscapeUtils.escapeSql(contentValueType)+"', "+
			" isNullNotPrint = "+isNullNotPrint+", "+
			" isNullNotPrintNode = "+isNullNotPrintNode+", "+
			" contentMemo = '"+StringEscapeUtils.escapeSql(contentMemo)+"', "+
			" orderId = "+df.format(orderId)+" "+
			" where id = "+fnaVoucherXmlContentId;
		rs.executeSql(sql);
	}
	
	FnaCommon.updateDbClobOrTextFieldValue("fnaVoucherXmlContent", 
			"contentValue", contentValue, 
			"id", fnaVoucherXmlContentId+"", "int");
	
	FnaCommon.updateDbClobOrTextFieldValue("fnaVoucherXmlContent", 
			"parameter", parameter, 
			"id", fnaVoucherXmlContentId+"", "int");
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+
		",\"fnaVoucherXmlId\":"+fnaVoucherXmlId+",\"parentFnaVoucherXmlContentId\":"+contentParentId+","+
		"\"fnaVoucherXmlContentId\":"+fnaVoucherXmlContentId+"}");
	out.flush();
	return;
	
}else if(operation.equals("delete_fnaVoucherXmlContent")){
	int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"));
	int fnaVoucherXmlContentId = Util.getIntValue(request.getParameter("fnaVoucherXmlContentId"));

	int parentFnaVoucherXmlContentId = 0;
	rs.executeSql("select contentParentId from fnaVoucherXmlContent where id = "+fnaVoucherXmlContentId);
	if(rs.next()){
		parentFnaVoucherXmlContentId = Util.getIntValue(rs.getString("contentParentId"), 0);
	}
	
	String batchDelIds = fnaVoucherXmlContentId+"";
	String[] batchDelIdsArray = batchDelIds.split(",");
	
	for(int i=0;i<batchDelIdsArray.length;i++){
		int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
		if(_delId > 0){
			String _sql = "WITH allsub(id,contentParentId)\n" +
					" as (\n" +
					" SELECT id,contentParentId FROM fnaVoucherXmlContent where id="+_delId+" \n" +
					"  UNION ALL SELECT a.id,a.contentParentId FROM fnaVoucherXmlContent a,allsub b where a.contentParentId = b.id\n" +
					" ) select * from allsub";
			if("oracle".equals(rs.getDBType())){
				_sql = "select id,contentParentId from fnaVoucherXmlContent\n" +
					" start with id="+_delId+" \n" +
					" connect by prior id = contentParentId";
			}else if("mysql".equals(rs.getDBType())){
				_sql = "select DISTINCT t.id,t.contentName,t.contentParentId,t.feelevel from (\n" +
					"	select @id idlist, @lv:=@lv+1 lv,\n" +
					"	(select @id:=group_concat(id separator ',') from fnaVoucherXmlContent where find_in_set(contentParentId,@id)) sub\n" +
					"	from fnaVoucherXmlContent,(select @id:="+_delId+",@lv:=0) vars\n" +
					"	where @id is not null) tl,fnaVoucherXmlContent t\n" +
					" where find_in_set(t.id,tl.idlist) " +
							" order by lv asc";
			}
			rs.executeSql(_sql);
			while(rs.next()){
				int _delId1 = rs.getInt("id");
				rs1.executeSql("delete from fnaVoucherXmlContentDset where fnaVoucherXmlContentId = "+_delId1);
				rs1.executeSql("delete from fnaVoucherXmlContent where id = "+_delId1);
				//rs1.executeSql("delete from fnaDataSet where fnaVoucherXmlId = "+fnaVoucherXmlId);
			}
		}
	}
	
	out.println("{\"flag\":true"+
		",\"fnaVoucherXmlId\":"+fnaVoucherXmlId+",\"parentFnaVoucherXmlContentId\":"+parentFnaVoucherXmlContentId+","+
		"\"fnaVoucherXmlContentId\":"+parentFnaVoucherXmlContentId+"}");
	out.flush();
	return;
	
}
%>