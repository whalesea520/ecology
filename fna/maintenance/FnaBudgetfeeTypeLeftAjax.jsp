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
	String _searchStr_lowerCase = Util.null2String(request.getParameter("_searchStr_lowerCase"));
	
	if("".equals(id)){//初始化组织架构树
		id = "0_0";
	}
	
	if("".equals(id) && "".equals(_searchStr_lowerCase)){//初始化组织架构树
		String _id = "0";
		String _name = SystemEnv.getHtmlLabelName(332,user.getLanguage());//全部
		String _feelevel = "0";
		
		result.append("{"+
			"id:"+JSONObject.quote(_feelevel+"_"+_id)+","+
			"name:"+Util.formatMultiLang(JSONObject.quote(_name))+","+
			"isParent:true"+
			//"icon:"+JSONObject.quote("/images/treeimages/global16_wev8.gif")+
			"}");
		
	}else{
		String[] idArray = id.split("_");
		//int feelevel = Util.getIntValue(idArray[0], -10)+1;
		int supsubject = Util.getIntValue(idArray[1]);
		
		int idx = 0;
		StringBuffer sql1 = new StringBuffer("select a.id, a.name, a.codename, a.feelevel, a.feeperiod, a.Archive ");
		sql1.append(" from FnaBudgetfeeType a ");
		sql1.append(" where 1=1 ");
		if(!"".equals(_searchStr_lowerCase)){
			sql1.append(" and (a.name like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%' or a.codename like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%') ");
		}else{
			sql1.append(" and a.supsubject = "+supsubject+" ");
		}
		sql1.append(" ORDER BY a.feeperiod, a.feelevel, a.displayOrder, a.codename, a.name, a.id ");
		rs1.executeSql(sql1.toString());
		while(rs1.next()){
			String _id = rs1.getString("id");
			String _name = rs1.getString("name");
			int _feelevel = Util.getIntValue(rs1.getString("feelevel"));
			int _canceled = Util.getIntValue(rs1.getString("Archive"), 0);
			
			String _name1 = Util.formatMultiLang(_name);
			if(_canceled == 1){
				_name1 += "("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")";//已封存
			}
			
			String isParent = "false";
			if("".equals(_searchStr_lowerCase)){
				String sql2 = "select count(*) cnt from FnaBudgetfeeType a where a.supsubject = "+Util.getIntValue(_id);
				rs2.executeSql(sql2);
				if(rs2.next() && rs2.getInt("cnt") > 0){
					isParent = "true";
				}
			}
			
			if(idx>0){
				result.append(",");
			}
			
			result.append("{"+
				"id:"+JSONObject.quote(_feelevel+"_"+_id)+","+
				"name:"+JSONObject.quote(_name1)+","+
				"isParent:"+isParent+""+
				"}");
			idx++;
		}
		
	}

}
//System.out.println("result="+result.toString());
%><%="["+result.toString()+"]" %>