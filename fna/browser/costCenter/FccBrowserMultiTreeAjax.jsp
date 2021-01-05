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
<jsp:useBean id="FnaCommon" class="weaver.fna.general.FnaCommon" scope="page" />
<jsp:useBean id="FnaCostCenter" class="weaver.fna.maintenance.FnaCostCenter" scope="page" />
<%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	int userId = user.getUID();
	
	String id = Util.null2String(request.getParameter("id"));
	String name = Util.null2String(request.getParameter("name"));
	String otherParam = Util.null2String(request.getParameter("otherParam"));
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	String fieldid = Util.null2String(request.getParameter("fieldid"));

	if("".equals(id)){//初始化组织架构树
		//id = "0_0";
	}

	if("".equals(id)){//初始化组织架构树
		String _id = "0";
		String _name = SystemEnv.getHtmlLabelName(515,user.getLanguage());//成本中心
		String _type = "0";
		
		result.append("{"+
			"id:"+JSONObject.quote(_type+"_"+_id)+","+
			"name:"+JSONObject.quote(_name)+","+
			"isParent:true"+
			//"icon:"+JSONObject.quote("/images/treeimages/global16_wev8.gif")+
			"}");
		
	}else{
		
		List fccArray = FnaCommon.getWfBrowdefList(workflowid, fieldid, "251");
		Set fccArray0 = new HashSet();
		Set fccArray1 = new HashSet();
		try{
			if(fccArray.size()>0){
				FnaCostCenter.getAllSubCostcenterType(fccArray, fccArray0, fccArray1);
			}
		}catch(Exception e){
			rs1.writeLog(e);
		}
		
		String[] idArray = id.split("_");
		int feelevel = Util.getIntValue(idArray[0], -10)+1;
		id = idArray[1];
		
		int idx = 0;
		String sql1 = "select a.id, a.type, a.name, a.code, a.Archive from FnaCostCenter a "+
			" where a.supFccId = "+Util.getIntValue(id)+" and a.type=0 "+
			" ORDER BY a.type, a.code, a.name, a.id ";
		rs1.executeSql(sql1);
		while(rs1.next()){
			String _id = rs1.getString("id");
			int _type = Util.getIntValue(rs1.getString("type"));
			String _name = rs1.getString("name");
			String _code = rs1.getString("code");
			int _canceled = Util.getIntValue(rs1.getString("Archive"), 0);
			
			String _name1 = _name;
			if(_canceled == 1){
				_name1 += "("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")";//已封存
				continue;
			}
			
			if(fccArray.size() > 0 && !fccArray0.contains(_id) && !fccArray1.contains(_id)){
				continue;
			}
			
			if(idx>0){
				result.append(",");
			}
			
			String icon = "/images/treeimages/home16_wev8.gif";
			if(_type == 1){
				icon = "/images/treeimages/dept16_wev8.gif";
			}
			
			String isParent = "true";
			if(_type == 1){
				isParent = "false";
			}else{
				String sql2 = "select count(*) cnt from FnaCostCenter a where a.supFccId = "+Util.getIntValue(_id);
				rs2.executeSql(sql2);
				if(rs2.next() && rs2.getInt("cnt") > 0){
					isParent = "true";
				}else{
					isParent = "false";
				}
			}
			
			result.append("{"+
				"id:"+JSONObject.quote(_type+"_"+_id)+","+
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