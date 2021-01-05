<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.Util"%>
<%@ page import="net.sf.json.*"%>
<jsp:useBean id="rs_common" class="weaver.conn.RecordSet" scope="page" />
<%
String optMode = Util.null2String(request.getParameter("optMode"));
int reportId = Util.getIntValue(request.getParameter("reportid"));
String operationSql = "";
JSONArray aJSON = new JSONArray();
JSONObject oJSON = new JSONObject();


if("getModeReportField".equals(optMode)){
	String reportFieldId = "";
	String reportFieldName = "";
	String reportFieldLabel = "";
	rs_common.executeSql("select * from mode_customsearch where id="+reportId+"");
    boolean isVirtualForm = false;
    if(rs_common.next()){
    	isVirtualForm = VirtualFormHandler.isVirtualForm(Util.getIntValue(rs_common.getString("formid"),0));
    }
    if(!isVirtualForm){
	operationSql = "select * from mode_CustomDspField where fieldid in(-1,-2) and isshow=1 and customid="+reportId+" order by fieldid asc";
	rs_common.executeSql(operationSql);
	while(rs_common.next()){
		reportFieldId = Util.null2String(rs_common.getString("fieldid"));
		if("-1".equals(reportFieldId)){
			reportFieldLabel = SystemEnv.getHtmlLabelName(722,user.getLanguage());
		}else if("-2".equals(reportFieldId)){
			reportFieldLabel = SystemEnv.getHtmlLabelName(882,user.getLanguage());
		}
		oJSON.put("fieldid", reportFieldId);
		oJSON.put("fieldname", reportFieldName);
		oJSON.put("fieldlabel", reportFieldLabel);
		aJSON.add(oJSON);
	}
    }

	operationSql = "select a.fieldid, b.fieldname, c.labelname from mode_CustomDspField a left join workflow_billfield b on a.fieldid=b.id left join HtmlLabelInfo c on b.fieldlabel=c.indexid ";
	operationSql+= "where a.customid="+reportId+" and isshow=1 and c.languageid="+user.getLanguage()+" ";
	//operationSql+= "order by a.dborder asc";
	rs_common.executeSql(operationSql);
	while(rs_common.next()){
		reportFieldId = Util.null2String(rs_common.getString("fieldid"));
		reportFieldName = Util.null2String(rs_common.getString("fieldname"));
		reportFieldLabel = Util.null2String(rs_common.getString("labelname"));
		oJSON.put("fieldid", reportFieldId);
		oJSON.put("fieldname", reportFieldName);
		oJSON.put("fieldlabel", reportFieldLabel);
		aJSON.add(oJSON);
	}
	out.println(aJSON);
}
%>
