
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util,net.sf.json.JSONObject"%>
<%@ page import="weaver.hrm.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page" />
<jsp:useBean id="DocReceiveUnitManager" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page" />
<%
	User user = HrmUserVarify.getUser(request, response);
	if(user == null)  return ;
	String cancelFlag = request.getParameter("cancelFlag");
	String isWfDoc = Util.null2String(request.getParameter("isWfDoc"));
	int receiveUnitId = Util.getIntValue(request.getParameter("receiveUnitId"));
	int userId = Util.getIntValue(request.getParameter("userId"));
	String subcompanyId = DocReceiveUnitComInfo.getSubcompanyid(""+receiveUnitId);
	String method = Util.null2String(request.getParameter("method"));
	JSONObject json = new JSONObject();
	if(method.equals("Delete")){
		String result = DocReceiveUnitManager.getReceiveUnitCheckbox(""+receiveUnitId);
		if("0".equalsIgnoreCase(result)){
			String sql = "delete from DocReceiveUnit where id="+receiveUnitId;
			RecordSet.executeSql(sql);
			log.insSysLogInfo(user, receiveUnitId, DocReceiveUnitComInfo.getReceiveUnitName(""+receiveUnitId), sql,  isWfDoc.equals("1")?"348":"221", "3", 0, request.getRemoteAddr());
		    String superiorUnitId=DocReceiveUnitComInfo.getSuperiorUnitId(""+receiveUnitId);
		    DocReceiveUnitComInfo.deleteDocReceiveUnitInfoCache(""+receiveUnitId);
		    json.put("superiorUnitId",superiorUnitId);
		}
		json.put("result",result);
		out.println(json.toString());
	    return;
	}else{
		if ("1".equals(cancelFlag)) {
			String sqlstr = " select id from DocReceiveUnit a where canceled='1' and exists (select 1 from DocReceiveUnit where superiorUnitId=a.id and id="+receiveUnitId+")";
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
				json.put("subcompanyId",subcompanyId);
				json.put("result","1");
		        out.println(json.toString());
			} else {
				String sql = "update DocReceiveUnit set canceled = '0' where id ="+ receiveUnitId;
				RecordSet.executeSql(sql);
				log.insSysLogInfo(user, receiveUnitId, DocReceiveUnitComInfo.getReceiveUnitName(""+receiveUnitId), sql, isWfDoc.equals("1")?"348":"221", "27", 0, request.getRemoteAddr());
				json.put("result","1");
				out.println(json.toString());
			}
		} else {
			String sqlstr = " select id from DocReceiveUnit where  (canceled = '0' or canceled is null) and superiorUnitId="+receiveUnitId;
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
				json.put("subcompanyId",subcompanyId);
				json.put("result","1");
		        out.println(json.toString());
			} else {
				String sql = "update DocReceiveUnit set canceled = '1' where id ="+ receiveUnitId;
				RecordSet.executeSql(sql);
				log.insSysLogInfo(user, receiveUnitId, DocReceiveUnitComInfo.getReceiveUnitName(""+receiveUnitId), sql, isWfDoc.equals("1")?"348":"221", "28", 0, request.getRemoteAddr());
				json.put("result","1");
				out.println(json.toString());
			}
		}
		DocReceiveUnitComInfo.removeDocReceiveUnitCache();
	}
%>
