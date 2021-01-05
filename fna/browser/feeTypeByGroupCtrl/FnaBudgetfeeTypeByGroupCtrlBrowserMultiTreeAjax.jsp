<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	int userId = user.getUID();
	
	String id = Util.null2String(request.getParameter("id"));
	String name = Util.null2String(request.getParameter("name"));
	String otherParam = Util.null2String(request.getParameter("otherParam"));
	String feeperiod = Util.null2String(request.getParameter("feeperiod"));

	if("".equals(id)){//初始化组织架构树
		String _id = "0";
		String _name = SystemEnv.getHtmlLabelName(33026,user.getLanguage());//所有科目
		String _feelevel = "0";
		
		result.append("{"+
			"id:"+JSONObject.quote(_feelevel+"_"+_id)+","+
			"name:"+JSONObject.quote(_name)+","+
			"isParent:true"+
			//"icon:"+JSONObject.quote("/images/treeimages/global16_wev8.gif")+
			"}");
		
	}else{
		String[] idArray = id.split("_");
		int feelevel = Util.getIntValue(idArray[0], -10)+1;
		id = idArray[1];
		
		int idx = 0;
		String sql1 = "select a.id, a.name, a.codename, a.feelevel, a.Archive from FnaBudgetfeeType a "+
			" where a.feelevel = "+feelevel+" "+
			" and a.supsubject = "+Util.getIntValue(id)+" ";
		if(Util.getIntValue(id, 0)==0 && Util.getIntValue(feeperiod, 0) > 0){
			sql1 += " and a.feeperiod = "+Util.getIntValue(feeperiod, 0)+" and a.feelevel = 1 ";
		}
		sql1 += " ORDER BY a.displayOrder, a.codename, a.name, a.id ";
		rs1.executeSql(sql1);
		while(rs1.next()){
			String _id = rs1.getString("id");
			String _name = rs1.getString("name");
			int _feelevel = Util.getIntValue(rs1.getString("feelevel"));
			int _canceled = Util.getIntValue(rs1.getString("Archive"), 0);
			
			String _name1 = _name;
			if(_canceled == 1){
				_name1 += "("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")";//封存
				continue;
			}
			
			if(idx>0){
				result.append(",");
			}
			
			String icon = "/images/treeimages/home16_wev8.gif";
			
			String isParent = "true";
			String sql2 = "select count(*) cnt from FnaBudgetfeeType a where a.supsubject = "+Util.getIntValue(_id);
			rs2.executeSql(sql2);
			if(rs2.next() && rs2.getInt("cnt") > 0){
				isParent = "true";
			}else{
				isParent = "false";
			}
			
			result.append("{"+
				"id:"+JSONObject.quote(_feelevel+"_"+_id)+","+
				"name:"+JSONObject.quote(_name1)+","+
				"isParent:"+isParent+""+
				//"icon:"+JSONObject.quote(icon)+
				"}");
			idx++;
		}
		
	}

}
//System.out.println("result="+result.toString());
%><%="["+result.toString()+"]" %>