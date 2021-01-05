
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<%
int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
int childfieldid = Util.getIntValue(request.getParameter("childfieldid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int selectvalue = Util.getIntValue(request.getParameter("selectvalue"), -1);
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);

JSONArray selectOptionlist = new JSONArray(); 
String sql = "";
sql = "select childitemid from workflow_selectitem where fieldid="+fieldid+" and isbill="+isbill+" and selectvalue="+selectvalue;
rs.execute(sql);
if(rs.next()){
	String childitemid = Util.null2String(rs.getString("childitemid"));
	if(!"".equals(childitemid.trim())){
		if(!"".equals(childitemid)){
			if(childitemid.indexOf(",")==0){
				childitemid = childitemid.substring(1);
			}
			if(childitemid.endsWith(",")){
				childitemid = childitemid.substring(0, childitemid.length()-1);
			}
			sql = "select id, selectvalue, selectname, listorder from workflow_selectitem where fieldid="+childfieldid+" and isbill="+isbill+" and selectvalue in ("+childitemid+") and ( cancel!=1 or cancel is null) order by listorder, id asc";
			rs_item.execute(sql);
			while(rs_item.next()){
				String selectvalue_tmp = Util.null2String(rs_item.getString("selectvalue"));
				String selectname_tmp = Util.formatMultiLang(Util.toScreen(rs_item.getString("selectname"), 7));
				JSONObject selectOption=new JSONObject();
				selectOption.put("value",selectvalue_tmp);
				selectOption.put("text",selectname_tmp);
				selectOptionlist.add(selectOption);
			}
		}
	}
}

out.println(selectOptionlist.toString());
%>
