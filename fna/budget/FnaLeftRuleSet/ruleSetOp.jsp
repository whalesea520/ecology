<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
	
}else{
	if(!HrmUserVarify.checkUserRight("BudgetOrgPermission:settings",user) && !HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit",user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String op = Util.null2String(request.getParameter("op")).trim();
	int id = Util.getIntValue(request.getParameter("id"), 0);
	String name = Util.null2String(request.getParameter("name")).trim();
	int roleid = Util.getIntValue(request.getParameter("field6599"), 0);
	String depids = Util.null2String(request.getParameter("field6855")).trim();
	int oldroleid = Util.getIntValue(request.getParameter("oldroleid"), 0);
	int allowZb = Util.getIntValue(request.getParameter("allowZb"), 0);
	int allowFb = Util.getIntValue(request.getParameter("allowFb"), 0);
	int allowBm = Util.getIntValue(request.getParameter("allowBm"), 0);
	int allowFcc = Util.getIntValue(request.getParameter("allowFcc"), 0);
	String fbids = Util.null2String(request.getParameter("field6341")).trim();
	String fccids = Util.null2String(request.getParameter("fccids")).trim();

	if("add".equals(op) || "edit".equals(op) || "del".equals(op) || "batchDel".equals(op)){
		String operateType = id>0?"2":"1";
		
		if("add".equals(op) || "edit".equals(op)){
			String _sql = "select count(*) cnt from FnaRuleSet where id <> "+id+" and roleid = "+roleid;
			rs1.executeSql(_sql);
			if(rs1.next() && rs1.getInt("cnt") > 0){
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(122,user.getLanguage())+SystemEnv.getHtmlLabelName(24943,user.getLanguage()))+"}");//角色已存在
				out.flush();
				return;
			}
		}
		String _sql = "DELETE from FnaRuleSetDtl where mainid = (select FnaRuleSet.id from FnaRuleSet where FnaRuleSet.roleid = "+oldroleid+")";
		rs1.executeSql(_sql);
		
		_sql = "DELETE from FnaRuleSet where roleid = "+oldroleid;
		rs1.executeSql(_sql);

		if("add".equals(op) || "edit".equals(op)){
			_sql = "insert into FnaRuleSet (roleid, name, allowZb, allowFb, allowBm, allowFcc) "+
				"values ("+roleid+", '"+StringEscapeUtils.escapeSql(name)+"', "+allowZb+", "+allowFb+", "+allowBm+", "+allowFcc+")";
			rs1.executeSql(_sql);
			
			_sql = "select id from FnaRuleSet where roleid = "+roleid;
			rs1.executeSql(_sql);
			if(rs1.next()){
				id = rs1.getInt("id");

				if(!"".equals(fbids) && allowFb==4){
					String[] fbidsArray = fbids.split(",");
					for(int i=0;i<fbidsArray.length;i++){
						int fbid = Util.getIntValue(fbidsArray[i]);
						if(fbid > 0){
							_sql = "insert into FnaRuleSetDtl (mainid, showid, showidtype) values ("+id+", "+fbid+", 1)";
							rs1.executeSql(_sql);
						}
					}
				}

				if(!"".equals(depids) && allowBm==4){
					String[] depidsArray = depids.split(",");
					for(int i=0;i<depidsArray.length;i++){
						int depid = Util.getIntValue(depidsArray[i]);
						if(depid > 0){
							_sql = "insert into FnaRuleSetDtl (mainid, showid, showidtype) values ("+id+", "+depid+", 2)";
							rs1.executeSql(_sql);
						}
					}
				}

				if(!"".equals(fccids) && allowFcc==4){
					String[] fccidsArray = fccids.split(",");
					for(int i=0;i<fccidsArray.length;i++){
						int fccid = Util.getIntValue(fccidsArray[i]);
						if(fccid > 0){
							_sql = "insert into FnaRuleSetDtl (mainid, showid, showidtype) values ("+id+", "+fccid+", "+FnaCostCenter.ORGANIZATION_TYPE+")";
							rs1.executeSql(_sql);
						}
					}
				}
			}
			
			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
			out.flush();
			return;
			
		}else if("del".equals(op) || "batchDel".equals(op)){
			String batchDelIds = Util.null2String(request.getParameter("batchDelIds")).trim();
			if("del".equals(op)){
				batchDelIds = id+",";
			}
			batchDelIds += "-1";
			
			_sql = "DELETE from FnaRuleSetDtl where mainid in ("+batchDelIds+")";
			rs1.executeSql(_sql);
			
			_sql = "DELETE from FnaRuleSet where id in ("+batchDelIds+")";
			rs1.executeSql(_sql);
			
			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
			out.flush();
			return;
		}
		
	}else{
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
}
%>