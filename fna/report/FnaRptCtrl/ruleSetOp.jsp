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

<%@page import="weaver.systeminfo.SysMaintenanceLog"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
	
}else{
	if(!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit",user)){
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

	String fanRptTotalBudget = Util.null2String(request.getParameter("fanRptTotalBudget")).trim();
	String fnaRptImplementation = Util.null2String(request.getParameter("fnaRptImplementation")).trim();
	String costSummary = Util.null2String(request.getParameter("costSummary")).trim();
	String budgetDetailed = Util.null2String(request.getParameter("budgetDetailed")).trim();
	String fanRptCost = Util.null2String(request.getParameter("fanRptCost")).trim();
	
	String allowRptNames = ","+fanRptTotalBudget+","+fnaRptImplementation+","+costSummary+","+budgetDetailed+","+fanRptCost+",";
	
	SysMaintenanceLog sysMaintenanceLog = new SysMaintenanceLog();

	if("add".equals(op) || "edit".equals(op) || "del".equals(op) || "batchDel".equals(op)){
		String operateType = id>0?"2":"1";
		
		if("add".equals(op) || "edit".equals(op)){
			String _sql = "select count(*) cnt from fnaRptRuleSet where id <> "+id+" and roleid = "+roleid;
			rs1.executeSql(_sql);
			if(rs1.next() && rs1.getInt("cnt") > 0){
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(122,user.getLanguage())+SystemEnv.getHtmlLabelName(24943,user.getLanguage()))+"}");//角色已存在
				out.flush();
				return;
			}
		}
		String _sql = "DELETE from fnaRptRuleSetDtl where mainid = (select fnaRptRuleSet.id from fnaRptRuleSet where fnaRptRuleSet.roleid = "+oldroleid+")";
		rs1.executeSql(_sql);
		
		_sql = "DELETE from fnaRptRuleSet where roleid = "+oldroleid;
		rs1.executeSql(_sql);

		if("add".equals(op) || "edit".equals(op)){
			_sql = "insert into fnaRptRuleSet (roleid, name, allowZb, allowFb, allowBm, allowFcc, allowRptNames) "+
				"values ("+roleid+", '"+StringEscapeUtils.escapeSql(name)+"', "+allowZb+", "+allowFb+", "+allowBm+", "+allowFcc+", '"+StringEscapeUtils.escapeSql(allowRptNames)+"')";
			rs1.executeSql(_sql);
			
			_sql = "select id from fnaRptRuleSet where roleid = "+roleid;
			rs1.executeSql(_sql);
			if(rs1.next()){
				id = rs1.getInt("id");

				if(!"".equals(fbids) && allowFb==4){
					String[] fbidsArray = fbids.split(",");
					for(int i=0;i<fbidsArray.length;i++){
						int fbid = Util.getIntValue(fbidsArray[i]);
						if(fbid > 0){
							_sql = "insert into fnaRptRuleSetDtl (mainid, showid, showidtype) values ("+id+", "+fbid+", 1)";
							rs1.executeSql(_sql);
						}
					}
				}

				if(!"".equals(depids) && allowBm==4){
					String[] depidsArray = depids.split(",");
					for(int i=0;i<depidsArray.length;i++){
						int depid = Util.getIntValue(depidsArray[i]);
						if(depid > 0){
							_sql = "insert into fnaRptRuleSetDtl (mainid, showid, showidtype) values ("+id+", "+depid+", 2)";
							rs1.executeSql(_sql);
						}
					}
				}

				if(!"".equals(fccids) && allowFcc==4){
					String[] fccidsArray = fccids.split(",");
					for(int i=0;i<fccidsArray.length;i++){
						int fccid = Util.getIntValue(fccidsArray[i]);
						if(fccid > 0){
							_sql = "insert into fnaRptRuleSetDtl (mainid, showid, showidtype) values ("+id+", "+fccid+", "+FnaCostCenter.ORGANIZATION_TYPE+")";
							rs1.executeSql(_sql);
						}
					}
				}
			}
			


			String roleName = "";
			String sql1 = "SELECT a.rolesmark from HrmRoles a where id = "+roleid;
			rs1.executeSql(sql1);
			if(rs1.next()){
				roleName = Util.null2String(rs1.getString("rolesmark")).trim();
			}

			sysMaintenanceLog.resetParameter() ; 
			sysMaintenanceLog.setRelatedId(id) ; 
			sysMaintenanceLog.setRelatedName(roleName) ; 
			sysMaintenanceLog.setOperateType(operateType) ; 
			sysMaintenanceLog.setOperateDesc("name："+name+"；"+"roleid："+roleid+"；"+"；"+"depids："+depids+"；"+
					"oldroleid："+oldroleid+"；"+"allowZb："+allowZb+"；"+"；"+"allowFb："+allowFb+"；"+
					"allowBm："+allowBm+"；"+"allowFcc："+allowFcc+"；"+"；"+"fbids："+fbids+"；"+
					"fccids："+fccids+"；"+"allowRptNames："+allowRptNames+"；") ; 
			sysMaintenanceLog.setOperateItem("61410001") ; 
			sysMaintenanceLog.setOperateUserid(user.getUID()) ; 
			sysMaintenanceLog.setClientAddress(FnaCommon.getRemoteAddr(request)) ; 
			sysMaintenanceLog.setSysLogInfo() ; 
			
			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
			out.flush();
			return;
			
		}else if("del".equals(op) || "batchDel".equals(op)){
			String batchDelIds = Util.null2String(request.getParameter("batchDelIds")).trim();
			if("del".equals(op)){
				batchDelIds = id+",";
			}
			batchDelIds += "-1";

			StringBuilder roleName = new StringBuilder();
			_sql = "select distinct a.roleid, b.rolesmark "+
				" from fnaRptRuleSet a join HrmRoles b on a.roleid = b.id "+
				" where a.id in ("+batchDelIds+")";
			rs2.executeSql(_sql);
			while(rs2.next()){
				if(roleName.length() > 0){
					roleName.append(", ");
				}
				roleName.append(Util.null2String(rs2.getString("rolesmark")).trim()+"("+rs2.getInt("roleid")+")");
			}
			
			_sql = "DELETE from fnaRptRuleSetDtl where mainid in ("+batchDelIds+")";
			rs1.executeSql(_sql);
			
			_sql = "DELETE from fnaRptRuleSet where id in ("+batchDelIds+")";
			rs1.executeSql(_sql);
			
			

			sysMaintenanceLog.resetParameter() ; 
			sysMaintenanceLog.setRelatedId(id) ; 
			sysMaintenanceLog.setRelatedName(roleName.toString()) ; 
			sysMaintenanceLog.setOperateType("3") ; 
			sysMaintenanceLog.setOperateDesc("batchDelIds："+batchDelIds+"；") ; 
			sysMaintenanceLog.setOperateItem("61410001") ; 
			sysMaintenanceLog.setOperateUserid(user.getUID()) ; 
			sysMaintenanceLog.setClientAddress(FnaCommon.getRemoteAddr(request)) ; 
			sysMaintenanceLog.setSysLogInfo() ; 
			
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