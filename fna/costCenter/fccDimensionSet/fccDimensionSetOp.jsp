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

<%@page import="weaver.systeminfo.SysMaintenanceLog"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer result = new StringBuffer();
SysMaintenanceLog sysMaintenanceLog = new SysMaintenanceLog();  //声明日志操作对象的变量

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
	
	String _sql = "";
	if("save".equals(op)){
		int id = Util.getIntValue(request.getParameter("id"), 0);
		String name = Util.null2String(request.getParameter("name")).trim();
		String type = Util.null2String(request.getParameter("type")).trim();
		String fielddbtype1 = Util.null2String(request.getParameter("fielddbtype1")).trim();
		String fielddbtype2 = Util.null2String(request.getParameter("fielddbtype2")).trim();
		double displayOrder = Util.getDoubleValue(request.getParameter("displayOrder"), 0.0);

		String fielddbtype = "";
		if("161".equals(type)||"162".equals(type)){
			fielddbtype = fielddbtype1;
		}else if("256".equals(type)||"257".equals(type)){
			fielddbtype = fielddbtype2;
		}

		if(!"".equals(name)){
			rs1.executeSql("select count(*) cnt from fnaFccDimension where name = '"+StringEscapeUtils.escapeSql(name)+"' and id <> "+id);
			if(rs1.next() && rs1.getInt("cnt") > 0){
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelNames("129735,18082",user.getLanguage()))+"}");
				out.flush();
				return;
			}
		}
		
		if(id > 0){
			rs1.executeSql("select * from fnaFccDimension where id = "+id);
			if(rs1.next()){
				List<String> fccId_list = new ArrayList<String>();
				String db_type = Util.null2String(rs1.getString("type")).trim();
				String db_fielddbtype = Util.null2String(rs1.getString("fielddbtype")).trim();
				if(!type.equals(db_type) || fielddbtype.equals(db_fielddbtype)){
					StringBuilder fccName = new StringBuilder();
					_sql = "select a.id, a.name, a.code \n" +
						" from FnaCostCenter a \n" +
						" join FnaCostCenterDtl b on a.id = b.fccId \n" +
						" where b.type in ("+(id*-1)+") \n" +
						" order by a.code, a.name ";
					rs2.executeSql(_sql);
					while(rs2.next()){
						String _fccId = Util.null2String(rs2.getString("id")).trim();
						if(!fccId_list.contains(_fccId)){
							if(fccName.length() > 0){
								fccName.append(", ");
							}
							fccName.append(Util.null2String(rs2.getString("name")).trim());
							fccId_list.add(_fccId);
						}
					}
					if(fccName.length() > 0){
						out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(129736,user.getLanguage())+"<br>"+fccName.toString())+"}");//维度已经被使用无法修改/删除
						out.flush();
						return;
					}
				}
			}
			
			_sql = "update fnaFccDimension "+
				" set name='"+StringEscapeUtils.escapeSql(name)+"', "+
				" type='"+StringEscapeUtils.escapeSql(type)+"', "+
				" fielddbtype='"+StringEscapeUtils.escapeSql(fielddbtype)+"', "+
				" displayOrder="+displayOrder+" "+
				" where id = "+id;
			rs1.executeSql(_sql);
			
			sysMaintenanceLog.resetParameter() ; 
			sysMaintenanceLog.setRelatedId(id) ; 
			sysMaintenanceLog.setRelatedName(name) ; 
			sysMaintenanceLog.setOperateType("2") ; 
			sysMaintenanceLog.setOperateDesc("name:"+name+"; type:"+type+"; fielddbtype:"+fielddbtype+"; displayOrder:"+displayOrder) ; 
			sysMaintenanceLog.setOperateItem("61410002") ; 
			sysMaintenanceLog.setOperateUserid(user.getUID()) ; 
			sysMaintenanceLog.setClientAddress(FnaCommon.getRemoteAddr(request)) ; 
			sysMaintenanceLog.setSysLogInfo() ; 
			
		}else{
			_sql = "insert into fnaFccDimension (name, type, fielddbtype, displayOrder) "+
				"values ('"+StringEscapeUtils.escapeSql(name)+"', '"+StringEscapeUtils.escapeSql(type)+"', '"+StringEscapeUtils.escapeSql(fielddbtype)+"', "+displayOrder+")";
			rs1.executeSql(_sql);
			
			sysMaintenanceLog.resetParameter() ; 
			sysMaintenanceLog.setRelatedId(id) ; 
			sysMaintenanceLog.setRelatedName(name) ; 
			sysMaintenanceLog.setOperateType("1") ; 
			sysMaintenanceLog.setOperateDesc("name:"+name+"; type:"+type+"; fielddbtype:"+fielddbtype+"; displayOrder:"+displayOrder) ; 
			sysMaintenanceLog.setOperateItem("61410002") ; 
			sysMaintenanceLog.setOperateUserid(user.getUID()) ; 
			sysMaintenanceLog.setClientAddress(FnaCommon.getRemoteAddr(request)) ; 
			sysMaintenanceLog.setSysLogInfo() ; 
		}
		
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
		out.flush();
		return;
		
	}else if("del".equals(op) || "batchDel".equals(op)){
		String batchDelIds = Util.null2String(request.getParameter("batchDelIds")).trim();
		if("del".equals(op)){
			int id = Util.getIntValue(request.getParameter("id"), 0);
			batchDelIds = id+",";
		}
		batchDelIds += "-1";

		StringBuffer idsNew = new StringBuffer();
		String[] batchDelIds_array = batchDelIds.split(",");
		int batchDelIds_array_len = batchDelIds_array.length;
		for(int i=0;i<batchDelIds_array_len;i++){
			int batchDelId = Util.getIntValue(batchDelIds_array[i]);
			if(batchDelId > 0){
				if(idsNew.length() > 0){
					idsNew.append(",");
				}
				idsNew.append(batchDelId*-1);
			}
		}
		if(idsNew.length() > 0){
			List<String> fccId_list = new ArrayList<String>();
			StringBuilder fccName = new StringBuilder();
			_sql = "select a.id, a.name, a.code \n" +
				" from FnaCostCenter a \n" +
				" join FnaCostCenterDtl b on a.id = b.fccId \n" +
				" where b.type in ("+idsNew.toString()+") \n" +
				" order by a.code, a.name ";
			rs2.executeSql(_sql);
			while(rs2.next()){
				String _fccId = Util.null2String(rs2.getString("id")).trim();
				if(!fccId_list.contains(_fccId)){
					if(fccName.length() > 0){
						fccName.append(", ");
					}
					fccName.append(Util.null2String(rs2.getString("name")).trim());
					fccId_list.add(_fccId);
				}
			}
			if(fccName.length() > 0){
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(129736,user.getLanguage())+"<br>"+fccName.toString())+"}");//维度已经被使用无法修改/删除
				out.flush();
				return;
			}
		}
		
		
		String[] batchDelIds_array1 = batchDelIds.split(",");
		for(int i=0;i<batchDelIds_array1.length;i++){
			int delId = Util.getIntValue(batchDelIds_array1[i]);
			String _delsql = "select name from fnaFccDimension where id=?";
			String delName ="";
			rs2.executeQuery(_delsql,delId);
			while(rs2.next()){
				delName = Util.null2String(rs2.getString("name"));
			}
			if(delId > 0){
				sysMaintenanceLog.resetParameter() ; 
				sysMaintenanceLog.setRelatedId(delId) ; 
				sysMaintenanceLog.setRelatedName(delName) ; 
				sysMaintenanceLog.setOperateType("3") ; 
				sysMaintenanceLog.setOperateDesc("delId："+delId+";") ; 
				sysMaintenanceLog.setOperateItem("61410002") ; 
				sysMaintenanceLog.setOperateUserid(user.getUID()) ; 
				sysMaintenanceLog.setClientAddress(FnaCommon.getRemoteAddr(request)) ; 
				sysMaintenanceLog.setSysLogInfo() ;
			}
		}
		
		_sql = "DELETE from fnaFccDimension where id in ("+batchDelIds+")";
		rs1.executeSql(_sql);
		
		
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
		out.flush();
		return;
	}
}
%>